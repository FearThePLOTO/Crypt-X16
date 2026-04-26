library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_register_TB is
end entity input_register_TB;

architecture sim of input_register_TB is

    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';
    signal CTRL_IN  : std_logic_vector(3 downto 0) := "0111";
    signal Rd_IN    : std_logic_vector(3 downto 0) := "0000";
    signal CTRL_OUT : std_logic_vector(3 downto 0);
    signal Rd_OUT   : std_logic_vector(3 downto 0);          
    signal RdWEn    : std_logic;

begin

    clk_gen: process
    begin
        clock <= '0'; wait for 10 ns;
        clock <= '1'; wait for 10 ns;
    end process;

    UUT: entity work.input_register
        port map (
            clock    => clock,
            reset    => reset,
            CTRL_IN  => CTRL_IN,
            Rd_IN    => Rd_IN,   
            CTRL_OUT => CTRL_OUT,
            Rd_OUT   => Rd_OUT,  
            RdWEn    => RdWEn
        );

    stimulus: process
    begin

        -- ----------------------------------------------------------------
        -- Test 1: Power-on state
        -- ----------------------------------------------------------------
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT CTRL_OUT = "0111" REPORT "POWER-ON CTRL: expected NOP" SEVERITY ERROR;
        ASSERT RdWEn = '0'        REPORT "POWER-ON RdWEn: expected 0" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 2: Reset forces NOP and clears Rd_OUT
        -- ----------------------------------------------------------------
        CTRL_IN <= "0000"; -- ADD
        Rd_IN   <= "1010"; -- Target R10
        reset   <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        ASSERT CTRL_OUT = "0111" REPORT "RESET CTRL: expected NOP" SEVERITY ERROR;
        ASSERT Rd_OUT = "0000"   REPORT "RESET Rd_OUT: expected 0000" SEVERITY ERROR;
        ASSERT RdWEn = '0'       REPORT "RESET RdWEn: expected 0" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 3: Normal latch -- ADD and Rd target pass through
        -- ----------------------------------------------------------------
        CTRL_IN <= "0000"; -- ADD
        Rd_IN   <= "0010"; -- R2
        wait until rising_edge(clock);
        wait for 1 ns;

        ASSERT CTRL_OUT = "0000" REPORT "LATCH CTRL: expected ADD" SEVERITY ERROR;
        ASSERT Rd_OUT = "0010"   REPORT "LATCH Rd_OUT: expected R2" SEVERITY ERROR;
        ASSERT RdWEn = '1'       REPORT "LATCH RdWEn: expected 1" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 4: NOP disables write-enable but still latches the Rd
        -- ----------------------------------------------------------------
        CTRL_IN <= "0111";
        Rd_IN   <= "1111"; -- R15
        wait until rising_edge(clock);
        wait for 1 ns;

        ASSERT CTRL_OUT = "0111" REPORT "NOP CTRL: expected 0111" SEVERITY ERROR;
        ASSERT Rd_OUT = "1111"   REPORT "NOP Rd_OUT: expected R15" SEVERITY ERROR;
        ASSERT RdWEn = '0'       REPORT "NOP RdWEn: expected 0" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 5: Pipeline Check -- Verify Rd_OUT lags behind Rd_IN
        -- ----------------------------------------------------------------
        Rd_IN <= "0101"; -- R5
        -- Don't wait for clock yet... check that Rd_OUT is still "1111" from Test 4
        ASSERT Rd_OUT = "1111" REPORT "PIPELINE: Rd_OUT changed too early!" SEVERITY ERROR;
        
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT Rd_OUT = "0101" REPORT "PIPELINE: Rd_OUT failed to update on clock" SEVERITY ERROR;

        REPORT "All input_register (Pipelined) tests completed." SEVERITY NOTE;
        WAIT;

    end process;

end architecture sim;