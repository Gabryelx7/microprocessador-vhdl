library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrlTL is
	port(	rst, clk	: in std_logic := '0';
			romOut 		: out unsigned(11 downto 0)
		);
end entity;

architecture a_ctrlTL of ctrlTL is
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
		);
end component;
	
	signal endereco 	: unsigned(6 downto 0);
	signal dado 		: unsigned(11 downto 0);
	
	signal wr_en_end		: std_logic;
	signal pc_in, pc_out, adr_in, adr_out 	: unsigned(6 downto 0);	
	
begin
	
	romFile : rom port map (clk => clk, endereco => endereco, dado => dado);
	
	pc : programCounter port map (clk => clk, wr_en => wr_en_end, reset => rst, data_in => pc_in, data_out => pc_out);
	
	controlUnit : control port map( rst => rst, clk => clk, adr_in => adr_in, adr_out => adr_out, instr => dado, pcWrite_en => wr_en_end);
	
	pc_in <= adr_out;	--endereço da instrução decodificada na entrada do pc
	adr_in <= pc_out;	
	
	endereco <= pc_out;	--saída do pc na entrada da ROM
	
	romOut <= dado;
	
end architecture;