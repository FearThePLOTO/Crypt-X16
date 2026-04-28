library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity crypto_coprocessor_schematic_TB is
end entity crypto_coprocessor_schematic_TB;

architecture sim of crypto_coprocessor_schematic_TB is

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

clk_gen: process
begin
    clock <= '0'; wait for 10 ns;
    clock <= '1'; wait for 10 ns;
end process;

UUT: entity work.crypto_coprocessor_schematic
    port map (
        clock   => clock,
        reset   => reset,
        CTRL_IN => CTRL_IN,
        Ra_IN   => Ra_IN,
        Rb_IN   => Rb_IN,
        Rd_IN   => Rd_IN
    );

stimulus: process
begin

    reset <= '1';
    wait until rising_edge(clock);
    wait until rising_edge(clock);
    wait for 1 ns;
    reset <= '0';

    CTRL_IN <= "0000"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0010";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0001"; Ra_IN <= "0001"; Rb_IN <= "0000"; Rd_IN <= "0011";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0010"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0100";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0011"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0101";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0100"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "0110";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0101"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "0111";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0110"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1000";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0111"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1001";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0110"; Ra_IN <= "1001"; Rb_IN <= "0000"; Rd_IN <= "1111";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "1000"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1001";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "1001"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1010";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "1010"; Ra_IN <= "0000"; Rb_IN <= "0001"; Rd_IN <= "1011";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "1011"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1100";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "1011"; Ra_IN <= "0001"; Rb_IN <= "0000"; Rd_IN <= "1101";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0110"; Ra_IN <= "0010"; Rb_IN <= "0000"; Rd_IN <= "1111";
    wait until rising_edge(clock);
    wait for 1 ns;

    reset <= '1';
    wait until rising_edge(clock);
    wait for 1 ns;
    reset <= '0';

    CTRL_IN <= "0110"; Ra_IN <= "0010"; Rb_IN <= "0000"; Rd_IN <= "1111";
    wait until rising_edge(clock);
    wait for 1 ns;

    CTRL_IN <= "0110"; Ra_IN <= "0000"; Rb_IN <= "0000"; Rd_IN <= "1111";
    wait until rising_edge(clock);
    wait for 1 ns;

    REPORT "All crypto_coprocessor tests completed." SEVERITY NOTE;
    WAIT;

end process;

end architecture sim;
