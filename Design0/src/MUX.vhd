library ieee;
use ieee.std_logic_1164.all;

entity MUX is 
	port(
	ALU_OUT,SHIFT_OUT,LUT_OUT: in std_logic_vector(15 downto 0);
	SEL: in std_logic_vector(1 downto 0);
	MUX_OUT: out std_logic_vector(15 downto 0)
	);
end entity;

architecture rtl of MUX is 
begin
	
	MUX_OUT <= ALU_OUT when SEL = "01" else
			  SHIFT_OUT when SEL = "10" else
			  LUT_OUT when SEL = "11" else
			  x"0000";	  
			
end architecture;
			  
			  