-------------------------------------------------------------------------------
--
-- Title       : RAMCheck_sm
-- Design      : PEGS_GAME_V1
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\PEGS_GAME_V1\PEGS_GAME_V1\src\RAMCheck_sm.vhd
-- Generated   : Sat Dec  6 09:08:07 2014
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {RAMCheck_sm} architecture {RAMCheck_sm}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMCheck_sm is 
	port(clk, clr, go : in std_logic;
		clr_count, clr_reg, pegleftcheckflag : out std_logic;
		inc_count : out std_logic;
		inc_done : in std_logic;
		done : out std_logic
		);
end RAMCheck_sm;

--}} End of automatically maintained section

architecture RAMCheck_sm of RAMCheck_sm is
	type state_type is (start, reg_clr, scanRam, pegLeftCheck, dones, useless);	
	signal present_state, next_state: state_type;
begin
	
	sreg: process(clk, clr)
	begin
		if clr = '1' then
			present_state <= start;
		elsif(clk'event and clk = '1' )then
			present_state <= next_state;
		end if;				   
	end process;
	
	
	C1: process(present_state, inc_done, go)
		
	begin		   
		case (present_state) is  
			
			when start =>	
				if go = '1' then
					next_state <= reg_clr;
				else
					next_state <= start;
				end if;	
			
			when reg_clr =>
				next_state <= scanRam;
			
			when scanRam =>	
				
				if inc_done = '1' then
					next_state <= useless;
				else 
					next_state <= scanRam;
				end if;
			
				when useless =>
				 next_state <= pegLeftCheck;
				
			when pegLeftCheck =>
				next_state <= dones;
			
			when dones =>
				next_state <= start;
				
			
			when others =>
				next_state <= start;
			
		end case;
		
	end process;
	
	C2: process (present_state)
	begin	   
		clr_count <= '0';
		inc_count <= '0';
		done <= '0';  
		clr_reg <= '0';
		pegleftcheckflag <= '0';
		
		case (present_state) is
			when start => 
			clr_count <= '1';
			when reg_clr =>
			clr_reg <= '1';
			when scanRam =>
			inc_count <= '1';
			when pegLeftCheck =>
				pegleftcheckflag <= '1';
			
			when dones => 
			done <= '1';
			when others => null;
			
		end case;
		
	end process;  
	
end RAMCheck_sm;
