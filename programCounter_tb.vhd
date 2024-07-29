library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programCounter_tb is
end entity;

architecture a_programCounter_tb of programCounter_tb is
	component programCounter is
		port(	clk		: in std_logic;
			wr_en	: in std_logic;
			reset	: in std_logic;
			data_in : in unsigned(6 downto 0);
			data_out: out unsigned(6 downto 0)
		);
	end component;
	
	constant period_time : time := 100 ns;
	signal finished	: std_logic := '0';
	
	signal reset, clk, wr_en : std_logic;
	signal data_in, data_out : unsigned(6 downto 0);
	
	begin
	uut : programCounter port map(	clk => clk, wr_en => wr_en, reset => reset,
									data_in => data_in, data_out => data_out
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
			clk <= '1';
			wait for period_time/2;
			clk <= '0';
			wait for period_time/2;
		end loop;
		wait;
	end process clk_proc;
	
	process begin
		--reseta
		reset <= '1';
		wait for 200 ns;
		
		--escreve o endereço 0
		reset <= '0';
		wr_en <= '1';
		data_in <= "0000000";
		wait for 100 ns;
		
		--end 1
		data_in <= "0000001";
		wait for 100 ns;
		
		--end 2
		data_in <= "0000010";
		wait for 100 ns;
		
		--desabilita a escrita
		wr_en <= '0';
		data_in <= "0000011";
		wait for 100 ns;
		
		data_in <= "0000111";
		wait for 100 ns;
		wait;
	
	end process;
	
	
end architecture;
