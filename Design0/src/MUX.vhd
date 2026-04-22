library ieee;
use ieee.std_logic_1164.all;

entity MUX is 
	port(
	LUTOUT,ALUOUT,shifter_out: in std_logic_vector(15 downto 0);
	MUX_SEL: in std_logic_vector(1 downto 0);
	RESULT: out std_logic_vector(15 downto 0)
	);
end entity;

architecture rtl of MUX is 
begin
	
	RESULT <= ALUOUT when MUX_SEL = "01" else
			  shifter_out when MUX_SEL = "10" else
			  LUTOUT when MUX_SEL = "11" else
			  x"0000";	  
			
end architecture;
			  
			  