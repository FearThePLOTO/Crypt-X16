library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Testbench has no ports(empty entity)
entity non_linear_lookup_TB is
end entity;

architecture sim of non_linear_lookup_TB is

    -- Signals to connect to DUT
    signal ABUS   : std_logic_vector(15 downto 0);
    signal RESULT : std_logic_vector(15 downto 0);

	begin
	
	    --Instantiate DUT
	    uut:entity non_linear_lookup
	        port map (LUTIN => ABUS,LUTOUT => RESULT);
	
	    --Stimulus process
	    stim_proc: process
	    begin
	        --Test Case 1
	        ABUS <= x"ABCD";
	        wait for 10 ns;
	        --Test Case 2
	        ABUS <= x"1234";
	        wait for 10 ns;
	        --Test Case 3
	        ABUS <= x"FFFF";
	        wait for 10 ns;
	        --Test Case 4
	        ABUS <= x"0000";
	        wait for 10 ns;
	        --Test Case 5
	        ABUS <= x"5A3C";
	        wait for 10 ns;
	        --End simulation
	        wait;
	    end process;

end architecture;