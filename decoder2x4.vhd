library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
	port 	(a, b : in std_logic;
			q0, q1, q2, q3 : out std_logic
			);
end entity;

architecture a_decoder2x4 of decoder2x4 is
begin
	q0 <= not a and not b;
	q1 <= not a and b;
	q2 <= a and not b;
	q3 <= a and b;

end architecture;