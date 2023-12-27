`include "sumsub.sv"    

module tb_sumsub;

logic pclk;
logic [1:0] paddr;
	//00 - OPERATION ADDRES
	//01 - FIRST OPERAND ADDRES
	//10 - SECOND OPERAND ADDRES
	//11 - RESULT ADDRES
logic preset;
logic psel;
logic penable;
logic pwrite;
logic pready;
logic [31:0] pwdata;
logic [31:0] prdata;

sumsub dut
(
.pclk(pclk),
.paddr(paddr),
.preset(preset),
.psel(psel),
.penable(penable),
.pwrite(pwrite),
.pwdata(pwdata),
.pready(pready),
.prdata(prdata)
);

always 
begin
  #5 pclk = ~pclk;
end

initial
begin
	pclk <= 0;
	preset <= 0;
	penable <= 0;
	psel <= 0;
	pwrite <= 0;
	pwdata <= 0;

	#5
	preset <= 1;

	//OPERATION
	//--------------------------------------------------------------------------------
	#9
	psel <= 1;
	/*OPERATION ADRESS*/paddr <= 0;
	pwrite <= 1;
	/*OPERATION CODE */pwdata <= 1'b0;
	//--------------------------------------------------------------------------------

	#10
	penable <= 1;

	#11
	penable <= 0;
	psel <= 0;

	//FIRST OPERAND A
	//--------------------------------------------------------------------------------
	#9
	psel <= 1;
	/*FIRST OPERAND ADDRES*/paddr <= 2'b01;
	/*VALUE OF OPERAND */pwdata <= 32'b0000_0000_0000_0000_0000_0000_0000_1010;//A
	//--------------------------------------------------------------------------------

	#10
	penable <= 1;

	#11
	penable <= 0;
	psel <= 0;

	//SECOND OPERAND B
	//--------------------------------------------------------------------------------
	#9
	psel <= 1;
	/*SECOND OPERAND ADDRES*/paddr <= 2'b10;
	/*VALUE OF OPERAND*/pwdata <= 32'b0000_0000_0000_0000_0000_0000_0000_0101;//B
	//--------------------------------------------------------------------------------

	#10
	penable <= 1;

	#11
	penable <= 0;
	psel <= 0;

	pwrite<=0;
	/*END OF WRITING*/

	/*START OF READING*/
	#9
	psel <= 1;
	paddr <= 2'b11;

	#10
	penable <= 1;

	#11
	penable <= 0;
	psel <= 0;
	#30
	$stop;
end

// создание файла .vcd и вывести значения переменных волны для отображения в 
// визуализаторе волн
initial begin
$dumpfile("Lab2_tb.vcd");  // создание файла для сохранения результатов симуляции
$dumpvars(0, tb_sumsub);       // установка переменных для сохранения в файле
$dumpvars;
end

endmodule

