library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port(	in_a, in_b 		: in unsigned(15 downto 0);
			sel				: in unsigned(1 downto 0);
			result			: out unsigned(15 downto 0);
			zero, overflow, negative	: out std_logic
		);
		
end entity;

architecture a_ula of ula is

	signal soma, subt, res : unsigned(15 downto 0) := x"0000";
begin
	soma <= in_b + in_a;
	subt <= in_b - in_a;

	res <= 	soma 	when sel = "00" else --soma
			subt 	when sel = "01" else --subtração
			(in_a) 		  	when sel = "10" else --passa entrada A
			(in_a and in_b) when sel = "00" else --AND bit a bit
			"0000000000000000";

	zero <= '1' when subt = x"0000" else
			'0';
	
	negative <= res(15);
	
	overflow <= '1' when in_b(15) = '1' and in_a(15) = '1' and soma(15) = '0' and sel = "00" else
				'1' when in_b(15) = '0' and in_a(15) = '0' and soma(15) = '1' and sel = "00" else
				'1' when in_b(15) = '1' and in_a(15) = '0' and subt(15) = '0' and sel = "01" else
				'1' when in_b(15) = '0' and in_a(15) = '1' and subt(15) = '1' and sel = "01" else
				'0';
	
	result <= res;
end architecture;