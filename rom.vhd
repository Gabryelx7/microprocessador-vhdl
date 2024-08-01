library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 	clk      : in std_logic;
			endereco : in unsigned(6 downto 0) := "0000000";
			dado     : out unsigned(15 downto 0) 
	);
end entity;

architecture a_rom of rom is
type mem is array (0 to 127) of unsigned(15 downto 0);
constant conteudo_rom : mem := ( -- teste loop
	
	0  => B"0110_011_1_00000000",					--	LD R3, 0	
	1  => B"0110_100_1_00000000",					--	LD R4, 0	
	2  => B"0101_011_0_00000000",					--	MOV A, R3 
	3  => B"0001_100_000000000",					-- 	ADD A, R4
	4  => B"0101_100_1_00000000",					--	MOV R5, A
	5  => B"0101_011_0_00000000",					--	MOV A, R3
	6  => B"0010_0000_00000001",					-- 	ADDI A, 1
	7  => B"0101_011_1_00000000",					--	MOV R3, A
	8  => B"0110_000_0_00011110",					--	LD A, 30	
	9  => B"1000_011_000000000",					--	CMP A, R3
	10 => B"1100_00000_1111000",					--	JP -8
	11 => B"0101_100_0_00000000",					--	MOV A, R4
	12 => B"0101_101_1_00000000",		 			--	MOV R5, A
	13 => B"0000000000000000",						--	NOP	
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