library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoRegs is
	port(	read_a			: in unsigned(2 downto 0);
			read_b	 		: in unsigned(2 downto 0);
			write_r	 		: in unsigned(2 downto 0);
			write_data		: in unsigned(15 downto 0);
			clk, rst, wr_en : in std_logic;
			rd_data_a		: out unsigned(15 downto 0);
			rd_data_b 		: out unsigned(15 downto 0)
		);
end entity;

architecture a_bancoRegs of bancoRegs is
	component reg16bits is
		port( 	clk		: in std_logic;
				rst		: in std_logic;
				wr_en	: in std_logic;
				data_in : in unsigned(15 downto 0);
				data_out: out unsigned(15 downto 0)
			);
	end component;
	
	signal s0_out, s1_out, s2_out, s3_out, s4_out, s5_out, s6_out, zero_out : unsigned (15 downto 0);
	signal reg_in : unsigned (15 downto 0);
	signal enable : unsigned(7 downto 0) := "00000000";
	
	begin
	zero: reg16bits port map(rst => rst, clk => clk, wr_en => enable(0), data_in => x"0000", data_out => zero_out);
	s0: reg16bits port map(rst => rst, clk => clk, wr_en => enable(1), data_in => reg_in, data_out => s0_out);
	s1: reg16bits port map(rst => rst, clk => clk, wr_en => enable(2), data_in => reg_in, data_out => s1_out);
	s2: reg16bits port map(rst => rst, clk => clk, wr_en => enable(3), data_in => reg_in, data_out => s2_out);
	s3: reg16bits port map(rst => rst, clk => clk, wr_en => enable(4), data_in => reg_in, data_out => s3_out);
	s4: reg16bits port map(rst => rst, clk => clk, wr_en => enable(5), data_in => reg_in, data_out => s4_out);
	s5: reg16bits port map(rst => rst, clk => clk, wr_en => enable(6), data_in => reg_in, data_out => s5_out);
	s6: reg16bits port map(rst => rst, clk => clk, wr_en => enable(7), data_in => reg_in, data_out => s6_out);
	
	rd_data_a <= 	zero_out when read_a = "000" else
					s0_out when read_a = "001" else
					s1_out when read_a = "010" else
					s2_out when read_a = "011" else
					s3_out when read_a = "100" else
					s4_out when read_a = "101" else
					s5_out when read_a = "110" else
					s6_out when read_a = "111" else
					x"0000";
	
	rd_data_b <= 	zero_out when read_b = "000" else
					s0_out when read_b = "001" else
					s1_out when read_b = "010" else
					s2_out when read_b = "011" else
					s3_out when read_b = "100" else
					s4_out when read_b = "101" else
					s5_out when read_b = "110" else
					s6_out when read_b = "111" else
					x"0000";
	
	reg_in <= write_data;
	
	enable <= 	"00000010" when write_r = "001" and wr_en = '1' else
				"00000100" when write_r = "010" and wr_en = '1' else
				"00001000" when write_r = "011" and wr_en = '1' else
				"00010000" when write_r = "100" and wr_en = '1' else
				"00100000" when write_r = "101" and wr_en = '1' else
				"01000000" when write_r = "110" and wr_en = '1' else
				"10000000" when write_r = "111" and wr_en = '1' else
				"00000000";

end architecture;