library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	port(	cte					: in unsigned(15 downto 0);
			instruction			: in unsigned(11 downto 0);
			ulaSrc				: in std_logic := '0';
			rst, clk, wr_en 	: in std_logic := '0';
			selUlaOp			: in unsigned(1 downto 0);
			ulaOut 				: out unsigned(15 downto 0);
			romOut				: out unsigned(11 downto 0)
		);
end entity;

architecture a_processor of processor is
component bancoRegs is
	port(	read_a			: in unsigned(2 downto 0);
			read_b	 		: in unsigned(2 downto 0);
			write_r	 		: in unsigned(2 downto 0);
			write_data		: in unsigned(15 downto 0);
			clk, rst, wr_en : in std_logic;
			rd_data_a		: out unsigned(15 downto 0);
			rd_data_b 		: out unsigned(15 downto 0)
		);
end component;

component ula is
	port(	in_a, in_b 		: in unsigned(15 downto 0);
			sel				: in unsigned(1 downto 0);
			result			: out unsigned(15 downto 0);
			zero			: out std_logic	
		);
end component;

component rom is
	port( clk      : in std_logic;
		 endereco : in unsigned(6 downto 0);
		 dado     : out unsigned(11 downto 0) 
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
	port(	rst : in std_logic;
			clk : in std_logic;
			adr_in : in unsigned(6 downto 0);
			instr: in unsigned(11 downto 0);
			adr_out: out unsigned(6 downto 0);
			pcWrite_en: out std_logic
			--jump_en: out std_logic
		);
end component;

	signal write_data, rd_data_a, rd_data_b 	: unsigned(15 downto 0);
	
	signal in_a, in_b, result	: unsigned(15 downto 0);
	signal zero					: std_logic;
	
	signal endereco 	: unsigned(6 downto 0);
	signal dado 		: unsigned(11 downto 0);
	
	signal wr_en_end		: std_logic;
	signal rst_end			: std_logic;
	signal pc_in, pc_out, adr_in, adr_out 	: unsigned(6 downto 0);	
	
begin
	
	register_file : bancoRegs port map (rst => rst, clk => clk, wr_en => wr_en,
										read_a => instruction(5 downto 3),
										read_b => instruction(2 downto 0),
										write_r => instruction(8 downto 6),
										write_data => write_data,
										rd_data_a => rd_data_a,
										rd_data_b => rd_data_b);
	
	alu : ula port map (in_a => in_a, in_b => in_b, sel => selUlaOp, zero => zero, result => result);
	
	romFile : rom port map (clk => clk, endereco => endereco, dado => dado);
	
	pc : programCounter port map (clk => clk, wr_en => wr_en_end, reset => rst_end, data_in => pc_in, data_out => pc_out);
	
	controlUnit : control port map( rst => rst, clk => clk, adr_in => adr_in, adr_out => adr_out, instr => dado, pcWrite_en => wr_en_end);
	
	rst_end <= rst;
	pc_in <= adr_out;
	adr_in <= pc_out;
	
	endereco <= pc_out;
	
	romOut <= dado;
	
	write_data <= result;
	
	in_a <= rd_data_a;
	in_b <= rd_data_b 	when ulaSrc = '0' else
			cte 		when ulaSrc = '1' else
			x"0000";
			
	ulaOut <= result;
	
end architecture;