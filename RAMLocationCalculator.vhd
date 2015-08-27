
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;  


entity RAMLocationCalculator is
	port(
		CursorLoc  : in STD_LOGIC_VECTOR(6 downto 0);	--ram location of curese
		keyflag : in std_logic_vector(2 downto 0);	   --direction of movement
		slt_mux_PEG1, slt_mux_PEG2 : out std_logic;	   --controll for Muxes
		PEG_1 : out STD_LOGIC_VECTOR(6 downto 0);	  --addresses
		PEG_2 : out STD_LOGIC_VECTOR(6 downto 0)	  --addresses
		);
end RAMLocationCalculator;

--}} End of automatically maintained section

architecture RAMLocationCalculator of RAMLocationCalculator is
	signal rowNumber : std_logic_vector(2 downto 0);
	--signal intMod, edgeMod : integer;	
	signal edgeMod : std_logic_vector(3 downto 0);
	signal CursorLoc8 : std_logic_vector(7 downto 0);
begin
	
	--rowNumber <= CursorLoc(6 downto 3); --divide by 8, (basically find the row)
	
	--	intMod <= to_integer(unsigned(CursorLoc));	  --needed for Mod function
	--	--edgeMod <= intMod mod 12;	--Mod of location with 12 to determine proximity to the edge 
	--	
	--	process(intMod)
	--	begin
	--	if(intMod = 0 or intMod = 12 or intMod = 24 or intMod = 36 or intMod = 48 or intMod = 60 or intMod = 72	or intMod = 84) then
	--		edgeMod <= 0;
	--	elsif(intMod = 1 or intMod = 13 or intMod = 25 or intMod = 37 or intMod = 49 or intMod = 61 or intMod = 73	or intMod = 85) then
	--		edgeMod <= 1;
	--	elsif(intMod = 10 or intMod = 22 or intMod = 34 or intMod = 46 or intMod = 58 or intMod = 70 or intMod = 82	or intMod = 94) then
	--		edgeMod <= 10;
	--	elsif(intMod = 11 or intMod = 23 or intMod = 35 or intMod = 47 or intMod = 59 or intMod = 71 or intMod = 83	or intMod = 95) then
	--		edgeMod <= 11;
	--	else
	--		edgeMod <= 3;
	--	end if;
	--	end process;
	--
	--
	
	process(CursorLoc8, rowNumber)
	begin
		if(CursorLoc8 >=0 and CursorLoc8 <12) then
			rowNumber <= "000";
		elsif(CursorLoc8>11 and CursorLoc8 <23) then
			rowNumber <= "001";
		elsif(CursorLoc8 >72 and CursorLoc8 <84) then
			rowNumber <= "110";
		elsif(CursorLoc8>83 and CursorLoc8 <95) then
			rowNumber <= "111";
		else
			rowNumber <= "011";
			end if;
	end process;
	
	
	CursorLoc8 <= '0' & CursorLoc;
	
	process(CursorLoc8, edgeMod)
	begin
		if(CursorLoc8 = x"00" or CursorLoc8 = x"0C" or CursorLoc8 = x"18" or CursorLoc8 = x"24" or CursorLoc8 = x"30" or CursorLoc8 = x"3C" or CursorLoc8 = x"48"	or CursorLoc8 = x"54") then
			edgeMod <= "0000";
		elsif(CursorLoc8 = x"01" or CursorLoc8 = x"0D" or CursorLoc8 = x"19" or CursorLoc8 = x"25" or CursorLoc8 = x"31" or CursorLoc8 = x"3D" or CursorLoc8 = x"49"	or CursorLoc8 = x"55") then
			edgeMod <= "0001";
		elsif(CursorLoc8 = x"0A" or CursorLoc8 = x"16" or CursorLoc8 = x"22" or CursorLoc8 = x"2E" or CursorLoc8 = x"3A" or CursorLoc8 = x"46" or CursorLoc8 = x"52" or CursorLoc8 = x"5E") then
			edgeMod <= "1010";
		elsif(CursorLoc8 = x"0B" or CursorLoc8 = x"17" or CursorLoc8 = x"23" or CursorLoc8 = x"2F" or CursorLoc8 = x"3B" or CursorLoc8 = x"47" or CursorLoc8 = x"53"	or CursorLoc8 = x"5F") then
			edgeMod <= "1011";
		else
			edgeMod <= "0011";
		end if;
	end process;
	
	
	process(keyflag, rowNumber, edgeMod, CursorLoc)
	begin
		PEG_1 <= "1100000"; --96
		PEG_2 <= "1100000";
		slt_mux_PEG1 <= '0';
		slt_mux_PEG2 <= '0';
		case keyflag is	 
			
			when "000" =>	--up
				
				if rowNumber="000" then	 
					slt_mux_PEG1 <= '1'; --select line to the PEGSCombinations block to give a solid block
					slt_mux_PEG2 <= '1'; --select line to the PEGSCombinations block to give a solid block
				elsif rowNumber="001" then
					PEG_1 <= CursorLoc -12; --up one row
					slt_mux_PEG2 <= '1'; --select line to the PEGSCombinations block to give a solid block
				else
					PEG_1 <= CursorLoc -12; --up one row
					PEG_2 <= CursorLoc -24; --up two rows
				end if;	 
			
			when "001" => --down
				
				if rowNumber="111" then
					slt_mux_PEG1 <= '1'; --select line to the PEGSCombinations block to give a solid block
					slt_mux_PEG2 <= '1';
				elsif rowNumber="110" then
					PEG_1 <= CursorLoc + 12; --down one row
					slt_mux_PEG2 <= '1'; --select line to the PEGSCombinations block to give a solid block
				else
					PEG_1 <= CursorLoc +12; --down one row
					PEG_2 <= CursorLoc +24; --down two rows
				end if;
			
			when "010" => --left
				
				if edgeMod = "0000" then
					slt_mux_PEG1 <= '1'; --select line to the PEGSCombinations block to give a solid block
					slt_mux_PEG2 <= '1';
				elsif edgeMod = "0001" then
					PEG_1 <= CursorLoc -1; --down one row
					slt_mux_PEG2 <= '1'; --select line to the PEGSCombinations block to give a solid block
				else
					PEG_1 <= CursorLoc -1; --down one row
					PEG_2 <= CursorLoc -2; --down two rows
				end if;
				
			
			when "011" => --right
				
				if edgeMod = "1011" then
					slt_mux_PEG1 <= '1'; --select line to the PEGSCombinations block to give a solid block
					slt_mux_PEG2 <= '1';
				elsif edgeMod = "1010" then
					PEG_1 <= CursorLoc +1; --right one column
					slt_mux_PEG2 <= '1'; --select line to the PEGSCombinations block to give a solid block
				else
					PEG_1 <= CursorLoc +1; --right one column
					PEG_2 <= CursorLoc +2; --right one column
				end if;
			
			when others => --if it's not the above
				--what we gonna do Frederic?
			-- PEG_1 <= "0";
		end case;
	end process;
	
end RAMLocationCalculator;
