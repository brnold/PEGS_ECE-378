

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GamePlayer_DataPath is
	port( 
	--INPUTS 
		--Input from Keyboard
		keyflag: in std_logic_vector (2 downto 0);
		keychange : in std_logic;
		--Go Signals for individual blocks
		 BoardUpdater_GO : in STD_LOGIC;
		 RAMCheck_GO : in STD_LOGIC;
		 SpaceGetter_GO : in STD_LOGIC;	  
		--Select Line for the mux for ADDRB
		 sel_addrb_mux : in std_logic_vector (1 downto 0);
		--Data from the RAM
		 DOUTB : in STD_LOGIC_VECTOR(2 downto 0); 
		-- clk and clr
		 clk: in std_logic;
		 clr: in std_logic;
		 
		 
	--OUTPUTS 
		--death and game won flags
		death : out STD_LOGIC;	 
		gameWon : out STD_LOGIC;
		--Done signals for individual blocks
		 BoardUpdater_done : out STD_LOGIC;
		 SpaceGetter_done : out STD_LOGIC;
		 RAMCheck_done : out STD_LOGIC;	
		--Lines going to the RAM
		 ADDRB : out STD_LOGIC_VECTOR(6 downto 0);
		 WEB : out STD_LOGIC_VECTOR(0 downto 0);
		 DINB : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end GamePlayer_DataPath;



architecture GamePlayer_DataPath of GamePlayer_DataPath is	

signal shape_peg1, shape_peg2: std_logic_vector(2 downto 0);
--select lines for pegs combo block
signal slt_Mux_Peg2, slt_Mux_Peg1, peg1weas, peg2weas: std_logic;
--addresses for the cursor, peg1, and peg2 spaces
signal addr_peg1, addr_peg2, addr_cursor: std_logic_vector (6 downto 0);

--flags from the pegs combo block
signal movement, plus_combo: std_logic;	
-- output peg from the plus combo block
signal out_peg : std_logic_vector (2 downto 0);
-- signals that go to ADDRB
signal addrb_ramcheck, addrb_spacegetter, addrb_boardupdater : std_logic_vector (6 downto 0);
signal zeros7 : std_logic_vector (6 downto 0); --for unused addr mux lines

begin 
	zeros7 <= "0000000";

	addrb_mux : entity mux4g
	generic map(
		N => 7
	)
	port map(
		a => addrb_ramcheck,
		b => addrb_spacegetter,
		c => zeros7,
		d => addrb_boardupdater,
		s => sel_addrb_mux,
		y => ADDRB
	); 
	
	BoardUpdater_Block : entity BoardUpdater
	port map(
		boardupdater_GO => BoardUpdater_GO,
		movement_flag => movement,
		pluscombo_flag => plus_combo,
		clk => clk,
		clr => clr,
		keyflag => keyflag,
		keychange => keychange,
		OutPeg => Out_Peg,
		cursor => addr_cursor,
		loc1 => addr_peg1,
		loc2 => addr_peg2,
		peg1wea => peg1weas, 
		peg2wea => peg2weas,
		updater_done_flag => BoardUpdater_done,
		data_out => DINB,
		WEB => WEB,
		RAMaddr => addrb_boardupdater
	);
	
	peg1weas <= not(slt_Mux_Peg1);
	peg2weas <= not(slt_Mux_Peg2);
	
	
	RAMCheck_block : entity RAMCheck
	port map(
		clk => clk,
		go => ramcheck_go,
		clr => clr,
		DOUTB => DOUTB,
		done => ramcheck_done,
		gameWon => gameWon,
		addrB => addrB_ramcheck,
		addr_cursor => addr_cursor
	);
	
	PegsCombo_block : entity PEGCombinations
	port map(
		slt_Mux_Peg2 => slt_Mux_Peg2,
		slt_Mux_Peg1 => slt_Mux_Peg1,
		shape_PEG1 => shape_PEG1,
		shape_PEG2 => shape_PEG2,
		outPEG => out_PEG,
		movement => movement,
		death => death,
		plus_combo => plus_combo
	);	
	
	
	SpaceGetter_block : entity RAMValueGetter
	port map(
		clk => clk,
		clr => clr,
		go => spacegetter_go,
		CursorLoc => addr_cursor,
		RAM_data => DOUTB,
		keyflag => keyflag,
		RAM_addr => addrb_spacegetter,
		loc1 =>addr_peg1,
		loc2 => addr_peg2,
		shape_peg_1 => shape_peg1,
		shape_peg_2 => shape_peg2,
		slt_mux_PEG1 => slt_mux_PEG1,
		slt_mux_PEG2 => slt_mux_PEG2,
		done => spacegetter_done
	);
	

end GamePlayer_DataPath;
