library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity GamePlayer_SM is
	 port(
		 go : in STD_LOGIC;	 -- from the top level
		 clk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 ramcheck_done : in STD_LOGIC;
		 spacegetter_done : in STD_LOGIC;
		 boardupdater_done : in STD_LOGIC;
		 keychange : in STD_LOGIC;	--from the top level  
		-- keyflag : in STD_LOGIC_VECTOR(2 downto 0);
		 sel_addrb_mux : out std_logic_vector (1 downto 0);
		 boardupdater_go : out STD_LOGIC;
		 ramcheck_go : out STD_LOGIC;
		 spacegetter_go : out STD_LOGIC
	     );
end GamePlayer_SM;

architecture GamePlayer_SM of GamePlayer_SM is	

type state_type is (start, waitkey, ramcheck, spacegetter, boardupdater);

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
	
	
	C1: process(present_state, spacegetter_done, boardupdater_done, ramcheck_done, go, keychange)
	
	begin		   
		
	case (present_state) is  
	
	when start =>	
	--if go = '1' and keyflag /= "111" then  
		if go = '1' then
			next_state <= ramcheck;
			
		else
			next_state <= start;
		end if;	  
		
	when ramcheck =>	
		if ramcheck_done = '1' then
			next_state <= waitkey;
		else
			next_state <= ramcheck;
		end if;	 
		
	when waitkey =>	
		if keychange = '1' then
			next_state <= spacegetter;
		else
			next_state <= waitkey;
		end if;	
	 
		
		
		
	when spacegetter =>	
		if spacegetter_done = '1' then
			next_state <= boardupdater;
		else
			next_state <= spacegetter;
		end if;	   
		
	when boardupdater =>	
		if boardupdater_done = '1' then
			next_state <= ramcheck;
		else
			next_state <= boardupdater;
		end if;	 
		
	when others =>
	next_state <= start;
	
	end case;
	end process;
	
	C2: process (present_state)
	begin	 
	boardupdater_go <= '0';
	ramcheck_go    <= '0';
	spacegetter_go <= '0'; 
	sel_addrb_mux <= "00";
	
	case (present_state) is
	
	when ramcheck =>	
		ramcheck_go    <= '1'; 
		sel_addrb_mux <= "00";	
		
	when spacegetter =>	
		spacegetter_go    <= '1'; 
		sel_addrb_mux <= "01";
		
	when boardupdater =>	
		boardupdater_go    <= '1'; 
		sel_addrb_mux <= "11"; 
		
	when others =>	   -- includes start and waitkey states
		null;
	
	end case;
	end process;

end GamePlayer_SM;
