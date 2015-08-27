-- Example 6a: vga_ScreenSaver
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE ieee.numeric_std.ALL;

entity VGA_Display is
	port ( 
		vidon: in std_logic;
		hc : in std_logic_vector(10 downto 0);
		vc : in std_logic_vector(10 downto 0);
		RAMin : in std_logic_vector(2 downto 0);
		RAMaddr : out std_logic_vector(6 downto 0);	
		ROMaddr : out std_logic_vector(5 downto 0);    --(0:63)	 --addr = sprite # + sprite line   
		ROMin : in std_logic_vector(7 downto 0);
	   	red : out std_logic_vector(2 downto 0);
		green : out std_logic_vector(2 downto 0);
		blue : out std_logic_vector(1 downto 0)
		);
end VGA_Display;

architecture VGA_Display of VGA_Display is 
	signal hcd64, vcd64 : std_logic_vector(3 downto 0);	--divded by 64 signal
	signal hcd8 : std_logic_vector(6 downto 0);  --divded by 8 signal
	signal  vcd8 : std_logic_vector(5 downto 0);  --divded by 8 signal --DON'T CHANGE THIS
	signal inthcd8, intvcd8, spriteNum : integer;
	
	constant w: integer := 768;
	constant h: integer := 512;	 
	constant C1: integer := 16; 
	constant R1: integer := 44;		
	signal spriteon, m: std_logic;
begin 
	

	  
	hcd64	<= hc(9 downto 6); --divded by 64
	vcd64	<= vc(9 downto 6); --divded by 64
	
	hcd8	<= hc(9 downto 3); --divded by 8
	vcd8	<= vc(8 downto 3); --divded by 8	
	
	intvcd8 <= to_integer(signed(vcd8));	  --convert to int for Mod function
	spriteNum <= intvcd8 mod 8;				  --get sprite number	
	--ROM addr	
	--Sprite Number * 8
	ROMaddr <= (RAMin & "000") + spriteNum; --Select the line in the game piece 
	

	--game sprite(0:6) + sprite line(0:6)		
	--end rom component
	
	RAMaddr <= ("000" & hcd64) + (vcd64 & "000") + ('0' & vcd64 & "00");
	
	inthcd8 <= to_integer(signed(hcd8));	  --convert to int for Mod function
	process(inthcd8)						  --used to scale the sprite by 8
	variable count : integer;	
	begin
		count := inthcd8 mod 8;		
		m <= ROMin(count);		
	end process; --FIST BUMP
	
	spriteon <= '1' when (((hc > C1) and (hc <= C1 + w)) --Sprite on figureouter
	and ((vc >= R1 ) and (vc < R1 + h))) else '0'; 
	
	
	
	process(spriteon, vidon, M)
		variable j: integer;
	begin
		red <= "000";
		green <= "000";
		blue <= "00";
		if spriteon = '1' and vidon = '1' then
			if(M = '0') then				  --Display white
				red <= "111";
				green <= "111";
				blue <= "11"; 
			else						--Display black
				red <= "000";
				green <= "000";
				blue <= "00";
			end if;
			
		end if;
	end process; 
	
end VGA_Display;