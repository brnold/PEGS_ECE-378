library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.STD_LOGIC_unsigned.all;

entity PEGS is
	port(
		addr : in STD_LOGIC_VECTOR(5 downto 0);
		M : out STD_LOGIC_VECTOR(7 downto 0)
		);
end PEGS;


architecture PEGS of PEGS is	 
	type rom_array is array (natural range <>) of std_logic_Vector (0 to 7);
	constant rom: rom_array := (  
	"11111111", --Square
	"10000001",
	"10000001",
	"10000001",
	"10000001",
	"10000001",
	"10000001",
	"11111111",
	
	"10000000", -- triangle
	"11000000",
	"10100000",
	"10010000",
	"10001000",
	"10000100",
	"10000010",
	"11111111",	
	
	"00111100", -- Circle
	"01000010",
	"10000001",
	"10000001",
	"10000001",
	"10000001",
	"01000010",
	"00111100",
	
	"00011000", --Cross
	"00011000",
	"00011000",
	"11111111",
	"11111111",
	"00011000",
	"00011000",
	"00011000",
	
	"00000000", --blank
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	
	"11111111", --Solid
	"11000011",
	"10100101",
	"10011001",
	"10011001",
	"10100101",
	"11000011",
	"11111111",
	
	"11111111", --hole
	"11111111",
	"11111111",
	"11111111",
	"11111111",
	"11111111",
	"11111111",
	"11111111",
	
	"00111100", --Cursor
	"00011000",
	"10111101",
	"11111111",
	"11111111",
	"10111101",
	"00011000",
	"00111100"
	);
	
begin  
	
	process (addr)
		variable j: integer;
	begin
		j:= conv_integer(addr);
		M <= rom(j);
	end process;
	
end PEGS;
