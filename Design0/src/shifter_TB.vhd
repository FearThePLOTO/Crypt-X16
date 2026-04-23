library ieee;
use ieee.std_logic_1164.all;		-- std logic library

entity shifter_tb is
end shifter_tb;

architecture test of shifter_tb is

--defining the signals
signal SHIFTINPUT : std_logic_vector(15 downto 0);
signal SHIFT_Ctrl : std_logic_vector(3 downto 0);
signal SHIFTOUT   : std_logic_vector(15 downto 0);

begin
		 
	 UUT : entity work.shifter(rtl)
				 --importing the shifter entity
port map(
    SHIFTINPUT => SHIFTINPUT,
    SHIFT_Ctrl => SHIFT_Ctrl,
    SHIFTOUT   => SHIFTOUT
);

process
begin

    SHIFTINPUT <= x"1234";						 --random inputs for testing 
    
    SHIFT_Ctrl <= "1000";							 
    wait for 20 ns;

    SHIFT_Ctrl <= "1001";
    wait for 20 ns;

    SHIFT_Ctrl <= "1010";
    wait for 20 ns;

    wait;

end process;

end test;