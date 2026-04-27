library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLU_schematic_TB is
end CLU_schematic_TB;

architecture sim of CLU_schematic_TB is

signal ABUS  : std_logic_vector(15 downto 0);
signal BBUS  : std_logic_vector(15 downto 0);
signal CTRL   : std_logic_vector(3 downto 0);
signal RESULT : std_logic_vector(15 downto 0);

begin 
        
    UUT: entity work.CLU_schematic
        port map(
            ABUS  => ABUS,
            BBUS  => BBUS,
            CTRL   => CTRL,
            RESULT => RESULT
        );
    
    process
    begin
        -- Initial Data
        ABUS <= x"0005";
        BBUS <= x"0003";

        -- Test 1: ALU ADD (0000) -> 5 + 3 = 8
        CTRL <= "0000"; wait for 10 ns; 
        assert RESULT = x"0008" report "CLU Integration: ALU ADD Failed" severity error;

        -- Test 2: ALU SUB (0001) -> 5 - 3 = 2
        CTRL <= "0001"; wait for 10 ns;
        assert RESULT = x"0002" report "CLU Integration: ALU SUB Failed" severity error;

        -- Change data for Shift Test
        BBUS <= x"1234";

        -- Test 3: SHIFT ROR8 (1000) -> 3412
        CTRL <= "1000"; wait for 10 ns;
        assert RESULT = x"3412" report "CLU Integration: Shifter ROR8 Failed" severity error;

        -- Change data for LUT Test
        ABUS <= x"ABCD";

        -- Test 4: LUT (1011) -> ABA4 (Verified from previous S-Box test)
        CTRL <= "1011"; wait for 10 ns;
        assert RESULT = x"ABA4" report "CLU Integration: LUT Failed" severity error;

        -- Test 5: NOP (1111) -> Should output 0x0000
        CTRL <= "1111"; wait for 10 ns;
        assert RESULT = x"0000" report "CLU Integration: NOP MUX Failed" severity error;

        report "All CLU Integration tests completed successfully." severity note;
        wait;
    end process;
end architecture;