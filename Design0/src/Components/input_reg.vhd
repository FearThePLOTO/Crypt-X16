library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity input_register is
    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        CTRL_IN  : in  std_logic_vector(3 downto 0);
        Rd_IN    : in  std_logic_vector(3 downto 0); 
        CTRL_OUT : out std_logic_vector(3 downto 0);
        Rd_OUT   : out std_logic_vector(3 downto 0);
        RdWEn    : out std_logic
    );
end entity;

architecture rtl of input_register is
    signal RdWEn_reg : std_logic := '0';
begin
    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                CTRL_OUT  <= "0111"; -- NOP
                Rd_OUT    <= "0000";
                RdWEn_reg <= '0';
            else
                CTRL_OUT <= CTRL_IN;
                Rd_OUT   <= Rd_IN; -- Delay Rd to match CTRL
                
                -- RdWEn logic remains synchronous to prevent spikes
                if CTRL_IN = "0111" then
                    RdWEn_reg <= '0';
                else
                    RdWEn_reg <= '1';
                end if;
            end if;
        end if;
    end process;
    RdWEn <= RdWEn_reg;
end architecture;