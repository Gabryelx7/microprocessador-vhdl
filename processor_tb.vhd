library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end entity;

architecture a_processor_tb of processor_tb is
component processor is
	port(
			rst, clk		  	: in std_logic := '0';
			pcOut				: out unsigned(6 downto 0);
			estado				: out unsigned(1 downto 0);
			IROut				: out unsigned(15 downto 0);
			dtA, dtB			: out unsigned(15 downto 0);
			ulaOut 				: out unsigned(15 downto 0)
		);
end component;

	constant period_time : time := 100 ns;
	signal finished	: std_logic := '0';
	--
	signal rst, clk : std_logic;
	signal pcOut : unsigned(6 downto 0);
	signal estado : unsigned(1 downto 0);
	signal dtA, dtB, ulaOut, IROut : unsigned(15 downto 0);
	
begin
	
	uut : processor port map 	(rst,
								clk,
								pcOut,
								estado,
								IROut,
								dtA,
								dtB,
								ulaOut
								);
								
	sim_time : process
	begin
		wait for period_time*3000;
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