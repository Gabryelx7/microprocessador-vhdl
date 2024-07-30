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
	result <= 	(in_b + in_a) 	when sel = "00" else --soma
				(in_b - in_a) 	when sel = "01" else --subtração
				(in_a) 		  	when sel = "10" else --passa entrada A
				(in_a and in_b) when sel = "00" else --AND bit a bit
				"0000000000000000";

	zero <= '1' when (in_a - in_b) = 0 else
			'0';
end architecture;