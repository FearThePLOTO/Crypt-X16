library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( 
        clock : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        RdWEn : in  STD_LOGIC;
        RES   : in  STD_LOGIC_VECTOR (15 downto 0);
        Ra    : in  STD_LOGIC_VECTOR (3 downto 0);
        Rb    : in  STD_LOGIC_VECTOR (3 downto 0);
        Rd    : in  STD_LOGIC_VECTOR (3 downto 0);
        SRCa  : out STD_LOGIC_VECTOR (15 downto 0);
        SRCb  : out STD_LOGIC_VECTOR (15 downto 0)
    );
end register_file;

architecture Behavioral of register_file is

    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal registers : reg_array;

begin

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                registers <= (others => (others => '0'));
                SRCa      <= (others => '0');
                SRCb      <= (others => '0');
            else
                SRCa <= registers(to_integer(unsigned(Ra)));
                SRCb <= registers(to_integer(unsigned(Rb)));
                
                if RdWEn = '1' then
                    registers(to_integer(unsigned(Rd))) <= RES;
                end if;
            end if;
        end if;
    end process;

end Behavioral;