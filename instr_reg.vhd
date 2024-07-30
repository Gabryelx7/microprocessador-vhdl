library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_reg is
	port(	clk				: in std_logic;
			rst				: in std_logic;
			wr_en			: in std_logic := '1';
			instr_in 		: in unsigned(15 downto 0);
			instr_out 		: out unsigned(15 downto 0)
		);
end entity;

architecture a_instr_teg of instr_reg is
	signal registro : unsigned(15 downto 0);
	
begin
	process(clk, rst, wr_en)
	begin
		if rst = '1' then
			registro <= "0000000000000000";
		elsif wr_en = '1' then
			if rising_edge(clk) then
				registro <= instr_in;
			end if;
		end if;
	end process;
	
	instr_out <= registro;
end architecture;