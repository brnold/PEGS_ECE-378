					  -------------------------------------------------------------------------------
--
-- Title       : TopOfTheTop
-- Design      : PEGS_GAME_V1
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\PEGS_GAME_V1\PEGS_GAME_V1\src\TopOfTheTop.vhd
-- Generated   : Thu Dec  4 14:14:35 2014
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
--{entity {TopOfTheTop} architecture {TopOfTheTop}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all;

entity TopOfTheTop_dp is  
	port ( 
	
	clk : in std_logic; 
	clr : in std_logic;	
	--BoardNum : in std_logic_vector (3 downto 0);
	goBoardLoader : in std_logic;	
	goGamePlayer : in std_logic;
	keychange : in std_logic;
	keyflag : in std_logic_vector(2 downto 0);
	hsync, vsync : out std_logic;
	doneBoardLoader, gamewon : out std_logic;
	death : out std_logic;
	RAMAmux : in std_logic;	
	increment : in std_logic;
	gameplayer_clr, counter_clr : in std_logic;
	red : out std_logic_vector(2 downto 0);
	green : out std_logic_vector(2 downto 0);
	blue : out std_logic_vector(1 downto 0)
	);
end TopOfTheTop_dp;

--}} End of automatically maintained section

architecture TopOfTheTop_dp of TopOfTheTop_dp is	
signal clk40 : std_logic; 
signal wea, web : std_logic_vector(0 downto 0);
	signal addraS, VGAaddr, BoardLoaderaddr, ADDRB : std_logic_vector(6 downto 0);
    signal BoardNum	: std_logic_vector(4 downto 0);	
	signal douta,DOUTB,dinb, dina : std_logic_vector(2 downto 0);
begin
	
	-----------------------------------
	--Mux for RAMport A
	-----------------------------------
	process( RAMAmux,BoardLoaderaddr, VGAaddr ) 
	begin			
		if(RAMAmux = '1') then
			addraS <= BoardLoaderaddr;
		else
			addraS <= VGAaddr;
		end if;
	end process;
	
	------------------------------------------
	--Load board levels
	------------------------------------------	
	boardLoader : entity RAMloader
	port map(
		clk => clk40,
		clr => clr,
		go => goBoardLoader,
		BoardNum => BoardNum(4 downto 1),
		done => doneBoardLoader,
		wea => wea(0),
		RAMaddr => BoardLoaderaddr,
		RAMout => dina
	);
	
	-----------------------------------------
	--Fourty MHZ clock
	-----------------------------------------
	Fourty_MHZ : entity clock40_1200
	port map(
		CLKIN_IN => clk,
		RST_IN => clr,
		CLKFX_OUT => clk40,
		CLK0_OUT => open,
		LOCKED_OUT => open			--do we want to use this maybe?
	);															  
	
	------------------------------------------
	--DUALPortRam
	------------------------------------------
	DualPortRAM : entity  blk_mem_gen_v7_3
	port map(
		clka => clk40,
		wea => wea,
		addra => addraS,
		dina => dina,
		douta => douta,
		clkb => clk,
		web => web,
		addrb => addrb,
		dinb => dinb,
		doutb => doutb
	); 
	
	-------------------------------------
	--The Game logic comp that does everything
	------------------------------------
	
	GamePlayerComp : entity GamePlayer
	port map(  
		clk => clk,
		clr => gameplayer_clr,
		go => goGamePlayer,
		keychange => keychange,
		keyflag => keyflag,
		DOUTB => DOUTB,
		death => death,
		gamewon => gamewon,
		ADDRB => ADDRB,
		WEB => WEB,
		DINB => DINB
	);
	---------------------------------------
	--COUNTER, level kepertracker ofer
	---------------------------------------
--	process(increment, counter_clr)
--	begin
--		if counter_clr = '1' then
--			BoardNum <= "0000";
--		elsif increment'event and increment = '1' then
--			BoardNum <= BoardNum + 1;
--		end if;							 
--	end process;   
	
	counterforboardloader : entity counter
	generic map(
		N => 5
	)
	port map(
		clr => counter_clr,
		clk => increment,
		q => BoardNum
	);
	
	
	--------------------------------------
	--VGA COMP
	--------------------------------------
	
	Label1 : entity VGAtop2
	port map(
		clk40 => clk40,
		clr => clr,
		hsync => hsync,
		vsync => vsync,
		RAMin => douta,
		RAMaddr => VGAaddr,
		red => red,
		green => green,
		blue => blue
	);
	
end TopOfTheTop_dp;
