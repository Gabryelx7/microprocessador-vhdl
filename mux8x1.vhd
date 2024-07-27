library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
port(	ent2, ent4, ent6 : in std_logic;
		sel0, sel1, sel2 : in std_logic;
		saida : out std_logic
	);

end entity;

architecture a_mux8x1 of mux8x1 is
begin
	saida <= 	ent2 when sel0 = '0' and sel1 = '1' and sel2 = '0' else
				ent4 when sel0 = '0' and sel1 = '0' and sel2 = '1' else
				ent6 when sel0 = '0' and sel1 = '1' and sel2 = '1' else
				'1' when (sel0 = '1' and sel1 = '1' and sel2 = '0') or
				(sel0 = '1' and sel1 = '1' and sel2 = '1') else
				'0';
end architecture;