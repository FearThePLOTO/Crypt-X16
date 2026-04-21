LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY ALU_TB IS
END ENTITY;

architecture rtl of ALU_TB is
 signal ABUS, BBUS, ALUOUT: std_logic_vector(15 downto 0);
 signal ALUctrl : std_logic_vector (3 downto 0);
begin
    UUT: entity work.ALU
        port map (
            ABUS    => ABUS,
            BBUS    => BBUS,
            ALUctrl => ALUctrl,
            ALUOUT  => ALUOUT
        );
  -- Step 4: Stimulus Process
    stimulus: process
    begin
        -- Test 1: ADD Operation (0000)
        -- Let's add 5 + 3 (in Hex: 0x0005 + 0x0003)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "001";
        wait for 10 ns;
        -- Test 2: SUB Operation (0001)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "010";
        wait for 10 ns;

        -- Test 3 : AND Operation (0010)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "011";
        wait for 10 ns;

        --Test 4 : OR Operation (0011)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "100";
        wait for 10 ns;

        --Test 5 : XOR Operation (0100)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "101";
        wait for 10 ns;

        --Test 6 : NOT Operation (0101)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "110";
        wait for 10 ns;

        --Test 7 : MOV (0110)
        ABUS    <= x"0505";
        BBUS    <= x"0503";
        ALUctrl <= "111";
        wait for 10 ns;

        wait;
    end process;
  
end architecture rtl;
