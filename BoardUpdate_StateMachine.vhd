
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity BoardUpdate_StateMachine is
	 port(
		 updater_go : in STD_LOGIC;
		 movement_flag : in STD_LOGIC;
		 pluscombo_flag : in STD_LOGIC;
		 done_flag : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;	 
		 sm_WEB : out STD_LOGIC_vector(0 downto 0);
		 
		 plusplusgo_flag : out STD_LOGIC; 
		 
		 updater_done_flag : out STD_LOGIC; 
		 
		 load_cursor : out STD_LOGIC;
		 load_loc1 : out STD_LOGIC;
		 load_loc2 : out STD_LOGIC;
		 load_dataout : out STD_LOGIC;
		 load_addr : out STD_LOGIC;	
		 
		 --PEG write line enable 
		 peg1wea, peg2wea : in std_logic;
		 
		 sel_addrout : out STD_LOGIC_vector (1 downto 0);
		 sel_dataout : out STD_LOGIC_vector (1 downto 0);
		 sel_we : out STD_LOGIC_vector (1 downto 0)
	     );
end BoardUpdate_StateMachine;

architecture BoardUpdate_StateMachine of BoardUpdate_StateMachine is	 

type state_type is (start, done, movecheck, plusplusgo, setcursor, peg1writecheck, peg2writecheck, setpeg1, setpeg2);

signal present_state, next_state: state_type;

begin	 
	
sreg:process(clk, clr)
	begin
	if clr = '1' then
		present_state <= start;
	elsif clk'event and clk = '1' then
		present_state <= next_state;
	end if;
	end process;	
	
C1: process(present_state, movement_flag, pluscombo_flag, done_flag, updater_go, peg1wea, peg2wea)
	
	begin		   
		
	case (present_state) is  
	
	when start =>	
		if updater_go = '1' then
			next_state <= movecheck;
		else
			next_state <= start;
		end if;	  
		
	when movecheck => 
		if movement_flag = '1' then
			next_state <= setcursor;
		else 
			next_state <= done;
		end if;	 
		
	when setcursor =>
		next_state <= peg1writecheck;
		
	when peg1writecheck=>
	if(peg1wea = '1') then  --if enabled, then go set the peg
		next_state <= setpeg1;
	else 
		next_state <= done;  --else skip to end, no movement here
	end if;
		
	when setpeg1 =>
		if pluscombo_flag = '1' then
	    	next_state <= plusplusgo;	
		else
			next_state <= peg2writecheck;
		end if;
		
	when peg2writecheck =>
	   if(peg2wea = '1') then		--if enabled, then go set the peg
		next_state <= setpeg2;
	else 
		next_state <= done; --else done to the next peg
		end if;
		
	when setpeg2 =>
		next_state <= done;
	
	when plusplusgo =>
		if done_flag = '1' then
		  	next_state <= done;
		else
			next_state <= plusplusgo;
		end if;
		
	when others =>			  -- includes the done state #that was smart!
		next_state <= start;
	
	end case;
	end process;
	
	
C2: process (present_state)
begin	   
	updater_done_flag <= '0';
	sm_WEB <= "0";
	plusplusgo_flag <= '0';
		load_cursor <= '0';
		load_loc1  <= '0';
		load_loc2 <=  '0';
		load_dataout <=	'0';
		load_addr <=  '0';
		sel_addrout <= "00";
		sel_dataout <= "00";
		sel_we <=	   "01";	  -- set to the state machine's WE normally

	
	case (present_state) is
	
	when start =>	
		load_cursor <= '1';
		load_loc1  <= '1';
		load_loc2 <=  '1';  
		
	when movecheck => 
		null;
		
	when setcursor =>
		sm_WEB <= "1";		  --state machine brings WEB high
		sel_we <= "01"; 		  --lets the state machine set WEB
		sel_addrout <= "00";	  -- selects to the cursor addr
		load_addr <= '1';
		sel_dataout <= "01";	  -- selects the blank piece data
		load_dataout <= '1';
	
	
	when setpeg1 =>	 
		sm_WEB <= "1";		  --state machine brings WEB high
		sel_we <= "01"; 		  --lets the state machine set WEB
		sel_addrout <= "01";	  -- selects the loc1 addr
		load_addr <= '1';
		sel_dataout <= "00";	  -- selects the cursor piece data
		load_dataout <= '1';
		
		
	when setpeg2 =>	 
		sm_WEB <= "1";		  --state machine brings WEB high
		sel_we <= "01"; 		  --lets the state machine set WEB
		sel_addrout <= "10";	  -- selects the loc2 addr
		load_addr <= '1';
		sel_dataout <= "10";	  -- selects the loc2/outpeg piece data
		load_dataout <= '1';
		
		
	
	when plusplusgo => 
		
		sel_we <= "00"; 		  --lets the plusplus block set WEB
		sel_addrout <= "10";	  -- selects the loc2 addr	--THATS RIGHT DON'T TOUCH IT!
		load_addr <= '1';
		sel_dataout <= "11";	  -- selects the plusplusout piece data
		load_dataout <= '1';	  
		
		plusplusgo_flag <= '1';
			
	when done => 
		updater_done_flag <= '1';
	
	when others =>
		null;
		
	
	end case;
	end process;
	
	

end BoardUpdate_StateMachine;
