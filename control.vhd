library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port(	rst : in std_logic;
			clk : in std_logic;
			adr_in : in unsigned(6 downto 0);
			instr: in unsigned(11 downto 0);
			adr_out: out unsigned(6 downto 0);
			pcWrite_en: out std_logic
		);
end entity;

architecture a_control of control is

	component stateMachine is
	port(	clk		: in std_logic;
			rst		: in std_logic;
			data_o	: out std_logic
		);
	end component;
	
	constant jump_op : unsigned(3 downto 0) := "1111";  --	opcode de jump
	signal state : std_logic;
	signal opcode: unsigned(3 downto 0);
	signal jump_to: unsigned(6 downto 0);
	
	begin
	
	stMachine : stateMachine port map(clk => clk, rst => rst, data_o => state);
	
	opcode <= instr(11 downto 8);
	jump_to <= instr(6 downto 0);
					
	adr_out <= 	(jump_to) when opcode = jump_op else
				(adr_in + 1);
	
	pcWrite_en <= 	'1' when state = '1' else	--	decode state
					'0';						--	intruction fetch state
	
end architecture;