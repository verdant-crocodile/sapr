@echo off
color E
iverilog -g2012 -o testbench.vvp testbench.sv
vvp testbench.vvp
gtkwave Lab1_tb.vcd
pause