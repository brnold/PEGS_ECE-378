													  										 -- Example 51: N-bit counter
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;
entity counter is
	 generic(N : integer := 8);
	 port(
		 clr : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 q : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end counter;

architecture counter of counter is
signal count: STD_LOGIC_VECTOR(N-1 downto 0);
begin
	process(clk, clr)
	begin
		if clr = '1' then
			count <= (others => '0');
		elsif clk'event and clk = '1' then
			count <= count + 1;
		end if;							 
	end process;
	
	q <= count;				
end counter;