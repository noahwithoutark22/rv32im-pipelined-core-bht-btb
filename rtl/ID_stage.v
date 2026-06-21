`timescale 1ns / 1ps

module ID_stage(
    input clk,
    input reset,
    input [31:0] if_id_pc_current,
    input [31:0] if_id_pc_plus4,
    input [31:0] if_id_instruction,
    input [4:0] wb_rd,
    input [31:0] wb_write_data,
    input wb_regWrite,
    input if_id_hit,
    input if_id_predict_taken,
    input [31:0] if_id_btb_target_address,
    output [4:0] id_rs1, id_rs2,
    output [4:0] id_rd,
    output [31:0] id_rv1, id_rv2,
    output [31:0] id_immediate,
    output [31:0] id_pc_current,
    output [31:0] id_pc_plus4,
    output id_regWrite,
    output id_regfile_data_src,
    output id_lui_instr,
    output id_aluSrcA,
    output id_aluSrcB,
    output [4:0] id_aluOp,
    output id_memWrite,
    output id_memRead,
    output [2:0] id_funct3,
    output id_branch,
    output id_jump,
    output id_is_jalr,
    output id_uses_rs1,
    output id_uses_rs2,
    output id_hit,
    output id_predict_taken,
    output [31:0] id_btb_target_address
    ); 
    wire [2:0] immType;
    wire [6:0] opcode;
    wire [6:0] funct7;
    wire [2:0] funct3;

    assign opcode = if_id_instruction[6:0];
    assign funct3 = if_id_instruction[14:12];
    assign funct7 = if_id_instruction[31:25];

    assign id_rs1 = if_id_instruction[19:15];
    assign id_rs2 = if_id_instruction[24:20];
    assign id_rd  = if_id_instruction[11:7];
    assign id_funct3 = funct3;
    assign id_pc_current = if_id_pc_current;
    assign id_pc_plus4   = if_id_pc_plus4;
    assign id_hit = if_id_hit;
    assign id_predict_taken = if_id_predict_taken;
    assign id_btb_target_address = if_id_btb_target_address;

    control_unit cu (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .regWrite(id_regWrite),
        .immType(immType),
        .regfile_data_src(id_regfile_data_src),
        .aluSrcA(id_aluSrcA),
        .aluSrcB(id_aluSrcB),
        .aluOp(id_aluOp),
        .memWrite(id_memWrite),
        .memRead(id_memRead),
        .branch(id_branch),
        .jump(id_jump),
        .is_jalr(id_is_jalr),
        .lui_instr(id_lui_instr),
        .id_uses_rs1(id_uses_rs1),
        .id_uses_rs2(id_uses_rs2)
    );

    imm_extend imm_gen(
    .instruction(if_id_instruction),
    .immediate_type(immType),
    .immediate_out(id_immediate));

    register_file reg_file(.ra1(id_rs1),
    .ra2(id_rs2),
    .wa(wb_rd),
    .we(wb_regWrite),
    .w_data(wb_write_data),
    .clk(clk),
    .reset(reset),
    .rd1(id_rv1),
    .rd2(id_rv2));
    
endmodule