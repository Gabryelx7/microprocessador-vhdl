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
	
	0  => B"0110_011_1_00000101",					--	LD R3, 5	
	1  => B"0110_100_1_00001000",					--	LD R4, 8	
	2  => B"0101_011_0_00000000",					--	MOV A, R3 
	3  => B"0001_100_000000000",					-- 	ADD A, R4
	4  => B"0101_101_1_00000000",					--	MOV R5, A
	5  => B"0100_0000_00000001",					--	SUBI A, 1
	6  => B"0101_101_1_00000000",					-- 	MOV R5, A
	7  => B"1111_00000_0010100", 					--	JMP 20
	8  => B"0110_101_1_00000000",					--	LD R5, 0	
	9  => "0000000000000000",						-- 	NOP
	10 => "0000000000000000",						-- 	NOP
	20 => B"0101_011_1_00000000",					--	MOV R3, A
	21 => B"1111_00000_0000011",		 			--	JMP 3
	22 => B"0110_011_1_00000000",					--	LD R3, 0	
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