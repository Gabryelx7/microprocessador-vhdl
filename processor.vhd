library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	port(	cte					: in unsigned(15 downto 0);
			instruction			: in unsigned(8 downto 0);
			sel_ulaB			: in std_logic := '0';
			rst, clk, wr_en 	: in std_logic := '0';
			sel					: in unsigned(1 downto 0);
			ulaOut 				: out unsigned(15 downto 0)
		);
end entity;

architecture a_processor of processor is
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

component ula is
	port(	in_a, in_b 		: in unsigned(15 downto 0);
			sel				: in unsigned(1 downto 0);
			result			: out unsigned(15 downto 0);
			zero			: out std_logic	
		);
end component;

	signal write_data, rd_data_a, rd_data_b 	: unsigned(15 downto 0);
	
	signal in_a, in_b, result	: unsigned(15 downto 0);
	signal zero					: std_logic;
	
begin
	
	register_file : bancoRegs port map (rst => rst, clk => clk, wr_en => wr_en,
										read_a => instruction(5 downto 3),
										read_b => instruction(2 downto 0),
										write_r => instruction(8 downto 6),
										write_data => write_data,
										rd_data_a => rd_data_a,
										rd_data_b => rd_data_b);
	
	alu : ula port map (in_a => in_a, in_b => in_b, sel => sel, zero => zero, result => result);
	
	
	write_data <= result;
	
	in_a <= rd_data_a;
	in_b <= rd_data_b 	when sel_ulaB = '0' else
			cte 		when sel_ulaB = '1' else
			x"0000";
			
	ulaOut <= result;
	
end architecture;