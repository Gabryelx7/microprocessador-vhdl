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
	
	0  => B"0110_001_1_00000001",					--	LD R1, 1	LOOP DE ESCRITA
	1  => B"0101_001_0_00000000",					--	MOV A, R1	
	2  => B"0010_0000_00000001",					--	ADDI A, 1 
	3  => B"0101_001_1_00000000",					-- 	MOV R1, A
	4  => B"1101_001_000000000",					--	SW A, R1
	5  => B"0110_000_0_00100000",					--	LD A, 32
	6  => B"1011_001_00_0000001",					--	CJNE A, R1, 1
	7  => B"0110_001_1_00000001",					--	LD R1, 1	LOOP MULTIPLOS
	8  => B"0101_001_0_00000000",					--	MOV A, R1
	9  => B"0010_0000_00000001",					--	ADDI A, 1
	10 => B"0101_001_1_00000000",					--	MOV R1, A
	11 => B"1110_001_000000000",					--	LW A, R1
	12 => B"0010_0000_00000000",					--	ADDI A, 0
	13 => B"1001_00000_1111011",					--	JZ -5
	14 => B"1110_001_0_00000000",					--	LW A, R1 	 
	15 => B"0101_010_1_00000000",					--	MOV R2, A
	16 => B"0101_010_0_00000000",					--	MOV A, R2
	17 => B"0001_001_000000000",					--	ADD A, R1
	18 => B"0101_010_1_00000000",					-- 	MOV R2, A
	19 => B"0110_000_0_00000000",					--	LD A, 0
	20 => B"1101_010_000000000",					--	SW A, R2
	21 => B"0110_000_0_00100000",					--	LD A, 32
	22 => B"1000_010_000000000",					--	CMP A, R2
	23 => B"1100_00000_1111001",					--	JP -7
	24 => B"0110_000_0_00000101",					--	LD A, 5
	25 => B"1000_001_000000000",					--	CMP A, R1
	26 => B"1100_00000_1101110",					--	JP -18
	27 => B"0110_001_1_00000001",					--	LD R1, 1	LOOP DE LEITURA
	28 => B"0101_001_0_00000000",					--	MOV A, R1	
	29 => B"0010_0000_00000001",					--	ADDI A, 1 
	30 => B"0101_001_1_00000000",					-- 	MOV R1, A
	31 => B"1110_001_000000000",					--	LW A, R1
	32 => B"0010_0000_00000000",					--	ADDI A, 0
	33 => B"1001_00000_0000011",					--	JZ 3
	34 => B"1110_001_000000000",					--	LW A, R1	ESCRITA DOS PRIMOS NO REG 7
	35 => B"0101_111_1_00000000",					--	MOV R7, A
	36 => B"0110_000_0_00100000",					--	LD A, 32
	37 => B"1011_001_00_0011100",					--	CJNE A, R1, 28
	38 => B"0000000000000000",						--	NOP 
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