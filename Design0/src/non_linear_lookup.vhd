library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Nonlinear Lookup Unit
--S_Box1 on upper nibble, S_Box2 on lower nibble

entity non_linear_lookup is
    port (
        LUTIN  : in  std_logic_vector(7 downto 0);  -- 8-bit input
        LUTOUT : out std_logic_vector(7 downto 0)   -- 8-bit output after substitution
    );
end entity;

architecture rtl of non_linear_lookup is

    --Internal signals for splitting and processing the input
	signal MSN_in  : std_logic_vector(3 downto 0); -- Most Significant Nibble (upper 4 bits)
	signal LSN_in  : std_logic_vector(3 downto 0); -- Least Significant Nibble (lower 4 bits)
	signal MSN_out : std_logic_vector(3 downto 0); -- Output of S-Box1  
	signal LSN_out : std_logic_vector(3 downto 0); -- Output of S-Box2
	
	begin
		-- Step 1: Split the 8-bit input into two 4-bit nibbles
		MSN_in <= LUTIN(7 downto 4); -- Upper 4 bits
		LSN_in <= LUTIN(3 downto 0); -- Lower 4 bits
	
		--Step 2: S-Box1(Non-linear substitution for MSN)
		--This is a lookup table implemented using a case statement
		--Case statement is used because S-Box is a lookup table,and case directly represents mapping between input and output values(hardware efficiency)			--Using if may introduce priority logic,while case ensures a balanced combinational implementation(if is sequential ,case is parallel)	
		SBOX_1: process(MSN_in) 
		begin
			case(MSN_in) is
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
				when others => MSN_out <= "0000"; --Safety default
			end case;
		end process;
			
		--Step 3: S-Box2(Non-linear substitution for LSN)
		SBOX_2: process(LSN_in) 
		begin
			case(LSN_in) is
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
				when others => LSN_out <= "0000"; --Safety default
			end case;
		end process;
		
		--Step 4: Combine the two 4-bit outputs into one 8-bit result
		LUTOUT <= MSN_out & LSN_out;

end architecture;