library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( 
	clock : in  STD_LOGIC; 						  -- System clock (drives all sequential logic)
	reset : in  STD_LOGIC;                        -- Active-high synchronous reset     
	RdWEn : in  STD_LOGIC;                        -- Write Enable (1 = allow write)    
	RES   : in  STD_LOGIC_VECTOR (15 downto 0);   -- Data input (result from ALU/MUX)   
	Ra    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Read address A    
	Rb    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Read address B    
	Rd    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Write address (destination register)    
	SRCa  : out STD_LOGIC_VECTOR (15 downto 0);   -- Output from register Ra    
	SRCb  : out STD_LOGIC_VECTOR (15 downto 0)    -- Output from register Rb
    );
end entity;

architecture rtl of register_file is

    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    
    -- Constant for the initial/reset state
    constant INITIAL_STATE : reg_array := (
        0 => x"0001", 1 => x"C505", 2 => x"3C07", 3 => x"4D05",
        4 => x"1186", 5 => x"F407", 6 => x"1086", 7 => x"4706",
        8 => x"6808", 9 => x"BAA0", 10 => x"C902", 11 => x"100B",
        12 => x"C000", 13 => x"C902", 14 => x"100B", 15 => x"B000"
    );

begin
    process(clock)
    variable var_registers : reg_array := INITIAL_STATE;
    begin
        if rising_edge(clock) then
            if reset = '1' then
                var_registers := INITIAL_STATE;
            elsif RdWEn = '1' then
                var_registers(to_integer(unsigned(Rd))) := RES;
            end if;
            SRCa <= var_registers(to_integer(unsigned(Ra)));
            SRCb <= var_registers(to_integer(unsigned(Rb)));
        end if;

    end process;


end architecture;
