SetActiveLib -work
comp -include "$DSN/src/register.vhd" 
comp -include "$DSN/src/TestBench/register_file_TB.vhd" 
asim tb_register_file 
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
run -all