library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- Coprocessor Testbench
-- Clock: 20 ns period.
-- Run for 400 ns
--
-- Initial register state (from register_file constant):
--   R0=0x0001  R1=0xC505  R2=0x3C07  R3=0x4D05
--   R4=0x1186  R5=0xF407  R6=0x1086  R7=0x4706
--   R8=0x6808  R9=0xBAA0  R10=0xC902 R11=0x100B
--   R12=0xC000 R13=0xC902 R14=0x100B R15=0xB000
-- ============================================================

entity crypto_coprocessor_TB is
end entity crypto_coprocessor_TB;

architecture sim of crypto_coprocessor_TB is

    signal clock   : std_logic := '0';
    signal reset   : std_logic := '0';
    signal CTRL_IN : std_logic_vector(3 downto 0) := "0111";
    signal Ra_IN   : std_logic_vector(3 downto 0) := (others => '0');
    signal Rb_IN   : std_logic_vector(3 downto 0) := (others => '0');
    signal Rd_IN   : std_logic_vector(3 downto 0) := (others => '0');
    signal A_OUT   : std_logic_vector(15 downto 0);
    signal B_OUT   : std_logic_vector(15 downto 0);
    signal RESULT  : std_logic_vector(15 downto 0);

begin

    -- 20 ns clock
    clk_gen: process
    begin
        clock <= '0'; wait for 10 ns;
        clock <= '1'; wait for 10 ns;
    end process;

    UUT: entity work.crypto_coprocessor
        port map (
            clock   => clock,
            reset   => reset,
            CTRL_IN => CTRL_IN,
            Ra_IN   => Ra_IN,
            Rb_IN   => Rb_IN,
            Rd_IN   => Rd_IN,
            A_OUT   => A_OUT,
            B_OUT   => B_OUT,
            RESULT  => RESULT
        );

    stimulus: process
    begin

        -- ============================================================
        -- RESET (2 cycles to guarantee clean state)
        -- ============================================================
        reset <= '1';
        wait until rising_edge(clock); -- cycle 1: IR resets to NOP, RF resets
        wait until rising_edge(clock); -- cycle 2: combinational path settled
        wait for 1 ns;
        reset <= '0';

        -- ============================================================
        -- Test 1: ADD  R0 + R1 ? R2
        -- ABUS=0x0001, BBUS=0xC505 => 0x0001+0xC505 = 0xC506
        -- ============================================================
        CTRL_IN <= "0000"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0010";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"C506"
            REPORT "ADD R0+R1: expected 0xC506" SEVERITY ERROR;
        ASSERT A_OUT = x"0001"
            REPORT "ADD A_OUT: expected R0=0x0001" SEVERITY ERROR;
        ASSERT B_OUT = x"C505"
            REPORT "ADD B_OUT: expected R1=0xC505" SEVERITY ERROR;

        -- ============================================================
        -- Test 2: SUB  R1 - R0 ? R3
        -- 0xC505 - 0x0001 = 0xC504
        -- ============================================================
        CTRL_IN <= "0001"; Ra_IN <= "0001"; Rb_IN <= "0000"; Rd_IN <= "0011";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"C504"
            REPORT "SUB R1-R0: expected 0xC504" SEVERITY ERROR;

        -- ============================================================
        -- Test 3: AND  R0 AND R1 ? R4
        -- 0x0001 AND 0xC505 = 0x0001
        -- ============================================================
        CTRL_IN <= "0010"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0100";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"0001"
            REPORT "AND R0,R1: expected 0x0001" SEVERITY ERROR;

        -- ============================================================
        -- Test 4: OR   R0 OR R1 ? R5
        -- 0x0001 OR 0xC505 = 0xC505
        -- ============================================================
        CTRL_IN <= "0011"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0101";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"C505"
            REPORT "OR R0,R1: expected 0xC505" SEVERITY ERROR;

        -- ============================================================
        -- Test 5: XOR  R0 XOR R1 ? R6
        -- 0x0001 XOR 0xC505 = 0xC504
        -- ============================================================
        CTRL_IN <= "0100"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0110";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"C504"
            REPORT "XOR R0,R1: expected 0xC504" SEVERITY ERROR;

        -- ============================================================
        -- Test 6: NOT  R0 ? R7
        -- NOT 0x0001 = 0xFFFE
        -- ============================================================
        CTRL_IN <= "0101"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "0111";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"FFFE"
            REPORT "NOT R0: expected 0xFFFE" SEVERITY ERROR;

        -- ============================================================
        -- Test 7: MOV  R0 ? R8
        -- pass ABUS through: 0x0001
        -- ============================================================
        CTRL_IN <= "0110"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1000";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"0001"
            REPORT "MOV R0: expected 0x0001" SEVERITY ERROR;

        -- ============================================================
        -- Test 8: NOP  (CTRL=0111) targeted at R9 -- must NOT write
        -- MUX_SEL=00 ? RESULT = 0x0000
        -- ============================================================
        CTRL_IN <= "0111"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1001";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"0000"
            REPORT "NOP: expected RESULT=0x0000" SEVERITY ERROR;

        -- Verify R9 was NOT overwritten: read R9 via MOV next cycle
        -- (R9 initial = 0xBAA0, NOP must not commit 0x0000)
        CTRL_IN <= "0110"; Ra_IN <= "1001"; Rb_IN <= "0000"; Rd_IN <= "1111";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT A_OUT = x"BAA0"
            REPORT "NOP verify R9: expected 0xBAA0 (NOP must not write)" SEVERITY ERROR;

        -- ============================================================
        -- Test 9: ROR8  rotate R1 right by 8 ? R9
        -- BBUS=R1=0xC505; rotate_right(0xC505,8) = 0x05C5
        -- ============================================================
        CTRL_IN <= "1000"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1001";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"05C5"
            REPORT "ROR8 R1: expected 0x05C5" SEVERITY ERROR;

        -- ============================================================
        -- Test 10: ROR4  rotate R1 right by 4 ? R10
        -- rotate_right(0xC505,4) = 0x5C50
        -- ============================================================
        CTRL_IN <= "1001"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1010";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"5C50"
            REPORT "ROR4 R1: expected 0x5C50" SEVERITY ERROR;

        -- ============================================================
        -- Test 11: SLL8  shift R1 left by 8 ? R11
        -- shift_left(0xC505,8) = 0x0500
        -- ============================================================
        CTRL_IN <= "1010"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1011";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"0500"
            REPORT "SLL8 R1: expected 0x0500" SEVERITY ERROR;

        -- ============================================================
        -- Test 12: LUT   S-Box lookup on R0 ? R12
        -- ABUS=R0=0x0001
        --   upper_byte=0x00 (pass-through)
        --   lower_byte=0x01 ? MSN=0000, LSN=0001
        --   S_Box1(0000)=0001, S_Box2(0001)=0000
        --   lut_out=0x10  ?  LUTOUT=0x0010
        -- ============================================================
        CTRL_IN <= "1011"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1100";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"0010"
            REPORT "LUT R0: expected 0x0010" SEVERITY ERROR;

        -- ============================================================
        -- Test 13: LUT on R1 ? R13
        -- ABUS=R1=0xC505
        --   upper_byte=0xC5 (pass-through)
        --   lower_byte=0x05 ? MSN=0000, LSN=0101
        --   S_Box1(0000)=0001, S_Box2(0101)=1110
        --   lut_out=0x1E  ?  LUTOUT=0xC51E
        -- ============================================================
        CTRL_IN <= "1011"; Ra_IN <= "0001"; Rb_IN <= "0000"; Rd_IN <= "1101";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT RESULT = x"C51E"
            REPORT "LUT R1: expected 0xC51E" SEVERITY ERROR;

        -- ============================================================
        -- Test 14: Write-back verification
        -- ADD wrote 0xC506 to R2 (Test 1). Read R2 via MOV.
        -- None of Tests 2-13 wrote to R2, so it must be 0xC506.
        -- ============================================================
        CTRL_IN <= "0110"; Ra_IN <= "0010"; Rb_IN <= "0000"; Rd_IN <= "1111";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT A_OUT = x"C506"
            REPORT "WRITEBACK R2: expected 0xC506 from Test1 ADD" SEVERITY ERROR;
        ASSERT RESULT = x"C506"
            REPORT "MOV R2 result: expected 0xC506" SEVERITY ERROR;

        -- ============================================================
        -- Test 15: Reset mid-execution clears registers to initial state
        -- ============================================================
        reset <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        -- R2 must be back to 0x3C07, R0 back to 0x0001
        CTRL_IN <= "0110"; Ra_IN <= "0010"; Rb_IN <= "0000"; Rd_IN <= "1111";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT A_OUT = x"3C07"
            REPORT "POST-RESET R2: expected original 0x3C07" SEVERITY ERROR;

        CTRL_IN <= "0110"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1111";
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT A_OUT = x"0001"
            REPORT "POST-RESET R0: expected 0x0001" SEVERITY ERROR;

        REPORT "All crypto_coprocessor tests completed." SEVERITY NOTE;
        WAIT;

    end process;

end architecture sim;