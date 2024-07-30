library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador_tb is
end entity;

architecture a_acumulador_tb of acumulador_tb is

	component acumulador is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			wr_en	: in std_logic;
			data_in : in unsigned(15 downto 0);
			data_out: out unsigned(15 downto 0)
		);
	end component;

	signal clk, rst, wr_en 		: std_logic;
	signal data_in, data_out 	: unsigned(15 downto 0);
	
	begin
		
		uut : acumulador port map( 	clk,
									rst,
									wr_en,
									data_in,
									data_out
									);
		sim_time : process
		begin
			wait for 1500 ns;
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
		
		process	
		begin
			rst < = '1';
			wait for period_time*2;
			
			rst <= '0';
			
			
		end process;
	
	data_out <= registro;
end architecture;