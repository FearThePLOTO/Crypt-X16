library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( 
	clock : in  STD_LOGIC; 						  -- System clock (drives all sequential logic)
	reset : in  STD_LOGIC;                        -- Active-high synchronous reset     
	RdWEn : in  STD_LOGIC;                        -- Write Enable (1 = allow write)    
	RES   : in  STD_LOGIC_VECTOR (15 downto 0);   -- Data input (result from ALU/MUX)   
	Ra    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Read address A    
	Rb    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Read address B    
	Rd    : in  STD_LOGIC_VECTOR (3 downto 0);    -- Write address (destination register)    
	SRCa  : out STD_LOGIC_VECTOR (15 downto 0);   -- Output from register Ra    
	SRCb  : out STD_LOGIC_VECTOR (15 downto 0)    -- Output from register Rb
    );
end entity;

architecture rtl of register_file is

	-- Internal Register Storage
	-- Array of 16 registers,each 16-bit wide
    type reg_array is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal registers : reg_array;

	begin
		-- Sequential Logic (Write + Reset)
		-- Controlled by rising edge of the clock
		process(clock)
    	begin
			-- Reset Operation   
			-- Clears ALL registers to zero   
			-- Does NOT directly modify outputs
			-- Outputs become zero automatically via read logic
			if rising_edge(clock) then
				if reset = '1' then
					registers <= (others => (others => '0'));
					SRCa      <= (others => '0');
                	SRCb      <= (others => '0');
				-- Write Operation
				-- Occurs ONLY if Write Enable is active
				-- Writes RES value into register Rd      
				-- Example: Rd = "0011" -> write into register 3
				elsif RdWEn = '1' then
					registers(to_integer(unsigned(Rd))) <= RES;
				end if;
			end if;
	 end process;

	 -- Combinational Read Logic
	 -- Outputs are directly connected to the register array
	 -- No clock required -> zero latency
	 -- Any change in Ra or Rb immediately updates SRCa/SRCb 
	 -- Example: Ra = "0101" -> SRCa = registers(5)
     SRCa <= registers(to_integer(unsigned(Ra)));
	 SRCb <= registers(to_integer(unsigned(Rb)));

end architecture;