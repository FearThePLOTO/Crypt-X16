library ieee;
use ieee.std_logic_1164.all;

entity MUX_TB is
end entity;

architecture muxArch of MUX_TB is

signal LUT_OUT: std_logic_vector(15 downto 0) := x"1111";
signal ALU_OUT: std_logic_vector(15 downto 0) := x"2222";
signal SHIFT_OUT: std_logic_vector(15 downto 0) := x"3333";
signal SEL: std_logic_vector(1 downto 0);
signal MUX_OUT: std_logic_vector(15 downto 0);

begin
	
	UUT: entity MUX
		port map(
			LUT_OUT => LUT_OUT,
			ALU_OUT => ALU_OUT,
			SHIFT_OUT => SHIFT_OUT,
			SEL => SEL,
			MUX_OUT => MUX_OUT
		);
		
simulation_process: process
					begin
						
						SEL <= "00"; --impossible case
						wait for 50 ns;	
						
						SEL <= "01"; --ALU output
						wait for 50 ns;
					
						SEL <= "10"; --shifter output
						wait for 50 ns;
					
						SEL <= "11"; --LUT output
						wait for 50 ns;
					
					wait;
					
					end process;
					
end architecture;
					