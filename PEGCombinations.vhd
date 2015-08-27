-------------------------------------------------------------------------------
--
-- Title       : PEGCombinations
-- Design      : PEGs
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PEGCombinations is
	 port(
	 	 -- Control for internal elements
	 	 slt_Mux_Peg2 : in STD_LOGIC;
		 slt_Mux_Peg1 : in STD_LOGIC;
		 -- from SpaceGetter
		 shape_PEG1 : in STD_LOGIC_VECTOR(2 downto 0);
		 shape_PEG2 : in STD_LOGIC_VECTOR(2 downto 0);
		 -- PEG output
		 outPEG : out STD_LOGIC_VECTOR(2 downto 0);
		 -- flags
		 movement : out STD_LOGIC;
		 death : out STD_LOGIC;
		 plus_combo : out STD_LOGIC
	     );
end PEGCombinations;

architecture PEGCombinations of PEGCombinations is
signal out_Mux_PEG1, out_Mux_PEG2: std_logic_vector(2 downto 0);
begin

Mux_PEG1 : entity Mux2
	generic map(
		N => 3
	)
	port map(
		sltLine => slt_Mux_PEG1,
		inRAM => shape_PEG1,
		output => out_Mux_Peg1
	);

Mux_PEG2 : entity Mux2
	generic map(
		N => 3
	)
	port map(
		sltLine => slt_Mux_PEG2,
		inRAM => shape_PEG2,
		output => out_Mux_Peg2
	);

	
PEG_Combos : entity PEGCombs
	port map(
		PEG_1 => out_Mux_PEG1,
		PEG_2 => out_Mux_PEG2,
		OutPEG => OutPEG,
		DEATH => DEATH,
		PLUS_COMBO => plus_combo,
		MOVEMENT => MOVEMENT
	);
	
end PEGCombinations;
