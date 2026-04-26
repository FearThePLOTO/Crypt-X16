library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Cryptographic Coprocessor (Top Level) -- matches Figure 1 architecture
-- Ra, Rb, Rd feed the register file directly (concurrent read, no clock needed).
-- Only CTRL passes through the input_register pipeline latch.
--
-- Pipeline (one cycle latency on CTRL only):
--   Cycle N  rising edge : input_register latches CTRL_IN ? CTRL_reg
--   After  N (combinat.) : register_file reads Ra/Rb directly ? ABUS/BBUS
--                          CLU uses CTRL_reg + ABUS/BBUS ? RESULT
--   Cycle N+1 rising edge: register_file writes RESULT to Rd (if RdWEn='1')
--
-- NOTE: Rd must be held stable across both edges for correct write-back.
--       In back-to-back instructions the stimulus should not change Rd_IN
--       until after the write-back edge.

entity crypto_coprocessor is
    port (
        clock   : in  std_logic;
        reset   : in  std_logic;
        CTRL_IN : in  std_logic_vector(3 downto 0);
        Ra_IN   : in  std_logic_vector(3 downto 0);
        Rb_IN   : in  std_logic_vector(3 downto 0);
        Rd_IN   : in  std_logic_vector(3 downto 0);
        -- Observation ports (for testbench / debug)
        A_OUT   : out std_logic_vector(15 downto 0);  -- SRCa (value at Ra)
        B_OUT   : out std_logic_vector(15 downto 0);  -- SRCb (value at Rb)
        RESULT  : out std_logic_vector(15 downto 0)   -- CLU output / write-back data
    );
end entity crypto_coprocessor;

architecture rtl of crypto_coprocessor is

    -- Registered control signal (from input_register)
    signal CTRL_reg   : std_logic_vector(3 downto 0);
    signal RdWEn      : std_logic;
	signal Rd_reg : std_logic_vector(3 downto 0);

    -- Data buses between register_file and CLU
    signal SRCa       : std_logic_vector(15 downto 0);
    signal SRCb       : std_logic_vector(15 downto 0);
    signal CLU_RESULT : std_logic_vector(15 downto 0);

begin

    -- 1. Input Register: pipeline latch for CTRL + NOP/reset gating
    --    Ra, Rb, Rd bypass this and go directly to the register file
    IR_inst : entity work.input_register
        port map (
            clock    => clock,
            reset    => reset,
            CTRL_IN  => CTRL_IN,
			Rd_IN    => Rd_IN,
            CTRL_OUT => CTRL_reg,
			Rd_OUT   => Rd_reg,
            RdWEn    => RdWEn
        );

    -- 2. Register File: 16x16, synchronous write, asynchronous read
    --    Ra/Rb/Rd are wired directly from top-level ports (diagram Figure 1)
    RF_inst : entity work.register_file
        port map (
            clock => clock,
            reset => reset,
            RdWEn => RdWEn,
            RES   => CLU_RESULT,
            Ra    => Ra_IN,
            Rb    => Rb_IN,
            Rd    => Rd_reg,
            SRCa  => SRCa,
            SRCb  => SRCb
        );
		
    -- 3. Combinational Logic Unit: ALU + Shifter + LUT + MUX
    CLU_inst : entity work.CLU
        port map (
            A_BUS  => SRCa,
            B_BUS  => SRCb,
            CTRL   => CTRL_reg,
            RESULT => CLU_RESULT
        );

    -- Drive observation outputs
    A_OUT  <= SRCa;
    B_OUT  <= SRCb;
    RESULT <= CLU_RESULT;

end architecture rtl;