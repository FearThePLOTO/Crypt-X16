SetActiveLib -work
comp -include "C:\Users\There\OneDrive\Documents\GitHub\Crypt-X16\Design1/src/register.vhd" 
comp -include "$DSN\src\TestBench\register_file_TB.vhd" 
asim TESTBENCH_FOR_register_file 
wave 
wave -noreg clock
wave -noreg reset
wave -noreg CTRL
wave -noreg Ra
wave -noreg Rb
wave -noreg Rd
wave -noreg Result
wave -noreg ABUS
wave -noreg BBUS
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\register_file_TB_tim_cfg.vhd" 
# asim TIMING_FOR_register_file 
