library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GamePlayer is
	port(	 
	clk : in STD_LOGIC;	
	clr : in STD_LOGIC;	
		--go signal from top level
		go : in STD_LOGIC;		  
		--inputs from keyboard
		 keychange : in STD_LOGIC;
		 keyflag : in STD_LOGIC_VECTOR(2 downto 0);	
		 
		 --input from RAM
		 DOUTB : in STD_LOGIC_VECTOR(2 downto 0); 
		 
		 --flags to top level
		 death : out STD_LOGIC;
		 gamewon : out STD_LOGIC; 
		 
		 --outputs to RAM
		 ADDRB : out STD_LOGIC_VECTOR(6 downto 0);
		 WEB : out STD_LOGIC_VECTOR(0 downto 0);
		 DINB : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end GamePlayer;



architecture GamePlayer of GamePlayer is  

signal boardupdater_go, RAMcheck_go, SpaceGetter_go : std_logic;
signal boardupdater_done, RAMcheck_done, SpaceGetter_done : std_logic;
signal sel_addrb_mux : std_logic_vector (1 downto 0);
begin

	DP : entity GamePlayer_DataPath
	port map(
	keyflag => keyflag,
	keychange => keychange,
		BoardUpdater_GO => BoardUpdater_GO,
		RAMCheck_GO => RAMCheck_GO,
		SpaceGetter_GO => SpaceGetter_GO,
		sel_addrb_mux => sel_addrb_mux,
		DOUTB => DOUTB,
		clk => clk,
		clr => clr,
		death => death,
		gamewon => gamewon,
		BoardUpdater_done => BoardUpdater_done,
		SpaceGetter_done => SpaceGetter_done,
		RAMCheck_done => RAMCheck_done,
		ADDRB => ADDRB,
		WEB => WEB,
		DINB => DINB
	);	   	
	
	SM : entity GamePlayer_SM
	port map(
		go => go,
		clk => clk,
		clr => clr,
		ramcheck_done => ramcheck_done,
		spacegetter_done => spacegetter_done,
		boardupdater_done => boardupdater_done,
		keychange => keychange,
		--keyflag => keyflag,
		sel_addrb_mux => sel_addrb_mux,
		boardupdater_go => boardupdater_go,
		ramcheck_go => ramcheck_go,
		spacegetter_go => spacegetter_go
	);


end GamePlayer;
