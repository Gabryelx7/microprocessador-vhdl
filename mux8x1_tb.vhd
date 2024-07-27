library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_tb is
end entity;

architecture a_mux8x1_tb of mux8x1_tb is

component mux8x1
	port(	ent2, ent4, ent6 : in std_logic;
		sel0, sel1, sel2 : in std_logic;
		saida : out std_logic
	);
end component;

signal ent2, ent4, ent6, sel0, sel1, sel2, saida : std_logic;

begin
uut: mux8x1 port map(	ent2 => ent2,
						ent4 => ent4,
						ent6 => ent6,
						sel0 => sel0,
						sel1 => sel1,
						sel2 => sel2,
						saida => saida
						);

process
begin
	
	ent2 <= '1';
	ent4 <= '0';
	ent6 <= '1';
	
	sel0 <= '0';
	sel1 <= '0';
	sel2 <= '0';
	wait for 10 ns;
	
	sel0 <= '1';
	sel1 <= '0';
	sel2 <= '0';
	wait for 10 ns;
	
	sel0 <= '0';
	sel1 <= '1';
	sel2 <= '0';
	wait for 10 ns;
	
	sel0 <= '1';
	sel1 <= '1';
	sel2 <= '0';
	wait for 10 ns;
	
	sel0 <= '0';
	sel1 <= '0';
	sel2 <= '1';
	wait for 10 ns;
	
	sel0 <= '1';
	sel1 <= '0';
	sel2 <= '1';
	wait for 10 ns;
	
	sel0 <= '0';
	sel1 <= '1';
	sel2 <= '1';
	wait for 10 ns;
	
	sel0 <= '1';
	sel1 <= '1';
	sel2 <= '1';
	wait for 10 ns;
	
	wait;

end process;
end architecture;