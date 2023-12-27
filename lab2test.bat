@echo off
color E
iverilog -g2012 -o lab2test.vvp tb_sumsub.sv
vvp lab2test.vvp
gtkwave Lab2_tb.vcd
pause