-------------------------------------------------------------------------------
--
-- Title       : PEGCombs
-- Design      : FinalProject
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PEGCombs is
	 port(
		 PEG_1 : in STD_LOGIC_VECTOR(2 downto 0);
		 PEG_2 : in STD_LOGIC_VECTOR(2 downto 0);		
		 OutPEG : out STD_LOGIC_VECTOR(2 downto 0);
		 -- Represents combination block; if this passes, it will be the value of the combined PEGS
		 --	Of course, the other space is the cursor, so there is no flag to indicate this event. 
	     DEATH: out STD_LOGIC;
		 PLUS_COMBO: out STD_LOGIC;
		 MOVEMENT: out STD_LOGIC	
		 -- If low, NO movement.
		 );
end PEGCombs;

architecture PEGCombs of PEGCombs is
constant square: std_logic_vector(2 downto 0):= "000";
constant triangle: std_logic_vector(2 downto 0):= "001";
constant circle: std_logic_vector(2 downto 0):= "010";
constant plus: std_logic_vector(2 downto 0):= "011";
constant blank: std_logic_vector(2 downto 0):= "100";
constant brick: std_logic_vector(2 downto 0):= "101"; 
constant hole: std_logic_vector(2 downto 0):= "110";
constant cursor: std_logic_vector(2 downto 0):= "111";
begin
	process(PEG_1,PEG_2)
	begin
	--beign by starting with the first peg cases		
		-- HOLE
	if (PEG_1 = hole) then
		-- DEATH
		OutPeg <= hole;
		DEATH <= '1';
		PLUS_COMBO <= '0';
		MOVEMENT <= '0';
	-- BLANK
	elsif (PEG_1 = blank) then
		-- General Movement
		OutPeg <= PEG_2;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';
	elsif (PEG_1 = brick) then
		-- No Movement
		OutPeg <= PEG_2;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '0'; 
	
	--now for the combitorial stuff	
		
 	--first General case, movable peg1 and blank peg2
	elsif (PEG_1(2) = '0' and PEG_2 = blank) then
		-- Square and square = blank
		OutPeg <= PEG_1;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';
	--second General case, movable peg1, brick peg2
	elsif (PEG_1(2) = '0' and PEG_2 = brick) then
		-- Square and square = blank
		OutPeg <= brick;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '0';
		
	--elsif (PEG_1(2) = '0' and PEG_2 = hole) then
--		-- Square and square = blank
--		OutPeg <= hole;
--		DEATH <= '0';
--		PLUS_COMBO <= '0';
--		MOVEMENT <= '1';	
		
	-- SQUARE		
	elsif (PEG_1 = square and PEG_2 = square) then
		-- Square and square = blank
		OutPeg <= blank;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';
	elsif (PEG_1 = square and PEG_2 = hole) then
		-- Square and square = blank
		OutPeg <= blank;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';	
	-- TRIANGLE
	elsif (PEG_1 = triangle and PEG_2 = triangle) then
		-- Triangle and triangle = brick
		OutPeg <= brick;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';
   elsif (PEG_1 = triangle and PEG_2 = hole) then
		-- Square and square = blank
		OutPeg <= hole;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';	
	-- CIRCLE
	elsif (PEG_1 = circle and PEG_2 = circle) then
		-- Circle and cirle = blank
		OutPeg <= blank;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';
   elsif (PEG_1 = circle and PEG_2 = hole) then
		-- Square and square = blank
		OutPeg <= hole;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';	
	-- PLUS
	elsif (PEG_1 = plus and PEG_2 = plus) then			 -- SPECIAL CASE
		-- Plus and plus = flag: PLUS_COMBO (Select PEG)
		OutPeg <= PEG_2;
		DEATH <= '0';
		PLUS_COMBO <= '1';
		MOVEMENT <= '1';
	elsif (PEG_1 = plus and PEG_2 = hole) then
		-- Square and square = blank
		OutPeg <= hole;
		DEATH <= '0';
		PLUS_COMBO <= '0';
		MOVEMENT <= '1';	
	
	else
		-- Else, you shall DIE!!!!! DX
		OutPeg <= PEG_2;
		DEATH <= '1';
		PLUS_COMBO <= '0';
		MOVEMENT <= '0';
	end if;
end process; 

end PEGCombs;
