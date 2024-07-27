library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoRegs_tb is
end entity;

architecture a_bancoRegs_tb of bancoRegs_tb is
	component bancoRegs is
		port(	read_a			: in unsigned(2 downto 0);
				read_b	 		: in unsigned(2 downto 0);
				write_r	 		: in unsigned(2 downto 0);
				write_data		: in unsigned(15 downto 0);
				clk, rst, wr_en : in std_logic;
				rd_data_a		: out unsigned(15 downto 0);
				rd_data_b 		: out unsigned(15 downto 0)
		);
	end component;
	
	constant period_time : time := 100 ns;
	signal finished	: std_logic := '0';
	signal clk, rst, wr_en : std_logic;
	signal write_data, rd_data_a, rd_data_b : unsigned(15 downto 0);
	signal read_a, read_b, write_r : unsigned(2 downto 0);
	
	begin
		uut: bancoRegs port map(	clk => clk,
									rst => rst,
									wr_en => wr_en,
									write_data => write_data,
									rd_data_a => rd_data_a,
									rd_data_b => rd_data_b,
									read_a => read_a,
									read_b => read_b,
									write_r => write_r
								);
		
		reset_global : process
		begin
			rst <= '1';
			wait for period_time*3;
			rst <= '0';
			wait;
		end process;
		
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
		
		process
		begin
			rst <= '1';
			wait for 100 ns;
			
			rst <= '0'; 
			read_a <= "000";
			read_b <= "001";
			wr_en <= '1';
			write_r <= "101";
			write_data <= "1010101010101010";
			wait for 100 ns;
			
			read_a <= "101";
			read_b <= "111";
			write_r <= "000";
			write_data <= "1010101010101010";
			wait for 100 ns;
			
			read_a <= "101";
			read_b <= "000";
			write_r <= "111";
			write_data <= "1010101010101010";
			wait for 100 ns;
			
			wr_en <= '0';
			read_a <= "011";
			read_b <= "111";
			wait for 100 ns;
			
			rst <= '1';
			read_a <= "001";
			read_b <= "111";
			wait;
		end process;
	
end architecture;