`timescale 1ns / 1ps

module MEM_stage(
    input clk,
    input [31:0] ex_mem_aluResult,
    input [31:0] ex_mem_forwarded_data,
    input [4:0] ex_mem_rd,
    input [2:0] ex_mem_funct3,
    input ex_mem_regWrite,
    input ex_mem_memWrite,
    input ex_mem_memRead,
    input ex_mem_regfile_data_src,
    output [31:0] mem_writeData,
    output [4:0] mem_rd,
    output mem_regWrite
    );

    wire [31:0] mem_read_data;
    data_memory dmem(.clk(clk),
    .r_en(ex_mem_memRead),
    .w_en(ex_mem_memWrite),
    .address(ex_mem_aluResult),
    .data_in(ex_mem_forwarded_data),
    .func3(ex_mem_funct3),
    .data_out(mem_read_data));

    assign mem_writeData = (ex_mem_regfile_data_src)? mem_read_data : ex_mem_aluResult;
    assign mem_rd = ex_mem_rd;
    assign mem_regWrite = ex_mem_regWrite;
endmodule
