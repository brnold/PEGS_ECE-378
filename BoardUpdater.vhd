

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity BoardUpdater is
	 port(
		 boardupdater_GO : in STD_LOGIC;
		 movement_flag : in STD_LOGIC;
		 pluscombo_flag : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 keyflag : in STD_LOGIC_VECTOR(2 downto 0);
		 keychange : in std_logic;
		 OutPeg : in STD_LOGIC_VECTOR(2 downto 0);
		 cursor : in STD_LOGIC_VECTOR(6 downto 0);
		 loc1 : in STD_LOGIC_VECTOR(6 downto 0);
		 loc2 : in STD_LOGIC_VECTOR(6 downto 0);  
		 peg1wea, peg2wea : in std_logic;
		 updater_done_flag : out STD_LOGIC; 
		 data_out : out STD_LOGIC_VECTOR(2 downto 0);
		 WEB : out STD_LOGIC_VECTOR(0 downto 0);
		 RAMaddr : out STD_LOGIC_VECTOR(6 downto 0)
	     );
end BoardUpdater;



architecture BoardUpdater of BoardUpdater is   	 


	component BoardUpdate_StateMachine
	port(
		updater_go : in STD_LOGIC;
		movement_flag : in STD_LOGIC;
		pluscombo_flag : in STD_LOGIC;
		done_flag : in STD_LOGIC;
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		sm_WEB : out STD_LOGIC_VECTOR(0 downto 0);
		plusplusgo_flag : out STD_LOGIC;
		load_cursor : out STD_LOGIC;
		load_loc1 : out STD_LOGIC;
		load_loc2 : out STD_LOGIC;
		load_dataout : out STD_LOGIC;
		load_addr : out STD_LOGIC;
		--PEG write line enable 
		peg1wea, peg2wea : in std_logic;
		
		updater_done_flag : out STD_LOGIC; 
		sel_addrout : out STD_LOGIC_VECTOR(1 downto 0);
		sel_dataout : out STD_LOGIC_VECTOR(1 downto 0);
		sel_we : out STD_LOGIC_VECTOR(1 downto 0));
	end component;	   
	
	
	component Board_Updater_dp
	port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		loc1 : in STD_LOGIC_VECTOR(6 downto 0);
		loc2 : in STD_LOGIC_VECTOR(6 downto 0);
		cursor : in STD_LOGIC_VECTOR(6 downto 0);
		out_peg : in STD_LOGIC_VECTOR(2 downto 0);
		plusplus_out : in STD_LOGIC_VECTOR(2 downto 0);
		plusplus_we : in STD_LOGIC_VECTOR(0 downto 0);
		sm_we : in STD_LOGIC_VECTOR(0 downto 0);
		load_cursor : in STD_LOGIC;
		load_loc1 : in STD_LOGIC;
		load_loc2 : in STD_LOGIC;
		load_dataout : in STD_LOGIC;
		load_addr : in STD_LOGIC;
		sel_dataout : in STD_LOGIC_VECTOR(1 downto 0);
		sel_addrout : in STD_LOGIC_VECTOR(1 downto 0);
		sel_we : in STD_LOGIC_VECTOR(1 downto 0);
		web : out STD_LOGIC_VECTOR(0 downto 0);
		dataout : out STD_LOGIC_VECTOR(2 downto 0);
		RAMaddr : out STD_LOGIC_VECTOR(6 downto 0));
	end component;	   
	

	component plusplus_block
	port(
		go : in STD_LOGIC;
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		keyflag : in STD_LOGIC_VECTOR(2 downto 0);
		keychange : in std_logic;
		done_flag : out STD_LOGIC;
		WEB : out STD_LOGIC_VECTOR(0 downto 0);
		plusplus_out : out STD_LOGIC_VECTOR(2 downto 0));
	end component;
	
signal sel_dataout, sel_addrout, sel_we: std_logic_vector (1 downto 0);
signal sm_we, plusplus_we: std_logic_vector (0 downto 0);
signal plusplus_out: std_logic_vector (2 downto 0);
signal done_flag, plusplusgo_flag, load_cursor, load_loc1, load_loc2, load_dataout, load_addr: std_logic;





begin

	 SM : BoardUpdate_StateMachine
	port map(
	updater_done_flag => updater_done_flag,
		updater_go => boardupdater_GO,
		movement_flag => movement_flag,
		pluscombo_flag => pluscombo_flag,
		done_flag => done_flag,
		clk => clk,
		clr => clr,
		sm_WEB => sm_WE,
		plusplusgo_flag => plusplusgo_flag,
		load_cursor => load_cursor,
		load_loc1 => load_loc1,
		load_loc2 => load_loc2,
		load_dataout => load_dataout,
		load_addr => load_addr,	
		peg1wea => peg1wea,
		peg2wea	=> peg2wea,
		sel_addrout => sel_addrout,
		sel_dataout => sel_dataout,
		sel_we => sel_we
	);		 
	
	DP : Board_Updater_dp
	port map(
		clk => clk,
		clr => clr,
		loc1 => loc1,
		loc2 => loc2,
		cursor => cursor,
		out_peg => outpeg,
		plusplus_out => plusplus_out,
		plusplus_we => plusplus_we,
		sm_we => sm_we,
		load_cursor => load_cursor,
		load_loc1 => load_loc1,
		load_loc2 => load_loc2,
		load_dataout => load_dataout,
		load_addr => load_addr,
		sel_dataout => sel_dataout,
		sel_addrout => sel_addrout,
		sel_we => sel_we,
		web => web,
		dataout => data_out,
		RAMaddr => RAMaddr
	);			
	
	PlusPlus : plusplus_block
	port map(
		go => plusplusgo_flag,
		clk => clk,
		clr => clr,
		keyflag => keyflag,
		keychange => keychange,
		done_flag => done_flag,
		WEB => plusplus_we,
		plusplus_out => plusplus_out
	);

end BoardUpdater;
