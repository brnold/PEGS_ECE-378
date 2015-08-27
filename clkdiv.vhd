
library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use IEEE.STD_LOGIC_unsigned.all;

entity clkdiv is
	 port(
		 mclk : in STD_LOGIC;
		 clr : in STD_LOGIC; 
		 clk25 : out STD_LOGIC
		

	     );
end clkdiv;

architecture clkdiv of clkdiv is	  
signal q: std_logic_vector (0 downto 0);
begin
   process (mclk, clr)
   begin
	   if clr = '1' then
   q <= "0";
elsif mclk'event and mclk = '1' then
	q <= q + 1;
end if;
end process;

clk25 <= q(0);


end clkdiv;
