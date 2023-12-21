`timescale 1ns/1ps
module apb_master (
    input logic clk,
    input logic rst_n,
    output logic [31:0] PADDR,
    output logic [31:0] PRDATA,
    output logic PENABLE,
    output logic PREADY,
    output logic PWRITE
);

    logic [31:0] memory_data;
    logic [31:0] memory_address;

    logic [31:0] memory[31:0];


    always @(posedge clk) begin
    if(rst_n) begin
        if (PENABLE) begin
            memory_data <= PADDR;
            memory_address <= PADDR;
        end
        if (PWRITE) begin
            memory[memory_address] <= memory_data;
        end
    end
    end

    always @PREADY begin 
        PREADY = 1'b0;        
        
    end
    
    task apb_write (input logic [31:0] inp_addr, input logic [31:0] inp_data);
        begin
            memory_address <= inp_addr;
            memory_data <= inp_data;
            PRDATA <= inp_data;
            PADDR <= inp_addr;
            PWRITE <= 1'b1;
            PENABLE <= 1'b1;
            @(posedge clk);
            PENABLE <= 1'b0;
            PWRITE <= 1'b0;
        end
    endtask

    function logic [31:0] apb_read (input logic [31:0] inp_addr);
        begin
            memory_address = inp_addr;
            PREADY = 1'b1;
            PENABLE = 1'b1;
            apb_read = memory[memory_address];
        end
    endfunction

endmodule





