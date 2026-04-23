library IEEE;
use IEEE.STD_LOGIC_1164.ALL;		  --std library
use ieee.numeric_std.all;					  --to use signed and unsigned data types

entity shifter is
    generic (
        N : integer := 16
    );
    port (
	    SHIFTINPUT : in  std_logic_vector(N-1 downto 0);	
	    --one of the outputs of ctrl logic block 
        SHIFT_Ctrl : in  std_logic_vector(3 downto 0);					   	   -- it decides which ops will be implemented to the SHIFTINPUT
        SHIFTOUT   : out std_logic_vector(N-1 downto 0)	    		   	   -- the value of SHIFTINPUT after encryption
    );
end entity shifter;

architecture rtl of shifter is
begin

    process(SHIFTINPUT, SHIFT_Ctrl)
    begin

        case SHIFT_Ctrl is

            when "1000" =>																  
                SHIFTOUT <= std_logic_vector(							  --- Rotate input right by 8 bits
                    rotate_right(unsigned(SHIFTINPUT), 8));

            when "1001" =>
                SHIFTOUT <= std_logic_vector(						   	  ---  Rotate input right by 4 bits
                    rotate_right(unsigned(SHIFTINPUT), 4));

            when "1010" =>
                SHIFTOUT <= std_logic_vector(							  --- Shift input left by 8 bits 
                    shift_left(unsigned(SHIFTINPUT), 8));

            when others =>
                SHIFTOUT <= (others => '0');									 --- invalid SHIFT_Ctrl ----> clear output 

        end case;

    end process;

end architecture rtl;