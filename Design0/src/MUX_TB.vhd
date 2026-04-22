library ieee;
use ieee.std_logic_1164.all;

entity MUX_TB is
end entity;

architecture muxArch of MUX_TB is

signal LUTOUT: std_logic_vector(15 downto 0) := x"1111";
signal ALUOUT: std_logic_vector(15 downto 0) := x"2222";
signal shifter_out: std_logic_vector(15 downto 0) := x"3333";
signal MUX_SEL: std_logic_vector(1 downto 0);
signal RESULT: std_logic_vector(15 downto 0);

begin
	
	UUT: entity work.mux
		port map(
			LUTOUT => LUTOUT,
			ALUOUT => ALUOUT,
			shifter_out => shifter_out,
			MUX_SEL => MUX_SEL,
			RESULT => RESULT
		);
		
simulation_process: process
					begin
						
						MUX_SEL <= "00"; --impossible case
						wait for 50 ns;	
						
						MUX_SEL <= "01"; --ALU output
						wait for 50 ns;
					
						MUX_SEL <= "10"; --shifter output
						wait for 50 ns;
					
						MUX_SEL <= "11"; --LUT output
						wait for 50 ns;
					
					wait;
					
					end process;
					
end architecture;
					