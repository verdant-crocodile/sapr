@echo off
color E
iverilog -o test.vvp apb_master.v apb_slave.v testbench.v
vvp test.vvp
pause