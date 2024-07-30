library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port(	rst 	: in std_logic;
			clk 	: in std_logic;
			instr_op: in unsigned(3 downto 0);
			reg_d 	: in std_logic;
			aluOp	: out unsigned(1 downto 0);
			state	: out unsigned(1 downto 0);
			aluSrcA : out std_logic;
			jump_en : out std_logic;
			br_src : out std_logic;
			acc_en	: out std_logic;
			pcWrite_en, regWrite_en, instWrite_en: out std_logic
		);
end entity;

architecture a_control of control is

	component stateMachine is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			estado  : out unsigned(1 downto 0)
		);
	end component;
	
	signal estado : unsigned(1 downto 0);
	signal opcode: unsigned(3 downto 0);
	
	--opcodes das instruções
	constant jump_op : unsigned(3 downto 0) := "1111";
	constant add_op : unsigned(3 downto 0) := "0001";  
	constant addi_op : unsigned(3 downto 0) := "0010";  
	constant sub_op : unsigned(3 downto 0) := "0011";  
	constant subi_op : unsigned(3 downto 0) := "0100";
	constant ld_op : unsigned(3 downto 0) := "0110";
	constant mov_op : unsigned(3 downto 0) := "0101";
	
	begin
	
	stMachine : stateMachine port map(clk => clk, rst => rst, estado => estado);
	
	opcode <= instr_op;
	
	acc_en <= 	'0' when estado /= "01" else
				'1' when opcode = add_op else
				'1' when opcode = addi_op else
				'1' when opcode = sub_op else
				'1' when opcode = subi_op else
				'1' when opcode = ld_op and reg_d = '0' else
				'1' when opcode = mov_op and reg_d = '0' else
				'0'; 
				
	--entrada de dados do banco de registrados
	br_src <= 	'1' when opcode = ld_op and reg_d = '1' else 	--load de constante
				'0';											--saída do acc
	
	--escreve a instrução no fetch
	instWrite_en <= '1' when estado = "00" else
					'0';
			
	--atualiza o pc no estado decode
	pcWrite_en <= 	'1' when estado = "01" else
					'0';
	jump_en <= 	'1' when opcode = jump_op else
				'0';
	
	--escreve no banco de regs. no execute
	regWrite_en <= 	'0' when estado /= "10" else
					'1' when opcode = mov_op and reg_d = '1' else
					'1' when opcode = ld_op and reg_d = '1' else
					'0';
	
	aluOp <=	"00" when opcode = add_op else		--soma
				"00" when opcode = addi_op else
				"01" when opcode = sub_op else		--subtração
				"01" when opcode = subi_op else
				"10" when opcode = mov_op and reg_d = '0' else	--passa a entrada
				"10" when opcode = ld_op and reg_d = '0' else
				"00";
	
	aluSrcA <= 	'1' when opcode = addi_op else	--constante
				'1' when opcode = subi_op else
				'1' when opcode = ld_op and reg_d = '0' else
				'0';							--saída do banco
	
	state <= estado;
end architecture;