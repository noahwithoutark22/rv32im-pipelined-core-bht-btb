`timescale 1ns / 1ps

module ID_EX_reg(
    input clk,
    input reset,
    input [4:0] id_rs1, id_rs2,
    input [4:0] id_rd,
    input [31:0] id_rv1, id_rv2,
    input [31:0] id_immediate,
    input [31:0] id_pc_current,
    input [31:0] id_pc_plus4,
    input id_regWrite,
    input id_regfile_data_src,
    input id_aluSrcA,
    input id_aluSrcB,
    input [4:0] id_aluOp,
    input id_memWrite,
    input id_memRead,
    input [2:0] id_funct3,
    input id_branch,
    input id_jump,
    input id_is_jalr,
    input id_ex_write_en,
    input id_ex_flush,
    input id_lui_instr,
    input id_hit,
    input id_predict_taken,
    input [31:0] id_btb_target_address,
    output reg [4:0] id_ex_rs1,
    output reg [4:0] id_ex_rs2,
    output reg [4:0] id_ex_rd,
    output reg [31:0] id_ex_rv1,
    output reg [31:0] id_ex_rv2,
    output reg [31:0] id_ex_immediate,
    output reg [31:0] id_ex_pc_current,
    output reg [31:0] id_ex_pc_plus4,
    output reg id_ex_regWrite,
    output reg id_ex_regfile_data_src,
    output reg id_ex_lui_instr,
    output reg id_ex_aluSrcA,
    output reg id_ex_aluSrcB,
    output reg [4:0] id_ex_aluOp,
    output reg id_ex_memWrite,
    output reg id_ex_memRead,
    output reg [2:0] id_ex_funct3,
    output reg id_ex_branch,
    output reg id_ex_jump,
    output reg id_ex_is_jalr,
    output reg id_ex_hit,
    output reg id_ex_predict_taken,
    output reg [31:0] id_ex_btb_target_address
    );

    always @(posedge clk or posedge reset) begin
        if(reset || id_ex_flush) begin
            id_ex_rs1 <= 5'd0;
            id_ex_rs2 <= 5'd0;
            id_ex_rd  <= 5'd0;

            id_ex_rv1 <= 32'd0;
            id_ex_rv2 <= 32'd0;
            id_ex_immediate <= 32'd0;
            id_ex_pc_current <= 32'd0;
            id_ex_pc_plus4 <= 32'd0;

            id_ex_regWrite <= 1'b0;
            id_ex_regfile_data_src <= 1'b0;

            id_ex_aluSrcA <= 1'b0;
            id_ex_aluSrcB <= 1'b0;
            id_ex_aluOp <= 5'd0;

            id_ex_memWrite <= 1'b0;
            id_ex_memRead <= 1'b0;
            id_ex_funct3 <= 3'd0;

            id_ex_branch <= 1'b0;
            id_ex_jump <= 1'b0;
            id_ex_is_jalr <= 1'b0;
            id_ex_lui_instr <= 1'b0;
            id_ex_hit <= 1'b0;
            id_ex_predict_taken <= 1'b0;
            id_ex_btb_target_address <= 32'd0;
        end
        else if(id_ex_write_en) begin
            id_ex_rs1 <= id_rs1;
            id_ex_rs2 <= id_rs2;
            id_ex_rd  <= id_rd;

            id_ex_rv1 <= id_rv1;
            id_ex_rv2 <= id_rv2;
            id_ex_immediate <= id_immediate;
            id_ex_pc_current <= id_pc_current;
            id_ex_pc_plus4 <= id_pc_plus4;

            id_ex_regWrite <= id_regWrite;
            id_ex_regfile_data_src <= id_regfile_data_src;

            id_ex_aluSrcA <= id_aluSrcA;
            id_ex_aluSrcB <= id_aluSrcB;
            id_ex_aluOp <= id_aluOp;

            id_ex_memWrite <= id_memWrite;
            id_ex_memRead <= id_memRead;
            id_ex_funct3 <= id_funct3;

            id_ex_branch <= id_branch;
            id_ex_jump <= id_jump;
            id_ex_is_jalr <= id_is_jalr;
            id_ex_lui_instr <= id_lui_instr;
            id_ex_hit <= id_hit;
            id_ex_predict_taken <= id_predict_taken;
            id_ex_btb_target_address <= id_btb_target_address;
        end
    end
endmodule
