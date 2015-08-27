
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMloader_sm is
	port(
		clk : in std_logic;
		clr : in std_logic;
		go : in STD_LOGIC;
		Rloaded : in std_logic;	--from data path 
		load : out std_logic;
		wea : out std_logic;  --To data path
		done : out std_logic  --signal that the ram is loaded
		);
end RAMloader_sm;



architecture RAMloader_sm of RAMloader_sm is
	type state_type is (start, S1, stateW,stateW2, sf); 

	signal present_state, next_state : state_type;
begin
	
	sreg: process(clk, clr)
	begin
		if clr = '1' then
			present_state <= start;
		elsif(clk'event and clk = '1' )then
			present_state <= next_state;
		end if;				   
	end process;
	
	C1: process(present_state, go, Rloaded) 
	begin
		case present_state is
			when start =>
			if go = '1' then
				next_state <= stateW;
			else 
				next_state <= start;
			end if;
			
			when stateW =>
			next_state <= statew2;
			
			when statew2 =>
			next_state <= s1;
			
			when S1 =>
			if Rloaded = '1' then
				next_state <= sf;
			else 
				next_state <= s1;
			end if;	 			
			
			when sf =>
			   next_state <= start;
			
			
		end case;
		
		
	end process;
	
	C2 : process(present_state)
	begin
		wea <= '0';
		load <='0';
		done <= '0'; 
		if present_state = statew then
			wea <= '1';	
		elsif present_state = statew2 then
			wea <= '1';
		elsif present_state = S1 then
			wea <= '1';
			load <='1';
		elsif present_state = sf then
			done <= '1';
		end if;
	end process;
	
	
	
end RAMloader_sm;
