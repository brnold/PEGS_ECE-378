											  library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity VGAtop2 is  
	port(
	clk40 : in std_logic;
	clr : in std_logic;
	hsync : out STD_LOGIC;
	vsync : out STD_LOGIC;	
	RAMin : in std_logic_vector(2 downto 0);
	RAMaddr : out std_logic_vector(6 downto 0);
	red : out std_logic_vector(2 downto 0);
	green : out std_logic_vector(2 downto 0);
	blue : out std_logic_vector(1 downto 0)
	     );
end VGAtop2;			 

architecture VGAtop2 of VGAtop2 is
signal  vidon : std_logic;	
signal ROMin :  std_logic_vector(7 downto 0);
signal	ROMaddr : std_logic_vector(5 downto 0);
 
signal hc, vc : std_logic_vector(10 downto 0);
begin

	
	vga_er : entity  vga_800x600
	port map(
		clk => clk40,
		hsync => hsync,
		vsync => vsync,
		hc => hc,
		vc => vc,
		vidon => vidon
	);	 
	

	Label1 : entity VGA_Display
	port map(
		vidon => vidon,
		hc => hc,
		vc => vc,
		RAMin => RAMin,
		RAMaddr => RAMaddr,
		ROMaddr => ROMaddr,
		ROMin => ROMin,
		red => red,
		green => green,
		blue => blue
	);
	
	PegROM : entity PEGS
	port map(
		addr => ROMaddr,
		M => ROMin
	);

	
end VGAtop2;