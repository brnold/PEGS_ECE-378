library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity mux4g is
	generic (N:integer);
	port (
		a: in STD_LOGIC_VECTOR(N-1 downto 0);
		b: in STD_LOGIC_VECTOR(N-1 downto 0); 
		c: in STD_LOGIC_VECTOR(N-1 downto 0);
		d: in STD_LOGIC_VECTOR(N-1 downto 0);
		s: in STD_LOGIC_VECTOR (1 downto 0);
		y: out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end mux4g;

architecture mux4g of mux4g is
begin
	process(a, b, c, d, s)
	begin
		if s = "00" then
			y <= a;	
		elsif s = "01" then
			y <= b; 
		elsif s = "10" then
			y <= c;
		else
			y <= d;
		end if;
	end process;
end mux4g;
