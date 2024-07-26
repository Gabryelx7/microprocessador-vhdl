library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4_tb is
end entity;

architecture a_decoder2x4_tb of decoder2x4_tb is
component decoder2x4
	port(a, b : in std_logic;
		q0, q1, q2, q3 : out std_logic
		);
end component;

signal a, b, q0, q1, q2, q3 : std_logic;

begin
uut: decoder2x4 port map(a => a,
						b => b,
						q0 => q0,
						q1 => q1,
						q2 => q2,
						q3 => q3
						);

process
begin
	a <= 'X';
	b <= 'X';
	wait for 10 ns;
	
	a <= '0';
	b <= '0';
	wait for 10 ns;
	
	a <= '0';
	b <= '1';
	wait for 10 ns;
	
	a <= '1';
	b <= '0';
	wait for 10 ns;
	
	a <= '1';
	b <= '1';
	wait for 10 ns;
	wait;
end process;

end architecture;