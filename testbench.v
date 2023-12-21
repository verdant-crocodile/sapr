`timescale 1ns/1ps

module testbench;

reg clk = 0;
reg rst_n;
reg [31:0] inp_data;
reg [31:0] read_out;

apb_master master_dut (
  .clk(clk),
  .rst_n(rst_n),
  .PRDATA(),
  .PADDR(),
  .PWRITE(),
  .PENABLE(),
  .PREADY()
);

apb_slave slave_dut (
  .clk(clk),
  .rst_n(rst_n),
  .PADDR(master_dut.PADDR),
  .inp_data(master_dut.PRDATA),
  .PWRITE(master_dut.PWRITE),
  .PENABLE(master_dut.PENABLE),
  .PREADY(master_dut.PREADY),
  .PRDATA(master_dut.PRDATA)
);

initial begin
  clk = 0;
  forever #10 clk = ~clk;
end

initial begin
  rst_n = 0;
  forever #10 rst_n = ~rst_n;
end

initial begin
 #10
  inp_data = 6;
  master_dut.apb_write(32'h0, inp_data);
#10
read_out = master_dut.apb_read(32'h0);
#10

inp_data = "21.12.2023";
master_dut.apb_write(32'h4, inp_data);
#10
read_out = master_dut.apb_read(32'h4);
#10

  // Write operation at address 0x8 with data 0x44657262 (Derb in ASCII)
  inp_data = "0x44657262";
  master_dut.apb_write(32'h8, inp_data);
#10
read_out = master_dut.apb_read(32'h8);
#10

  // Write operation at address 0xC with data 0x5665726F (Vero in ASCII)
  inp_data = "0x5665726F";
  master_dut.apb_write(32'hC, inp_data);
#10
read_out = master_dut.apb_read(32'hC);
#10

$finish;
end

endmodule