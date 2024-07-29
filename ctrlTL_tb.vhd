library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrlTL_tb is
end entity;

architecture a_ctrlTL_tb of ctrlTL_tb is
	component ctrlTL is
		port(	rst, clk	: in std_logic := '0';
				romOut 		: out unsigned(11 downto 0)
			);
	end component;
	
	constant period_time : time := 100 ns;
	signal finished	: std_logic := '0';
	
	signal romOut : unsigned(11 downto 0);
	signal rst, clk: std_logic := '0';
	
	begin
		uut: ctrlTL port map(	rst => rst,
									clk => clk,
									romOut => romOut
								);
		
		sim_time : process
		begin
			wait for 2000 ns;
			finished <= '1';
			wait;
		end process sim_time;
		
		clk_proc : process
		begin
			while finished /= '1' loop
				clk <= '0';
				wait for period_time/2;
				clk <= '1';
				wait for period_time/2;
			end loop;
			wait;
		end process clk_proc;
		
		process begin
			
			rst <= '1';
			wait for period_time*2;
			
			rst <= '0';
			wait;
			
		end process;
	
end architecture;