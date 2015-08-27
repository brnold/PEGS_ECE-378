

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Board_Updater_dp is
	port(
		--START OF INPUTS
		clk : in std_logic;
		clr : in std_logic;
		
		loc1 : in STD_LOGIC_vector(6 downto 0);--PEG 1 LOCATION
		loc2 : in STD_LOGIC_vector(6 downto 0);--PEG 2 LOCATION
		cursor : in STD_LOGIC_vector(6 downto 0);--CURSOR LOCATION
		out_peg : in STD_LOGIC_vector(2 downto 0);
		
		plusplus_out : in STD_LOGIC_vector(2 downto 0);--FROM ++ BLOCK, WHAT BLOCK IS FORMED FROM ++
		plusplus_we : in std_logic_vector(0 downto 0);--FROM ++ BLOCK, WRITE ENABLE 
		
		sm_we : in std_logic_vector(0 downto 0); --FROM STATE MACHINE, WRITE ENABLE
		
		load_cursor,load_loc1,load_loc2, load_dataout, load_addr : in std_logic; --REG LOAD LINES
		sel_dataout, sel_addrout, sel_we : in std_logic_vector(1 downto 0); --MUX SELECT LINES
		
		--START OF OUTPUTS
		web : out STD_LOGIC_vector(0 downto 0);--TO RAM WRITE ENABLE PORT B
		dataout : out STD_LOGIC_vector(2 downto 0);	--WRITE A PEG, ++ OUTPUT, CURSOR OR BLANK
		RAMaddr : out STD_LOGIC_vector(6 downto 0) --TO RAM, CHANGE GAME BOARD
		);
end Board_Updater_dp;


architecture Board_Updater_dp of Board_Updater_dp is	
	
	
	signal dataouts,dataouts2: std_logic_vector (2 downto 0);
	signal addrs, loc1s, loc2s, RAMaddrs, cursors,whatever7: std_logic_vector (6 downto 0);	
	signal whatever: std_logic_vector (0 downto 0);
	signal webs : std_logic_vector(0 downto 0);
begin
	
	whatever <= "0"; --USED FOR PINS THAT ARE NOT NEEDED
	whatever7 <= "0000000"; --USED FOR PINS THAT ARE NOT NEEDED
	
-----------------------------------------------------------------------------------------------
--START OF REGISTERS---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------	
	
	cursor_Reg : entity reg
	generic map(
		N => 7
		)
	port map(
		load => load_cursor,
		clk => clk,
		clr => clr,
		d => cursor,
		q => cursors
		);
	
	loc1_Reg : entity reg
	generic map(
		N => 7
		)
	port map(
		load => load_loc1,
		clk => clk,
		clr => clr,
		d => loc1,
		q => loc1s
		);
	loc2_Reg : entity reg
	generic map(
		N => 7
		)
	port map(
		load => load_loc2,
		clk => clk,
		clr => clr,
		d => loc2,
		q => loc2s
		);		
	
--	DataOutReg : entity reg
--	generic map(
--		N => 3
--		)
--	port map(
--		load => load_dataout,
--		clk => clk,
--		clr => clr,
--		d => dataouts,
--		q => dataouts2
--		);	
--	
--	AddrReg : entity reg
--	generic map(
--		N => 7
--		)
--	port map(
--		load => load_addr,
--		clk => clk,
--		clr => clr,
--		d => addrs,
--		q => RAMaddrs
--		);		  
-----------------------------------------------------------------------------------------------
--START OF MUX---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

	DataOutMux : entity mux4g
	generic map(
		N => 3
		)
	port map(
		a => "111",--cursor
		b => "100",--blank
		c => out_peg,
		d => plusplus_out, -- ++ COMING FROM ++COMPONANT(SEPERATE)
		s => sel_dataout,
		y => dataouts
		);	
	AddrMux : entity mux4g
	generic map(
		N => 7
		)
	port map(
		a => cursors,
		b => loc1s,
		c => loc2s,
		d => whatever7,
		s => sel_addrout,
		y => addrs
		);
	
	write_enable_mux : entity mux4g
	generic map(
		N => 1
		)
	port map(
		a => plusplus_we,--write enable coming from the plus plus block
		b => sm_we,	--State Machine write enable, coming from the very top
		c => whatever,--dont need, groundED
		d => whatever,-- dont need, groundED
		s => sel_we,
		y => webs
		);
	web <= webs;
	RAMaddr<=addrs;
	dataout<=dataouts;
	
end Board_Updater_dp;
