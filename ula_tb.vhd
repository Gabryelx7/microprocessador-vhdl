library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
	component ula
		port(	in_a, in_b 		: in unsigned(15 downto 0);
				sel				: in unsigned(1 downto 0);
				result			: out unsigned(15 downto 0);
				zero, overflow, negative	: out std_logic
			);
	end component;
	
	signal in_a, in_b, result : unsigned(15 downto 0):= x"0000";
	signal sel : unsigned(1 downto 0):= "00";
	signal zero, overflow, negative : std_logic:= '0';
	
	begin
	
	uut:	ula port map(	in_a => in_a,
							in_b => in_b,
							result => result,
							zero => zero,
							sel => sel,
							overflow => overflow,
							negative => negative
	);
	
	process
	begin
		-- a:(-3221); b:(26914)
		in_a <= "1111001101101011";
		in_b <= "0110100100100010";
		
		sel <= "00";
		wait for 100 ns;
		sel <= "01";
		wait for 100 ns;
		sel <= "10";
		wait for 100 ns;
		sel <= "11";
		wait for 100 ns;
	
		-- a:(0); b:(-5854)
		in_a <= "0000000000000000";
		in_b <= "1110100100100010";
		
		sel <= "00";
		wait for 100 ns;
		sel <= "01";
		wait for 100 ns;
		sel <= "10";
		wait for 100 ns;
		sel <= "11";
		wait for 100 ns;
	
		-- a:(11058); b:(11058)
		in_a <= "0010101100110010";
		in_b <= "0010101100110010";
		
		sel <= "00";
		wait for 100 ns;
		sel <= "01";
		wait for 100 ns;
		sel <= "10";
		wait for 100 ns;
		sel <= "11";
		wait for 100 ns;
	
		-- a:(8739); b:(-28515)
		in_a <= "0010001000100011";
		in_b <= "1001000010011101";
		
		sel <= "00";
		wait for 100 ns;
		sel <= "01";
		wait for 100 ns;
		sel <= "10";
		wait for 100 ns;
		sel <= "11";
		wait for 100 ns;
		wait;
	end process;
	
end architecture;