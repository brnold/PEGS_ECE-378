-------------------------------------------------------------------------------
--
-- Title       : RAMCheck_DP
-- Design      : PEGS_GAME_V1
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\PEGS_GAME_V1\PEGS_GAME_V1\src\RAMCheck_DP.vhd
-- Generated   : Sat Dec  6 09:08:16 2014
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
--{entity {RAMCheck_DP} architecture {RAMCheck_DP}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity RAMCheck_DP is  
	port(
		clk, clr_count : in std_logic;
		inc_count, clr_reg, pegleftcheckflag : in std_logic;
		count_out : out std_logic_vector(6 downto 0);
		DOUTB : in std_logic_vector(2 downto 0);
		cursor_loc : out std_logic_vector(6 downto 0);
		gameWon : out std_logic;
		inc_done : out std_logic
		);
end RAMCheck_DP;

--}} End of automatically maintained section

architecture RAMCheck_DP of RAMCheck_DP is
signal count, cpegs, curlocs: std_logic_vector(6 downto 0);
signal curReg : std_logic;
begin
	
	
	counter: process(clk, clr_count, inc_count)	 --good
	begin
		if(clr_count = '1') then 
			count <= "0000000";
		elsif(clk = '1' and clk'event and inc_count = '1') then
			count <= count+1;
		end if;
		
	end process;
	
	counterComp : process(count)--good
	begin
		if(count =95) then
			inc_done <= '1';
		else
			inc_done <= '0';
			
		end if;
		
	end process;
	
	process(DOUTB,curReg)	--compaitor
	begin
		if(DOUTB = "111") then
			curReg <= '1';--might be interesting
		else
			curReg <= '0';
		end if;											  
		
		
	end process; 
	
	curlocs <= count -1;
	
	cursorreg : entity reg
	generic map(
		N => 7
	)
	port map(
		load => curReg,
		clk => clk,
		clr => clr_reg,
		d => curlocs,
		q => cursor_loc
	);
	  
	process(clk, clr_count, DOUTB, cpegs)
	begin
		if(clr_count = '1') then 
			cpegs <= "0000000";
		elsif(clk = '1' and clk'event and DOUTB(2) = '0') then
			cpegs <= cpegs+1;							   --count pegs
		end if;	  
		
	end process; 	
	
	------------------------
	--compaitor
	------------------------
	process(cpegs, pegleftcheckflag)
	begin
		if(pegleftcheckflag = '1' and cpegs = 0) then	   
			gameWon <= '1';
		else
			gameWon <= '0'; 
		end if;
	end process;
	
	count_out <= count;
	
end RAMCheck_DP;
