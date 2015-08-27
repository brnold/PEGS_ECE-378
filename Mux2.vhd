-------------------------------------------------------------------------------
-- Title       : Mux2
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Mux2 is
	generic (N: integer := 3);
	port(
		 sltLine : in STD_LOGIC;
		 inRAM : in STD_LOGIC_VECTOR(N-1 downto 0);
		 output : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end Mux2;

architecture Mux2 of Mux2 is
begin

	MuxSelect: process (sltLine, inRAM)
	constant brick: std_logic_vector(2 downto 0):= "101"; 
	begin
		if sltLine = '0' then
			output <= inRAM;
		else
			output <= brick;
		end if;
		
	end process;
	
end Mux2;
