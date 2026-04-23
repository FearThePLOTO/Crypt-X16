library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_TB is
end register_file_TB;

architecture Behavioral of register_file_TB is

    -- Component Declaration for the Unit Under Test (UUT)
    component register_file
    Port ( 
        clock : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        RdWEn : in  STD_LOGIC;
        RES   : in  STD_LOGIC_VECTOR (15 downto 0);
        Ra    : in  STD_LOGIC_VECTOR (3 downto 0);
        Rb    : in  STD_LOGIC_VECTOR (3 downto 0);
        Rd    : in  STD_LOGIC_VECTOR (3 downto 0);
        SRCa  : out STD_LOGIC_VECTOR (15 downto 0);
        SRCb  : out STD_LOGIC_VECTOR (15 downto 0)
    );
    end component;

    -- Testbench Signals
    signal clock : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal RdWEn : STD_LOGIC := '0';
    signal RES   : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Ra    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal Rb    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal Rd    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal SRCa  : STD_LOGIC_VECTOR (15 downto 0);
    signal SRCb  : STD_LOGIC_VECTOR (15 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

    -- Array to hold the pre-loaded values for the test
    type init_array is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    constant test_data : init_array := (
        x"0001", x"C505", x"3C07", x"4D05",
        x"1186", x"F407", x"1086", x"4706",
        x"6808", x"BAA0", x"C902", x"100B",
        x"C000", x"C902", x"100B", x"B000"
    );

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: register_file PORT MAP (
        clock => clock,
        reset => reset,
        RdWEn => RdWEn,
        RES => RES,
        Ra => Ra,
        Rb => Rb,
        Rd => Rd,
        SRCa => SRCa,
        SRCb => SRCb
    );

    -- Clock generation process
    clk_process :process
    begin
        clock <= '0';
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process (Applying Test Vectors)
    stim_proc: process
    begin
        -- 1. Apply Reset initially
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        
        -- 2. Load all 16 registers with data (Simulating CPU setup)
        RdWEn <= '1';
        for i in 0 to 15 loop
            Rd <= std_logic_vector(to_unsigned(i, 4));
            RES <= test_data(i);
            wait for clk_period;
        end loop;
        
        -- 3. Read Test: Read R4 and R5 
        RdWEn <= '0'; 
        Ra <= "0100"; -- Should output x"1186" on SRCa
        Rb <= "0101"; -- Should output x"F407" on SRCb
        wait for clk_period*2;

        -- 4. Write Disable Test: Try to overwrite R12 but with RdWEn = '0'
        Rd <= "1100";
        RES <= x"FFFF";
        wait for clk_period*2;
        
        -- 5. Full Reset Test: Verify everything goes to 0
        reset <= '1';
        wait for clk_period*2;

        wait; -- Stop simulation
    end process;

end Behavioral;