library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity plusplus_block is
	port(
		--plusplus_flag : in STD_LOGIC;	
		go : in STD_LOGIC;
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		keyflag : in STD_LOGIC_VECTOR(2 downto 0);
		keychange : in std_logic;
		done_flag : out STD_LOGIC;	
		WEB : out STD_LOGIC_vector (0 downto 0);
		plusplus_out : out STD_LOGIC_VECTOR(2 downto 0)	-- ram data out
		
		);
end plusplus_block;


architecture plusplus_block of plusplus_block is
	
	type state_type is (start, finish, writecross, writecircle, writesquare, writetriangle,
	checkkey_cross, checkkey_triangle, checkkey_circle, checkkey_square);
	
	signal present_state, next_state: state_type;
	
	constant U: std_logic_vector(2 downto 0):= "000"; --up arrow
	constant D: std_logic_vector(2 downto 0):= "001"; --down arrow
	constant L: std_logic_vector(2 downto 0):= "010"; --left arrow
	constant R: std_logic_vector(2 downto 0):= "011"; -- right arrow
	constant enter: std_logic_vector(2 downto 0):= "100"; --enter key  
	
	
begin
	
	sreg:process(clk, clr)
	begin
		if clr = '1' then
			present_state <= start;
		elsif clk'event and clk = '1' then
			present_state <= next_state;
		end if;
	end process;
	
	C1: process(present_state, keyflag, go, keychange)
		
	begin		   
		
		case (present_state) is  
			
			when start =>	
				if go = '1' then
					next_state <= writecross;
				else
					next_state <= start;
				end if;
			
			when writecross =>								
				next_state <= checkkey_cross;
			
			when checkkey_cross =>					--remains on cross in this state
				
				if (keychange = '1') then
					
					case keyflag is
						when enter =>
							
							next_state <= finish;
						
						when U =>
							
							next_state <= writecircle;
						
						when D =>
							
							next_state <= writesquare;
						
						when others =>
							
							next_state <= checkkey_cross;
						
					end case; 
				else
					next_state <= checkkey_cross;
				end if;
			
			when writesquare =>					
				
				next_state <= checkkey_square;
				
			
			when checkkey_square =>					--remains on square in this state
				
				if (keychange = '1') then
					
					case keyflag is
						when enter =>
							
							next_state <= finish;
						
						when U =>
							
							next_state <= writeCross;
						
						when D =>
							
							next_state <= writetriangle;
						
						when others =>
							
							next_state <= checkkey_square;
						
					end case;
				else
					next_state <= checkkey_square;
				end if;
			
			when writetriangle =>					
				
				next_state <= checkkey_triangle;
				
			
			when checkkey_triangle =>					--remains on triangle in this state
				
				if (keychange = '1') then
					case keyflag is
						
						when enter =>
							
							next_state <= finish;
						
						when U =>
							
							next_state <= writesquare;
						
						when D =>
							
							next_state <= writecircle;
						
						when others =>
							
							next_state <= checkkey_triangle;
						
					end case; 
					
				else
					next_state <= checkkey_triangle;
				end if;
			
			when writecircle =>					
				
				next_state <= checkkey_circle;
				
			
			when checkkey_circle =>					--remains on circle in this state
				
				if (keychange = '1') then
					case keyflag is
						
						when enter =>
							
							next_state <= finish;
						
						when U =>
							
							next_state <= writetriangle;
						
						when D =>
							
							next_state <= writecross;
						
						when others =>
							
							next_state <= checkkey_circle;
						
					end case;
				else
					next_state <= checkkey_circle;
				end if;
			
			when finish =>
				
				next_state <= start;
			
			when others =>
				next_state <= start;
				
			
		end case;
	end process;
	
	
	
	
	
	C2: process(present_state) 
		
	begin
		
		WEB <= "0";
		plusplus_out <= "011";
		done_flag <= '0';
		
		
		
		case (present_state) is
			
			when writecross =>					
				
				WEB <= "1";					--write enable pulled high
				plusplus_out <= "011";		--outputs cross
			
			when checkkey_cross =>					
				plusplus_out <= "011";
			
			when writesquare =>					
				
				WEB <= "1";					--write enable pulled high
				plusplus_out <= "000";		--outputs square
			
			when checkkey_square =>					
				plusplus_out <= "000";
			
			when writetriangle =>					
				
				WEB <= "1";					--write enable pulled high
				plusplus_out <= "001";		--outputs triangle
			
			when checkkey_triangle =>					
				plusplus_out <= "001";
			
			when writecircle =>					
				
				WEB <= "1";					--write enable pulled high
				plusplus_out <= "010";		--outputs circle
			
			when checkkey_circle =>					
				plusplus_out <= "010"; 	  
			
			when finish =>
				done_flag <= '1';
			
			when others =>
				null;
				
				
			
		end case;
	end process;
	
	
	
	
	
	
	
end plusplus_block;
