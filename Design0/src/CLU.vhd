library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Combinational Logic Unit	(CLU)
-- connects ALU + Shifter + LUT + MUX

entity CLU is
    port (
	A_BUS  : in  std_logic_vector(15 downto 0); -- First operand
	B_BUS  : in  std_logic_vector(15 downto 0); -- Second operand
    CTRL   : in  std_logic_vector(3 downto 0);  -- Control signal (operation selector)
	RESULT : out std_logic_vector(15 downto 0)  -- Final output
    );
end entity;

architecture rtl of CLU is

	--conmponents declaration
    component ALU is
	    port (
	        ABUS    : in  std_logic_vector(15 downto 0);
	        BBUS    : in  std_logic_vector(15 downto 0);
	        ALUctrl : in  std_logic_vector(3 downto 0);
	        ALUOUT  : out std_logic_vector(15 downto 0)
	    );
    end component;

    component shifter is
        generic ( N : integer := 16 );
        port (
            SHIFTINPUT : in  std_logic_vector(N-1 downto 0);
            SHIFT_Ctrl : in  std_logic_vector(3 downto 0);
            SHIFTOUT   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component non_linear_lookup is
        port (
            LUTIN  : in  std_logic_vector(15 downto 0);
            LUTOUT : out std_logic_vector(15 downto 0)
        );
    end component;
	
	component MUX is  
		port (
			ALU_OUT   : in  std_logic_vector(15 downto 0);
			SHIFT_OUT : in  std_logic_vector(15 downto 0);
            LUT_OUT   : in  std_logic_vector(15 downto 0);
			SEL       : in  std_logic_vector(1 downto 0);
			MUX_OUT   : out std_logic_vector(15 downto 0)
		);
	end component;
	
	--internal signals
    signal alu_out: std_logic_vector(15 downto 0); -- ALU result
	signal shift_out: std_logic_vector(15 downto 0); -- Shifter result
	signal lut_out: std_logic_vector(15 downto 0);  -- LUT output (16-bit)
	signal mux_sel: std_logic_vector(1 downto 0); --multiplexer selector

	begin
		
		--Instanciate components
		ALU_inst: ALU
			port map (ABUS => A_BUS,BBUS => B_BUS,
					  ALUctrl => CTRL,      -- CTRL controls ALU operations
					  ALUOUT => alu_out);
		SHIFTER_inst: shifter
	        port map (SHIFTINPUT => B_BUS,  -- Shift operations applied on B_BUS
			          SHIFT_Ctrl => CTRL,   -- CTRL controls shift type
			          SHIFTOUT   => shift_out);
		LUT_inst: non_linear_lookup
			port map (LUTIN => A_BUS,LUTOUT => lut_out);
			
		-- Generate MUX select signal from CTRL
		process(CTRL)
		begin
			case CTRL is
				-- ALU operations
				when "0000" | "0001" | "0010" | "0011" |
				     "0100" | "0101" | "0110" | "0111" => mux_sel <= "01";
				-- Shifter
				when "1000" | "1001" | "1010" => mux_sel <= "10";
				-- LUT
				when "1011" => mux_sel <= "11";
				when others =>mux_sel <= "00";  -- "00" -> no operation / default
			end case;
		end process;
			
		--MUX Instance    
		MUX_inst: MUX
			port map (ALU_OUT => alu_out,SHIFT_OUT => shift_out,LUT_OUT => lut_out,
					  SEL => mux_sel,MUX_OUT => RESULT);

end architecture;