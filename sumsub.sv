module sumsub
(
	input logic pclk,
	input logic[1:0] paddr,		/*00 - Operation, 01 - A, 10 - B*/
	input logic preset,
	input logic psel,
	input logic pwrite,
	input logic penable,
	input logic [31:0] pwdata,	/*0 - sum, 1-sub*/
	output logic [31:0] prdata,
	output logic pready
);


logic operation;
logic [31:0] A;
logic [31:0] B;
logic [1:0] state;

parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS = 2'b10;
	
function bit [31:0] OPERATION(input operation, input [31:0] A, input [31:0] B);
begin
	case(operation)
	1'b0: begin 
		OPERATION[31:0]=A[31:0]+B[31:0]; 
		$display(" OPERATION + : OPERATION = %d, A = %d, B = %d" ,OPERATION, A, B); 
	      end
	1'b1: begin
		 OPERATION[31:0]=A[31:0]-B[31:0]; 
		 $display(" OPERATION - : OPERATION = %d, A = %d, B = %d" ,OPERATION, A, B); 
	      end
	default: begin OPERATION[31:0]<=A[31:0]+B[31:0]; end
	endcase
end
endfunction

always@(posedge pclk or negedge preset)
	begin
		if(!preset)
		begin
			pready<=0;
			prdata<=0;
			state<=IDLE;
		  end
		else
		  begin
			case(state)
			IDLE:
				begin
					if(psel)
					  begin
						state<=SETUP;
					  end
				end

			SETUP:
				begin	
					if(psel && penable)
					  begin
					 	state<=ACCESS;
						pready<=1; 
					  end
				end
				
			ACCESS:
				begin
					if(!pwrite)
					  begin
						case(paddr)
						2'b01: prdata<=A;
						2'b10: prdata<=B;
						default:prdata=OPERATION(operation,A[31:0],B[31:0]);
						endcase

						pready <= 0;
						state<=IDLE;
					  end
					else
					  begin
						case(paddr)
						2'b00: operation<=pwdata[0:0];
						2'b01: A<=pwdata;
						2'b10: B<=pwdata; 
						default: $display("Non-existent address");
						endcase

						pready <= 0;
						state<=IDLE;
					  end
				end
			endcase
		end
	end
endmodule
