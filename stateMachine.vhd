library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stateMachine is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			data_o	: out std_logic
		);
end entity;

architecture a_stateMachine of stateMachine is
	signal estado : std_logic;
	
begin
	process(clk, rst)
	begin
		if rst = '1' then
			estado <= '0';
		elsif rising_edge(clk) then
			estado <= not estado;
		end if;
	end process;
	
	data_o <= estado;
end architecture;