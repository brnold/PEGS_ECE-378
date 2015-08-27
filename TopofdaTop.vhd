-------------------------------------------------------------------------------
--
-- Title       : TopofdaTop
-- Design      : PEGS_GAME_V1
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\PEGS_GAME_V1\PEGS_GAME_V1\src\TopofdaTop.vhd
-- Generated   : Thu Dec  4 16:03:05 2014
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
--{entity {TopofdaTop} architecture {TopofdaTop}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TopofdaTop is 
	port (
	mclk : in std_logic; 
	btn : in std_logic_vector(3 downto 3); --btn 3 is clr
	--sw : in std_logic_vector(3 downto 0);
	ld : out std_logic_vector(7 downto 0);
	hsync : out std_logic;
	vsync : out std_logic;
	red : out std_logic_vector(2 downto 0);
	green : out std_logic_vector(2 downto 0);
	PS2C : in STD_LOGIC;
		PS2D : in STD_LOGIC;
	blue : out std_logic_vector(1 downto 0)
	);
end TopofdaTop;

--}} End of automatically maintained section

architecture TopofdaTop of TopofdaTop is
	



signal keychange, death, gamewon, boardloader_done,counter_clr, boardloader_go, gameplayer_clr, gameplayer_go, increment, sel_mux : std_logic;	
signal keyflag : std_logic_vector(2 downto 0);
begin


	 topperderdopper : entity TopOfTheTop_dp
	port map(
		clk => mclk,
		clr => btn(3),
		--BoardNum => sw(3 downto 0),
		goBoardLoader => boardloader_go,
		goGamePlayer => gameplayer_go,
		keychange => keychange,
		keyflag => keyflag,
		hsync => hsync,
		vsync => vsync,
		doneBoardLoader => boardloader_done,
		gamewon => gamewon,
		death => death,
		RAMAmux => sel_mux,
		increment => increment,
		gameplayer_clr => gameplayer_clr,
		counter_clr => counter_clr,
		red => red,
		green => green,
		blue => blue
	);
	
	Label2 : entity keyboard_top
	port map(
		mclk => mclk,
		PS2C => PS2C,
		PS2D => PS2D,
		clr => btn(3),
		newData => keychange,
		keyflag => keyflag
	);	 
	
	Label3 : entity  Overall_SM
	port map(
		clr => btn(3),
		clk => mclk,
		death => death,
		gamewon => gamewon,
		boardloader_done => boardloader_done,
		ld => ld, 
		keyflag => keyflag,
		gameplayer_go => gameplayer_go,
		sel_mux => sel_mux,
		boardloader_go => boardloader_go,
		gameplayer_clr => gameplayer_clr,
		counter_clr => counter_clr,
		increment => increment
	);
	
end TopofdaTop;
