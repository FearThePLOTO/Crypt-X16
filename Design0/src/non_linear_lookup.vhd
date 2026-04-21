library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--16-bit Nonlinear Lookup(Integrated Version)
entity non_linear_lookup is
    port (  
        LUTIN  : in  std_logic_vector(15 downto 0); --full 16-bit input
        LUTOUT : out std_logic_vector(15 downto 0)  --full 16-bit output
    );
end entity;

architecture rtl of non_linear_lookup is

    -- Split signals
    signal upper_byte : std_logic_vector(7 downto 0); -- unchanged part
    signal lower_byte : std_logic_vector(7 downto 0); -- part to process

    signal MSN_in, LSN_in   : std_logic_vector(3 downto 0);
    signal MSN_out, LSN_out : std_logic_vector(3 downto 0);

    signal lut_out : std_logic_vector(7 downto 0); --the output of s-boxes

	begin
	    -- Step 1: Split input into upper and lower bytes
	    upper_byte <= LUTIN(15 downto 8); -- pass-through
	    lower_byte <= LUTIN(7 downto 0);  -- will go through LUT

	    -- Step 2: Split lower byte into two nibbles
	    MSN_in <= lower_byte(7 downto 4); -- upper nibble
	    LSN_in <= lower_byte(3 downto 0); -- lower nibble

	    -- Step 3: S-Box1 (for MSN)
		--This is a lookup table implemented using a case statement
		--Case statement is used because S-Box is a lookup table,and case directly represents mapping between input and output values(hardware efficiency)	
	    process(MSN_in)
	    begin
	        case MSN_in is
	            when "0000" => MSN_out <= "0001";
	            when "0001" => MSN_out <= "1011";
	            when "0010" => MSN_out <= "1001";
	            when "0011" => MSN_out <= "1100";
	            when "0100" => MSN_out <= "1101";
	            when "0101" => MSN_out <= "0110";
	            when "0110" => MSN_out <= "1111";
	            when "0111" => MSN_out <= "0011";
	            when "1000" => MSN_out <= "1110";
	            when "1001" => MSN_out <= "1000";
	            when "1010" => MSN_out <= "0111";
	            when "1011" => MSN_out <= "0100";
	            when "1100" => MSN_out <= "1010";
	            when "1101" => MSN_out <= "0010";
	            when "1110" => MSN_out <= "0101";
	            when "1111" => MSN_out <= "0000";
	            when others => MSN_out <= "0000";  --safity default
	        end case;
	    end process;
		
	    -- Step 4: S-Box2 (for LSN)
	    process(LSN_in)
	    begin
	        case LSN_in is
	            when "0000" => LSN_out <= "1111";
	            when "0001" => LSN_out <= "0000";
	            when "0010" => LSN_out <= "1101";
	            when "0011" => LSN_out <= "0111";
	            when "0100" => LSN_out <= "1011";
	            when "0101" => LSN_out <= "1110";
	            when "0110" => LSN_out <= "0101";
	            when "0111" => LSN_out <= "1010";
	            when "1000" => LSN_out <= "1001";
	            when "1001" => LSN_out <= "0010";
	            when "1010" => LSN_out <= "1100";
	            when "1011" => LSN_out <= "0001";
	            when "1100" => LSN_out <= "0011";
	            when "1101" => LSN_out <= "0100";
	            when "1110" => LSN_out <= "1000";
	            when "1111" => LSN_out <= "0110";
	            when others => LSN_out <= "0000"; --safity default 
	        end case;
	    end process;
		
	    -- Step 5: Combine S-Box outputs
	    lut_out <= MSN_out & LSN_out;
		
	    -- Step 6: Concatenate with upper byte to form final 16-bit output
	    LUTOUT <= upper_byte & lut_out;

end architecture;