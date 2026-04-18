library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_register_file is
end tb_register_file;

architecture Behavioral of tb_register_file is

    -- Component Declaration
    component register_file
        port ( 
            clock  : in  std_logic;
            reset  : in  std_logic;
            CTRL   : in  std_logic_vector(3 downto 0);
            Ra     : in  std_logic_vector(3 downto 0);
            Rb     : in  std_logic_vector(3 downto 0);
            Rd     : in  std_logic_vector(3 downto 0);
            Result : in  std_logic_vector(15 downto 0);
            ABUS   : out std_logic_vector(15 downto 0);
            BBUS   : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Internal Signals
    signal clock  : std_logic := '0';
    signal reset  : std_logic := '0';
    signal CTRL   : std_logic_vector(3 downto 0) := (others => '0');
    signal Ra     : std_logic_vector(3 downto 0) := (others => '0');
    signal Rb     : std_logic_vector(3 downto 0) := (others => '0');
    signal Rd     : std_logic_vector(3 downto 0) := (others => '0');
    signal Result : std_logic_vector(15 downto 0) := (others => '0');
    signal ABUS   : std_logic_vector(15 downto 0);
    signal BBUS   : std_logic_vector(15 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Unit Under Test (UUT)
    uut: register_file 
        port map (
            clock  => clock,
            reset  => reset,
            CTRL   => CTRL,
            Ra     => Ra,
            Rb     => Rb,
            Rd     => Rd,
            Result => Result,
            ABUS   => ABUS,
            BBUS   => BBUS
        );

    -- Clock Generation
    clk_process : process
    begin
        clock <= '0';
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
    end process;

    -- Test Scenarios
    stim_proc: process
    begin
        -- Step 1: System Reset
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        wait for clk_period;

        -- Step 2: Read Initial/Pre-loaded Values (R0, R1)
        Ra <= "0000"; 
        Rb <= "0001"; 
        wait for clk_period;

        -- Step 3: Write Operation (0xAAAA to R2)
        CTRL   <= "0000"; -- Write Enabled
        Rd     <= "0010";
        Result <= x"AAAA";
        wait for clk_period;
        
        -- Verify R2 Write
        Ra <= "0010";
        wait for clk_period;

        -- Step 4: NOP Condition (Write Disable Test for R3)
        CTRL   <= "0111"; -- NOP
        Rd     <= "0011";
        Result <= x"BBBB";
        wait for clk_period;

        -- Verify R3 remained unchanged
        Ra <= "0011";
        wait for clk_period;

        wait;
    end process;

end Behavioral;