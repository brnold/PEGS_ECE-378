-------------------------------------------------------------------------------
--
-- Title       : RAMloader
-- Design      : PEGSvga
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\PEGSvga\PEGSvga\src\RAMloader.vhd
-- Generated   : Thu Nov 27 19:40:00 2014
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
--{entity {RAMloader} architecture {RAMloader}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMloader is
	 port(
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 go : in std_logic;
		 BoardNum : in STD_LOGIC_VECTOR(3 downto 0);
		 done : out STD_LOGIC; 
		 wea : out std_logic;
		 RAMaddr : out STD_LOGIC_VECTOR(6 downto 0);
		 RAMout : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end RAMloader;

	


architecture RAMloader of RAMloader is
	-- Component declaration of the "RAMloader_dp(ramloader_dp)" unit defined in
	-- file: "./../src/RAMloader_dp.vhd"
	component RAMloader_dp
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		load : in STD_LOGIC;
		Rloaded : out STD_LOGIC;
		RAMout : out STD_LOGIC_VECTOR(2 downto 0);
		ROMin : in STD_LOGIC_VECTOR(2 downto 0);
		baordNum : in STD_LOGIC_VECTOR(3 downto 0);
		RAMaddr : out STD_LOGIC_VECTOR(6 downto 0);
		ROMaddr : out STD_LOGIC_VECTOR(10 downto 0));
	end component;
	for all: RAMloader_dp use entity work.RAMloader_dp(ramloader_dp);

  			-- Component declaration of the "RAMloader_sm(ramloader_sm)" unit defined in
	-- file: "./../src/RAMloader_sm.vhd"
	component RAMloader_sm
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		go : in STD_LOGIC;
		Rloaded : in STD_LOGIC;
		load : out STD_LOGIC;
		wea : out STD_LOGIC;
		done : out STD_LOGIC);
	end component;
	for all: RAMloader_sm use entity work.RAMloader_sm(ramloader_sm);



		signal Rloaded, load : std_logic;
		signal ROMaddr : STD_LOGIC_VECTOR(10 downto 0);	
		signal ROMin : STD_LOGIC_VECTOR(2 downto 0);
begin
  Label1 : RAMloader_dp
	port map(
		clk => clk,
		clr => clr,
		load => load,
		Rloaded => Rloaded,
		RAMout => RAMout,
		ROMin => ROMin,
		baordNum => BoardNum,
		RAMaddr => RAMaddr,
		ROMaddr => ROMaddr
	);
	
	SM :   RAMloader_sm
	port map(
		clk => clk,
		clr => clr,
		go => go,
		Rloaded => Rloaded,
		load => load,
		wea => wea,
		done => done
	);	 
	
	  
	
	lvlrom : entity RAMUSEME
	port map(
		clka => clk,
		addra => ROMaddr,
		douta => ROMin
	);
	
	 

end RAMloader;
