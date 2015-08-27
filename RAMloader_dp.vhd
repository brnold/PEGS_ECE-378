library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity RAMloader_dp is
	port( 
		clk : in std_logic;
		clr : in std_logic;	
		load : in std_logic;
		Rloaded : out std_logic;
		RAMout : out STD_LOGIC_vector(2 downto 0);
		ROMin : in STD_LOGIC_vector(2 downto 0);
		baordNum : in STD_LOGIC_VECTOR(3 downto 0);	  --I'm sorry Austin
		RAMaddr : out STD_LOGIC_VECTOR(6 downto 0);
		ROMaddr : out STD_LOGIC_VECTOR(10 downto 0) --lvl rom
		
		);
end RAMloader_dp; 

architecture RAMloader_dp of RAMloader_dp is
signal count : std_logic_vector(6 downto 0);	
signal bin : std_logic;
begin
	
	process(clk, clr)
	begin
		if clr = '1' then
			count <= (others => '0');
		elsif clk'event and clk = '1' and load = '1' and bin = '1' then
			count <= count + 1;
		end if;
	end process;
	
	process(clk, clr)
	begin
		if clr = '1' then
			bin <= '0';
		elsif clk'event and clk = '1' then
			bin <= not(bin);
		end if;	
	end process;
	
	
	RAMaddr <= count;  --set RAM addr
	ROMaddr <= count + ('0' & baordNum & "000000") + ("00" & baordNum & "00000"); --set ROM addr boardNum*96
	
	process(count)
	begin
	if(count = 95) then
		Rloaded <= '1';
	else
		Rloaded <= '0';
	end if;
	end process; 
	
	RAMout <= ROMin; 
	
end RAMloader_dp;