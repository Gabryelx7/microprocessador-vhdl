library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_ext_tb is
end entity;

architecture a_sign_ext_tb of sign_ext_tb is

	component sign_ext is
		port(	cte_in : in unsigned(7 downto 0);
				cte_out: out unsigned(15 downto 0)
		);
	end component;

	signal cte_in : unsigned(7 downto 0);
	signal cte_out : unsigned(15 downto 0);
	
	begin
		
		uut : sign_ext port map(cte_in, cte_out);
		
		process begin
		
			cte_in <= "01010101";
			wait for 100 ns;
			
			cte_in <= "11010101";
			wait for 100 ns;
			
			cte_in <= "11111110";
			wait for 100 ns;
			wait;
		
		end process;

end architecture; 