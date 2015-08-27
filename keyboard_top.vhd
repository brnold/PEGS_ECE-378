																	   library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity keyboard_top is
	port(
		mclk : in STD_LOGIC;
		PS2C : in STD_LOGIC;
		PS2D : in STD_LOGIC;   
		clr : in std_logic;
	    newData : out std_logic; --goes high for a clock cyclye when there is a key depress
		keyflag : out STD_LOGIC_VECTOR(2 downto 0)
		);
end keyboard_top;

architecture keyboard_top of keyboard_top is	  
	
	component clkdiv
		port(
			mclk : in STD_LOGIC;
			clr : in STD_LOGIC;
			clk190 : out STD_LOGIC;
			clk25 : out STD_LOGIC);
	end component;	   
	
	
	component keyboard_ctrl
		port(
			clk25 : in STD_LOGIC;
			clr : in STD_LOGIC;
			PS2C : in STD_LOGIC;
			PS2D : in STD_LOGIC;
			keyval1 : out STD_LOGIC_VECTOR(7 downto 0);
			keyval2 : out STD_LOGIC_VECTOR(7 downto 0);
			keyval3 : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	 	-- Component declaration of the "keyboard_flags(keyboard_flags)" unit defined in
	-- file: "./../src/keyboard_flags.vhd"
	component keyboard_flags
	port(
		cclk : in STD_LOGIC;
		clr : in STD_LOGIC;
		keyval2 : in STD_LOGIC_VECTOR(7 downto 0);
		keyflag : out STD_LOGIC_VECTOR(2 downto 0);
		newData : out STD_LOGIC);
	end component;
	for all: keyboard_flags use entity work.keyboard_flags(keyboard_flags);


	signal  clk25s : std_logic;
	
	signal keyval2s : STD_LOGIC_VECTOR(7 downto 0);
	
begin

	
	ctrl : entity keyboard_ctrl
	port map(
		clk25 => clk25s,
		clr => clr,
		PS2C => PS2C,
		PS2D => PS2D,
		keyval1 => open,	 -- keyval1 and keyval3 are not used anywhere
		keyval2 => keyval2s,
		keyval3 => open
		);	   
	
	clockdivider : entity clkdiv
	port map(
		mclk => mclk,
		clr => clr,
		clk25 => clk25s
		);	 
		
	keyboardFlagTHingy : keyboard_flags
	port map(
		cclk => clk25s,
		clr => clr,
		keyval2 => keyval2s,
		keyflag => keyflag,
		newData => newData
	);
		
		
	
end keyboard_top;
