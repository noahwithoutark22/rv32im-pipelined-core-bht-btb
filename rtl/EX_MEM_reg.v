`timescale 1ns / 1ps

module EX_MEM_reg(
    input clk,
    input reset,
    input [31:0] ex_aluResult_pc,
    input [31:0] ex_forwarded_data,
    input [4:0]  ex_rd,
    input [2:0]  ex_funct3,
    input ex_regWrite,
    input ex_memWrite,
    input ex_memRead,
    input ex_regfile_data_src,
    output reg [31:0] ex_mem_aluResult,
    output reg [31:0] ex_mem_forwarded_data,
    output reg [4:0]  ex_mem_rd,
    output reg [2:0]  ex_mem_funct3,
    output reg ex_mem_regWrite,
    output reg ex_mem_memWrite,
    output reg ex_mem_memRead,
    output reg ex_mem_regfile_data_src
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ex_mem_aluResult <= 32'b0;
            ex_mem_forwarded_data <= 32'b0;
            ex_mem_rd <= 5'b0;
            ex_mem_funct3 <= 3'b0;
            ex_mem_regWrite <= 1'b0;
            ex_mem_memWrite <= 1'b0;
            ex_mem_memRead <= 1'b0;
            ex_mem_regfile_data_src <= 1'b0;
        end
        else begin
            ex_mem_aluResult <= ex_aluResult_pc;
            ex_mem_forwarded_data <= ex_forwarded_data;
            ex_mem_rd <= ex_rd;
            ex_mem_funct3 <= ex_funct3;
            ex_mem_regWrite <= ex_regWrite;
            ex_mem_memWrite <= ex_memWrite;
            ex_mem_memRead <= ex_memRead;
            ex_mem_regfile_data_src <= ex_regfile_data_src;
        end
    end
endmodule
