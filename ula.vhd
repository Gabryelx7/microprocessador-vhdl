library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port(	in_a, in_b 		: in unsigned(15 downto 0);
			sel				: in unsigned(1 downto 0);
			result			: out unsigned(15 downto 0);
			zero			: out std_logic
		);
		
end entity;

architecture a_ula of ula is
begin
	result <= 	(in_a + in_b) when sel = "00" else
				(in_a - in_b) when sel = "01" else
				(in_a and in_b) when sel = "00" else
				(in_a or in_b) when sel = "00" else
				"0000000000000000";

	zero <= '1' when (in_a - in_b) = 0 else
			'0';
end architecture;