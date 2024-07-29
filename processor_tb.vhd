library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end entity;

architecture a_processor_tb of processor_tb is
	component processor is
		port(	cte					: in unsigned(15 downto 0);
				instruction			: in unsigned(11 downto 0);
				ulaSrc				: in std_logic := '0';
				rst, clk, wr_en 	: in std_logic := '0';
				selUlaOp			: in unsigned(1 downto 0);
				ulaOut 				: out unsigned(15 downto 0);
				romOut				: out unsigned(11 downto 0)
		);
	end component;

	constant period_time : time := 200 ns;
	signal finished	: std_logic := '0';
	
	signal cte, ulaOut : unsigned(15 downto 0);
	signal instruction : unsigned(11 downto 0);
	signal rst, clk, wr_en, ulaSrc : std_logic := '0';
	signal selUlaOp : unsigned(1 downto 0);
	signal romOut : unsigned(11 downto 0);
	
	begin
		uut: processor port map(	cte => cte,
									instruction => instruction,
									selUlaOp => selUlaOp,
									rst => rst,
									clk => clk,
									wr_en => wr_en,
									ulaSrc => ulaSrc,
									ulaOut => ulaOut,
									romOut => romOut
								);
		
		sim_time : process
		begin
			wait for 1700 ns;
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
			--reset e ula em soma
			rst <= '1';
			selUlaOp <= "00";
			wait for 150 ns;
			
			rst <= '0';
			wr_en <= '1';
			instruction <= "000"&"010"&"111"&"010";
			wait for 200 ns;
			
			ulaSrc <= '1';
			cte <= x"2a01";
			instruction <= "000"&"010"&"111"&"010";
			wait for 200 ns;
			
			cte <= x"0f2f";
			instruction <= "000"&"011"&"111"&"010";
			wait for 200 ns;
			
			cte <= x"dad0";
			instruction <= "000"&"011"&"011"&"010";
			wait for 200 ns;
			
			ulaSrc <= '0';
			instruction <= "000"&"100"&"011"&"010";
			wait for 200 ns;
			
			instruction <= "000"&"100"&"100"&"011";
			wait for 200 ns;
			
			wr_en <= '0';
			instruction <= "000"&"100"&"100"&"010";
			wait for 200 ns;
			
			rst <= '1';
			wait;
		
		end process;
	
end architecture;