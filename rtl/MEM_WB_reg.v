`timescale 1ns / 1ps

module MEM_WB_reg(
    input clk,
    input reset,
    input [31:0] mem_writeData,
    input [4:0] mem_rd,
    input mem_regWrite,
    output reg [31:0] mem_wb_writeData,
    output reg [4:0] mem_wb_rd,
    output reg mem_wb_regWrite
    );

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            mem_wb_writeData <= 32'd0;
            mem_wb_rd <= 5'd0;
            mem_wb_regWrite <= 1'b0;
        end
        else begin
            mem_wb_writeData <= mem_writeData;
            mem_wb_rd <= mem_rd;
            mem_wb_regWrite <= mem_regWrite;
        end
    end
endmodule
