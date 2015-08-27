

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Overall_SM is
	port(	
		
		clr : in STD_LOGIC;
		clk : in STD_LOGIC;
		
		death : in STD_LOGIC;
		gamewon : in STD_LOGIC;
		boardloader_done : in STD_LOGIC;  
		ld : out std_logic_vector(7 downto 0);
		keyflag : in std_logic_vector(2 downto 0);
		
		gameplayer_go : out STD_LOGIC;
		sel_mux : out STD_LOGIC;
		boardloader_go : out STD_LOGIC;
		gameplayer_clr : out STD_LOGIC;
		--boardloader_clr : out STD_LOGIC;
		counter_clr : out STD_LOGIC;
		increment : out STD_LOGIC
		);
end Overall_SM;



architecture Overall_SM of Overall_SM is
	
	type state_type is (start, boardloader, gameplayer, gpc, inc_count);
	
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
	
	
	
	C1: process(present_state, death, gamewon, keyflag, boardloader_done)
		
	begin		   
		
		case (present_state) is  
			
			when start =>	
				
				next_state <= boardloader;
			
			when boardloader =>
				if boardloader_done = '1' then
					next_state <= gpc;
				else
					next_state <= boardloader;
				end if;	
			
			when gpc =>	
				
				next_state <= gameplayer;
				
			
			when gameplayer =>
				
				if death = '1' then
					next_state <= boardloader;
				elsif gamewon = '1' then
					next_state <= inc_count;  
				elsif keyflag = "101" then
					 next_state <= boardloader;
				else
					next_state <= gameplayer;
				end if;
			
			when inc_count =>
				next_state <= boardloader; 
				
				
			
			when others =>
				next_state <= start; 
				
				
			
	end case; end process;
	
	C2: process (present_state)
	begin	  
		gameplayer_go <= '0';
		sel_mux <= '0';
		boardloader_go <= '0';
		gameplayer_clr <= '0';
		counter_clr <= '0';
		increment <= '0';	
		ld <= "11111111";
		case (present_state) is
			
			when start =>  
				counter_clr <= '1';	
				ld <= "00000001";
			when boardloader =>
				sel_mux <='1';
				boardloader_go <= '1';
				ld <= "00000011";
			when gpc =>  
				gameplayer_clr <= '1';
				ld <= "00000111";
			when gameplayer =>
				gameplayer_go <= '1'; 
				ld <= "00011111";
			when inc_count =>
				increment <='1';
				ld <= "00111111";
			when others => null;
		end case; 
	end process;
	
	
	
	
end Overall_SM;
