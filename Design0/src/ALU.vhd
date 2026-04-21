library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ALU module
-- operations: ADD SUB AND OR XOR NOT MOV NOP

entity ALU is
    port (
        ABUS    : in  std_logic_vector(15 downto 0);
        BBUS    : in  std_logic_vector(15 downto 0);
        ALUctrl : in  std_logic_vector(2 downto 0);
        ALUOUT  : out std_logic_vector(15 downto 0)
    );
end entity ALU;

architecture rtl of ALU is
begin

   with ALUctrl select 
     ALUOUT <= std_logic_vector(signed(ABUS) + signed(BBUS)) when "001",
               std_logic_vector(signed(ABUS) - signed(BBUS)) when "010",
               ABUS AND BBUS                                 when "011",
               ABUS OR BBUS                                  when "100",
               ABUS XOR BBUS                                 when "101",
               NOT ABUS                                      when "110",
               ABUS                                          when "111",
               (others => '0')                               when others;


end architecture rtl;
