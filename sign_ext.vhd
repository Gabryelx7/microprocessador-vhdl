library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_ext is
	port(	cte_in : in unsigned(7 downto 0);
			cte_out: out unsigned(15 downto 0)
		);
end entity;

architecture a_sign_ext of sign_ext is

	signal cte_aux : unsigned(7 downto 0);
	
	begin
		
		cte_aux <= 	"11111111" when cte_in(7) = '1' else
					"00000000";
		
		cte_out <= cte_aux & cte_in;

end architecture; 