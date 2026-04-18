library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( 
        clock  : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        CTRL   : in  STD_LOGIC_VECTOR (3 downto 0);
        Ra     : in  STD_LOGIC_VECTOR (3 downto 0);
        Rb     : in  STD_LOGIC_VECTOR (3 downto 0);
        Rd     : in  STD_LOGIC_VECTOR (3 downto 0);
        Result : in  STD_LOGIC_VECTOR (15 downto 0);
        ABUS   : out STD_LOGIC_VECTOR (15 downto 0);
        BBUS   : out STD_LOGIC_VECTOR (15 downto 0)
    );
end register_file;

architecture Behavioral of register_file is

    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    
    signal registers : reg_array := (
        0  => x"0001",  1  => x"C505",  2  => x"3C07",  3  => x"4D05",
        4  => x"1186",  5  => x"F407",  6  => x"1086",  7  => x"4706",
        8  => x"6808",  9  => x"BAA0",  10 => x"C902",  11 => x"100B",
        12 => x"C000",  13 => x"C902",  14 => x"100B",  15 => x"B000"
    );

begin

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                ABUS <= (others => '0');
                BBUS <= (others => '0');
            else
                ABUS <= registers(to_integer(unsigned(Ra)));
                BBUS <= registers(to_integer(unsigned(Rb)));
                
                -- Skip write operation if CTRL is NOP ("0111")
                if CTRL /= "0111" then
                    registers(to_integer(unsigned(Rd))) <= Result;
                end if;
            end if;
        end if;
    end process;

end Behavioral;