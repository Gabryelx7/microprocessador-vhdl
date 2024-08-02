library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	port(
			rst, clk		  	: in std_logic := '0';
			pcOut				: out unsigned(6 downto 0);
			estado				: out unsigned(1 downto 0);
			IROut				: out unsigned(15 downto 0);
			dtA, dtB			: out unsigned(15 downto 0);
			ulaOut 				: out unsigned(15 downto 0)
		);
end entity;

architecture a_processor of processor is
component bancoRegs is
	port(	read_a			: in unsigned(2 downto 0);
			write_r	 		: in unsigned(2 downto 0);
			write_data		: in unsigned(15 downto 0);
			clk, rst, wr_en : in std_logic;
			rd_data_a		: out unsigned(15 downto 0)
		);
end component;

component ula is
	port(	in_a, in_b 		: in unsigned(15 downto 0);
			sel				: in unsigned(1 downto 0);
			result			: out unsigned(15 downto 0);
			zero, overflow, negative	: out std_logic	
		);
end component;

component rom is
	port( clk      : in std_logic;
		 endereco : in unsigned(6 downto 0);
		 dado     : out unsigned(15 downto 0) 
	);
end component;

component programCounter is
	port(	clk		: in std_logic;
			wr_en	: in std_logic;
			reset 	: in std_logic;
			data_in : in unsigned(6 downto 0);
			data_out: out unsigned(6 downto 0)
		);
end component;

component control is
	port(	rst 		: in std_logic;
			clk 		: in std_logic;
			instr_op	: in unsigned(3 downto 0);
			reg_d 		: in std_logic;
			aluOp		: out unsigned(1 downto 0);
			state		: out unsigned(1 downto 0);
			aluSrcA 	: out std_logic;
			jump_en 	: out std_logic;
			write_src 	: out std_logic;
			acc_en		: out std_logic;
			acc_src		: out std_logic;
			pcWrite_en	: out std_logic;
			regWrite_en : out std_logic;
			instWrite_en: out std_logic;
			memWrite_en : out std_logic;
			jz_en, jn_en, jp_en, cjne_en, flag_en : out std_logic
		);
end component;

component instr_reg is
	port(	clk				: in std_logic;
			rst				: in std_logic;
			wr_en			: in std_logic := '1';
			instr_in 		: in unsigned(15 downto 0);
			instr_out 		: out unsigned(15 downto 0)
		);
end component;

component acumulador is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			wr_en	: in std_logic := '1';
			data_in : in unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
		);
end component;

component sign_ext is
	port(	cte_in : in unsigned(7 downto 0);
			cte_out: out unsigned(15 downto 0)
		);
end component;

component reg1bit is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			wr_en	: in std_logic;
			data_in : in std_logic;
			data_out: out std_logic
		);
end component;

component reg16bits is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			wr_en	: in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
		);
end component;

component ram is
   port( 
         clk      : in std_logic;
         endereco : in unsigned(6 downto 0);
         wr_en    : in std_logic;
         dado_in  : in unsigned(15 downto 0);
         dado_out : out unsigned(15 downto 0) 
   );
 end component;

	--register file
	signal write_data, rd_data_a 	: unsigned(15 downto 0);
	signal read_a : unsigned(2 downto 0);
	
	--ula
	signal in_a, in_b, result		: unsigned(15 downto 0);
	signal zero, overflow, negative	: std_logic;
	
	--ROM
	signal endereco 	: unsigned(6 downto 0);
	signal dado 		: unsigned(15 downto 0);
	
	--pc 
	signal pc_in, pc_out 	: unsigned(6 downto 0);
	
	--control
	signal regWrite_en, instWrite_en, pcWrite_en	: std_logic;
	signal aluSrcA, memWrite_en, write_src			: std_logic;
	signal aluOp, state								: unsigned(1 downto 0);
	signal jump_en, acc_en, jmp_en, acc_src			: std_logic;
	signal jump_adr									: unsigned(6 downto 0);
	signal jn_en, jp_en, jz_en, cjne_en, branch_en	: std_logic;
	
	--instruction register
	signal instr_out : unsigned(15 downto 0);
	
	--sign extender
	signal cte_in : unsigned(7 downto 0);
	signal cte_out: unsigned(15 downto 0);
	
	--acumulador
	signal acc_in, acc_out : unsigned(15 downto 0);
	
	--Regs de flags
	signal zero_en, zero_out 	: std_logic;
	signal ovf_en, ovf_out 	: std_logic;
	signal ngt_en, ngt_out 	: std_logic;
	signal flag_en			: std_logic;
	
	--RAM
	signal a_out, mem_data_out, mem_data_in, ram_out : unsigned(15 downto 0);
	signal ram_adr 	: unsigned(6 downto 0);
	signal write_en : std_logic;
	
begin
	
	register_file : bancoRegs port map (rst => rst, clk => clk, wr_en => regWrite_en,
										read_a => read_a,
										write_r => instr_out(11 downto 9),
										write_data => write_data,
										rd_data_a => rd_data_a
										);
	
	alu : ula port map (in_a => in_a,
						in_b => in_b,
						sel => aluOp,
						zero => zero,
						overflow => overflow,
						negative => negative,
						result => result
						);
	
	romFile : rom port map (clk => clk,
							endereco => endereco,
							dado => dado);
	
	pc : programCounter port map 	(clk => clk,
									wr_en => pcWrite_en,
									reset => rst,
									data_in => pc_in,
									data_out => pc_out
									);
	
	controlUnit : control port map	(rst => rst,
									clk => clk,
									instr_op => instr_out(15 downto 12),
									reg_d => instr_out(8),
									aluOp => aluOp,
									state => state,
									aluSrcA => aluSrcA,
									jump_en => jump_en,
									write_src => write_src,
									acc_en => acc_en,
									acc_src => acc_src,
									pcWrite_en => pcWrite_en,
									regWrite_en => regWrite_en,
									instWrite_en => instWrite_en,
									memWrite_en => memWrite_en,
									jz_en => jz_en,
									jn_en => jn_en,
									jp_en => jp_en,
									cjne_en => cjne_en,
									flag_en => flag_en
									);
									
	instructionReg : instr_reg port map (clk,
										rst,
										instWrite_en,
										dado,
										instr_out
										);

	sign_extender : sign_ext port map 	(cte_in,
										cte_out
										);
										
	accumulator : acumulador port map	(clk,
										rst,
										acc_en,
										acc_in,
										acc_out
										);
	
	zeroFlag : reg1bit port map(clk,
								rst,
								flag_en,
								zero,
								zero_out
								);
	
	overflowFlag : reg1bit port map(clk,
									rst,
									flag_en,
									overflow,
									ovf_out
									);
	
	negativeFlag : reg1bit port map(clk,
									rst,
									flag_en,
									negative,
									ngt_out
									);
	
	ramFile : ram port map(	clk,
							ram_adr,
							memWrite_en,
							mem_data_in,
							mem_data_out
							);
	
	--pc
	branch_en 	<= 	(jz_en and zero_out) or (jn_en and ngt_out) or (jp_en and not ngt_out and not zero_out);
	jmp_en <= jump_en or (cjne_en and not zero);
	jump_adr 	<= 	instr_out(6 downto 0);
	pc_in 		<= 	(jump_adr) when jmp_en = '1' else
					(pc_out + jump_adr) when branch_en = '1' else
					(pc_out + 1);
	
	--ROM
	endereco <= pc_out;
	
	--RAM
	ram_adr <= rd_data_a(6 downto 0);
	mem_data_in <= acc_out;
	--write_en <= '1' when state = "01" else
	--			'0';
	
	--constant sign extender
	cte_in <= instr_out(7 downto 0);
	
			
	--ula e acumulador
	acc_in <= 	result when acc_src = '0' else
				mem_data_out;
	in_a <= cte_out when aluSrcA = '1' else
			rd_data_a;
	in_b <= acc_out;
	
	--entrada de dados no banco
	write_data <= 	cte_out 	when 	write_src = '1' else
					acc_out;
	read_a <= 	instr_out(11 downto 9);
					
			
	--saídas
	IROut <= instr_out;
	dtA <= in_a;
	dtB <= in_b;
	pcOut <= pc_out;
	ulaOut <= result;
	estado <= state;
	
end architecture;