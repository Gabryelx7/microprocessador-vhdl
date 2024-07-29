library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 	clk      : in std_logic;
			endereco : in unsigned(6 downto 0) := "0000000";
			dado     : out unsigned(11 downto 0) 
	);
end entity;

architecture a_rom of rom is
type mem is array (0 to 127) of unsigned(11 downto 0);
constant conteudo_rom : mem := ( -- teste loop
	
	0  => "101001000010",	--		nop
	1  => "000111000111",	--		nop
	2  => "111100000111", 	--		jump		7  	
	3  => "101100111001",
	4  => "100000000000",
	5  => "001001000010",
	6  => "100101101011",	
	7  => "000000000010",   --		nop
	8  => "111100000001",	--		jump	 	1
	9  => "000000000000",
	10 => "000000000000",
	others => (others=>'0')
);

begin
process(clk)
	begin
		if(rising_edge(clk)) then
			dado <= conteudo_rom(to_integer(endereco));
		end if;
	end process;
end architecture;