module apb_slave (
    input logic clk,
    input logic rst_n,
    input logic [31:0] PADDR,
    input logic [31:0] inp_data,
    input logic PWRITE,
    input logic PENABLE,
    input logic PREADY,
    input logic [31:0] PRDATA,
    output reg [127:0] display_message
);



always @*  begin

    if (PENABLE) begin
        if (PWRITE) begin
            
            display_message = "Write to memory";
            $display("%s to 0x%h", display_message,PADDR);
        end 
        if(PREADY) begin
            display_message = "Read from memor,"; 
            $display("%s from 0x%h", display_message, PADDR);
        end
    end
end

endmodule