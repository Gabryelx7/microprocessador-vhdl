library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_tb is
end entity;

architecture a_control_tb of control_tb is

	component control is
	port(	rst 	: in std_logic;
			clk 	: in std_logic;
			instr_op: in unsigned(3 downto 0);
			reg_d 	: in std_logic;
			aluOp	: out unsigned(1 downto 0);
			state	: out unsigned(1 downto 0);
			aluSrcA : out std_logic;
			jump_en : out std_logic;
			br_src : out std_logic;
			acc_en	: out std_logic;
			pcWrite_en, regWrite_en, instWrite_en: out std_logic
		);
	end component;

	constant period_time 			: time := 100 ns;
	signal finished					: std_logic := '0';
	
	signal rst, clk, reg_d, aluSrcA, jump_en, br_src, acc_en, pcWrite_en, regWrite_en, instWrite_en : std_logic;
	signal aluOp, state : unsigned(1 downto 0);
	signal instr_op : unsigned(3 downto 0);
	
	begin
		uut : control port map(	rst,
								clk,
								instr_op,
								reg_d,
								aluOp,
								state,
								aluSrcA,
								jump_en,
								br_src,
								acc_en,
								pcWrite_en,
								regWrite_en,
								instWrite_en
								);
	
		sim_time : process
		begin
			wait for period_time*35;
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
		
			rst <= '1';
			wait for period_time*2;
			
			rst <= '0';
			instr_op <= "0001";	--add
			wait for period_time*3;
			
			instr_op <= "0010";	--addi
			wait for period_time*3;
			
			instr_op <= "0011";	--sub
			wait for period_time*3;
			
			instr_op <= "0100";	--subi
			wait for period_time*3;
			
			instr_op <= "0101";	--mov
			reg_d <= '0';
			wait for period_time*3;
			
			reg_d <= '1';
			wait for period_time*3;
			
			instr_op <= "0110";	--ld
			reg_d <= '0';
			wait for period_time*3;
			
			reg_d <= '1';
			wait for period_time*3;
			
			instr_op <= "1111";	--jump
			wait for period_time*3;
			
			instr_op <= "1000"; --instrução q n existe
			wait;
		
		end process;
	
end architecture;