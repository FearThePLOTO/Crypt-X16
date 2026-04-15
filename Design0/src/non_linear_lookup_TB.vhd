library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
	
--Testbench has no ports(empty entity)	
entity non_linear_lookup_TB is
end entity;

architecture tb of non_linear_lookup_TB is

    --Component declaration (DUT)
    component non_linear_lookup
        port (
            LUTIN  : in  std_logic_vector(7 downto 0);
            LUTOUT : out std_logic_vector(7 downto 0)
        );
    end component;

    --Signals to connect to DUT
    signal LUTIN_tb  : std_logic_vector(7 downto 0) := (others => '0');
    signal LUTOUT_tb : std_logic_vector(7 downto 0);

	begin
	    --Instantiate DUT
	    DUT: non_linear_lookup
	        port map (LUTIN => LUTIN_tb,LUTOUT => LUTOUT_tb);
			
	    --Stimulus process
	    stim_proc: process
	    begin
	        --Test 1
	        LUTIN_tb <= "00000000";
	        wait for 10 ns;
	        --Test 2
	        LUTIN_tb <= "00010001";
	        wait for 10 ns;
	        --Test 3
	        LUTIN_tb <= "10101010";
	        wait for 10 ns;
	        --Test 4
	        LUTIN_tb <= "11110000";
	        wait for 10 ns;
	        --Test 5
	        LUTIN_tb <= "11111111";
	        wait for 10 ns;
	        --Random test
	        LUTIN_tb <= "01011011";
	        wait for 10 ns;
	        --End simulation
	        wait;
	    end process;

end architecture;