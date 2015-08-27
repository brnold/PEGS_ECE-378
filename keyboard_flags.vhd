--edited by Benjamin 

library IEEE;
use IEEE.STD_LOGIC_1164.all; 

use IEEE.STD_LOGIC_unsigned.all;
use ieee.std_logic_misc.all;

entity keyboard_flags is
	port(
		cclk : in STD_LOGIC;
		clr : in STD_LOGIC;
		keyval2 : in STD_LOGIC_VECTOR (7 downto 0);
		keyflag : out STD_LOGIC_VECTOR (2 downto 0);
		newData : out std_logic
		);
end keyboard_flags;



architecture keyboard_flags of keyboard_flags is 
	
	constant U_arrow: STD_LOGIC_VECTOR(7 downto 0) := X"75";   -- up arrow
	constant D_arrow: STD_LOGIC_VECTOR(7 downto 0) := X"72";   -- down arrow
	constant L_arrow: STD_LOGIC_VECTOR(7 downto 0) := X"6B";   -- left arrow
	constant R_arrow: STD_LOGIC_VECTOR(7 downto 0) := X"74";   -- right arrow
	constant enter: STD_LOGIC_VECTOR(7 downto 0) := X"70"; 	   -- insert key (used to select) 
	constant BKSP: STD_LOGIC_VECTOR(7 downto 0) := X"71";	   -- delete (used to restart, can be changed)	
	
	
	signal keyflag_s, d1: std_logic_vector(2 downto 0);	
	--signal temp <= std_logic;
	
begin	
	--process(keyval2)
	--		begin
	--		   
	--			case keyval2 is
	--				when U_arrow => keyflag_s <= "000";
	--				when others => keyflag_s <="111"; 
	--				end case;
	--		end process;
	--	
	
	keyflag <= keyflag_s;	
	
	
	process(cclk, clr, keyval2) 	
	begin	 
		
		
		if clr = '1' then
			keyflag_s <= "111";
			--temp <= '0';
			--elsif cclk'event and cclk = '1' then		   
		else
			
			if keyval2 = U_arrow then
				keyflag_s <= "000";			  -- up flag 000
				--temp = not(temp);
			elsif keyval2 = D_arrow then
				keyflag_s <= "001";			  -- down flag 001
				
			elsif keyval2 = L_arrow then
				keyflag_s <= "010";			  -- left flag 010
				
			elsif keyval2 = R_arrow then
				keyflag_s <= "011";	 		  -- right flag 011
				
			elsif keyval2 = enter then
				keyflag_s <= "100";			  -- enter flag 100
				
			elsif keyval2 = BKSP then
				keyflag_s <= "101";			  -- restart flag 101
			else
				keyflag_s <="111";			  -- other key/nothing flag 111
			end if;
			
		end if;			
	end process;
	
	
	
	process (cclk, keyflag_s)	--makes new data go high for one clock cycle when the key changes
	begin
		if cclk'event and cclk = '1' then
			d1 <= keyflag_s;
		end if;
	end process;
	
	--newData <= '0' when (d1 xor keyflag_s) = 0 else '1';
	
	process(keyflag_s, d1, keyval2)
	begin
		if(keyval2 = x"F0") then
			newData <= '0';
			
		elsif((d1 xor keyflag_s) = "000")	then
			newData <= '0'; 
		else 
			newData <= '1';
			
		end if;
		--newData <= '0' when (d1 xor keyflag_s) = 0 else '1';
		
	end process;
	
	
	
end keyboard_flags;
