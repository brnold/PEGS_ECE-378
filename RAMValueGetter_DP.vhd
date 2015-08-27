library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAMValueGetter_DP is
	port(	
	clk : in std_logic; 
	clr : in std_logic;
		 RAM_data : in STD_LOGIC_VECTOR(2 downto 0);
		 RAM_addr : out STD_LOGIC_VECTOR(6 downto 0);
		 loc1 : in STD_LOGIC_VECTOR(6 downto 0);
		 loc2 : in STD_LOGIC_VECTOR(6 downto 0);
		 value1 : out std_logic_vector(2 downto 0);
		 value2 : out std_logic_vector(2 downto 0);
		 mux : in std_logic;
		 val1reg, val2reg : in std_logic
	     );
end RAMValueGetter_DP;

--}} End of automatically maintained section

architecture RAMValueGetter_DP of RAMValueGetter_DP is 

	-- Component declaration of the "reg(reg)" unit defined in
	-- file: "./../src/reg.vhd"
	component reg
	generic(
		N : INTEGER := 8);
	port(
		load : in STD_LOGIC;
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		d : in STD_LOGIC_VECTOR(N-1 downto 0);
		q : out STD_LOGIC_VECTOR(N-1 downto 0));
	end component;
	for all: reg use entity work.reg(reg);

 
begin

	process(mux, loc2, loc1)
	begin
		if(mux = '1') then
			RAM_addr <= loc2;
		else
			RAM_addr <= loc1; 
		end if;
	end process;
	
	val1 : reg
	generic map(
		N => 3
	)
	port map(
		load => val1reg,
		clk => clk,
		clr => clr,
		d => RAM_data,
		q => value1
	);
	
	val2 : reg
	generic map(
		N => 3
	)
	port map(
		load => val2reg,
		clk => clk,
		clr => clr,
		d => RAM_data,
		q => value2
	);

end RAMValueGetter_DP;