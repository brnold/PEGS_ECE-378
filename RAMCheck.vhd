-------------------------------------------------------------------------------
-- Title       : RAMCheck
-- Design      : PEGs
-------------------------------------------------------------------------------
-- MODIFIED
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity RAMCheck is
	port(
		clk : in STD_LOGIC;
		go: in STD_LOGIC;
		clr : in STD_LOGIC;
		DOUTB : in STD_LOGIC_VECTOR(2 downto 0);
		done: out STD_LOGIC;
		gameWon : out STD_LOGIC;
		addrB : out STD_LOGIC_VECTOR(6 downto 0);
		addr_cursor : out STD_LOGIC_VECTOR(6 downto 0)
		);
end RAMCheck;

architecture RAMCheck of RAMCheck is
signal clr_count,clr_reg, inc_count, inc_done, pegleftcheckflag : std_logic;
begin 
	
	Label1 : entity RAMCheck_DP
	port map(
		clk => clk,
		clr_count => clr_count,
		inc_count => inc_count,
		clr_reg => clr_reg,
		pegleftcheckflag => pegleftcheckflag,
		count_out => addrB,
		DOUTB => DOUTB,
		cursor_loc => addr_cursor,
		gameWon => gameWon,
		inc_done => inc_done
	);

	 

	
	Label2 : entity RAMCheck_sm
	port map(
		clk => clk,
		clr => clr,
		go => go,
		clr_count => clr_count,
		clr_reg => clr_reg,
		pegleftcheckflag => pegleftcheckflag,
		inc_count => inc_count,
		inc_done => inc_done,
		done => done
	);
	

	
		--process(clk, go, addr_count)
	--begin
	--	if go = '1' or addr_count > 0 then
	--		if clk'event and clk = '1' then
	--			if addr_count = 96 then
	--				done <= '0';
	--				addr_count <= (others => '0');
	--			else
	--				addr_count <= addr_count + 1;
	--			end if;
	--		end if;
	--	else
	--		addr_count <= (others => '0');
	--		done <= '1';
	--	end if;
	--	if addr_count < 96 then
	--		addrb <= addr_count;
	--	end if;
	--end process;
	--
	--process(addr_count, you_win, DOUTB)
	--begin
	--	
	--	if addr_count > 0 then
	--		-- Cursor location
	--		if (DOUTB="111") then
	--			addr_cursor <= addr_count - 2;
	--		end if;	
	--		-- 
	--		if DOUTB(2) /= '0' then
	--			You_Win <= You_Win + 1;
	--		end if;
	--		if addr_count = 96 and You_Win = 96 then
	--			gameWon <= '1';											     
	--		else
	--			gameWon <= '0';
	--		end if;	
	--	else
	--		You_Win <= (others => '0');
	--		gameWon <= '0';
	--	end if;							 
	
	--end process;	 
end RAMCheck;