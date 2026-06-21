`timescale 1ns / 1ps


module riscv_core(
    input clk,
    input reset
    );

    wire pc_write_en;
    wire pc_sel;
    wire [31:0] ex_pc_target, if_pc_current, if_pc_plus4, if_instruction;
    wire if_id_write_en, if_id_flush;
    wire if_hit;
    wire if_predict_taken;
    wire [31:0] if_btb_target_address;
    wire updatebtb_en;
    wire updatebht_en;
    wire update_taken;
    wire ex_is_jump;
    wire [31:0] ex_btb_pc;
    wire id_ex_write_en, id_ex_flush;
    wire [4:0] id_ex_rs1, id_ex_rs2, id_ex_rd, id_ex_aluOp;
    wire [31:0] id_ex_rv1, id_ex_rv2, id_ex_immediate, id_ex_pc_current, id_ex_pc_plus4;
    wire id_ex_regWrite, id_ex_regfile_data_src, id_ex_lui_instr, id_ex_aluSrcA, id_ex_aluSrcB;
    wire id_ex_memWrite, id_ex_memRead, id_ex_branch, id_ex_jump, id_ex_is_jalr;
    wire [2:0] id_ex_funct3;
    wire id_ex_hit;
    wire id_ex_predict_taken;
    wire [31:0] id_ex_btb_target_address;
    IF_stage if_s(.clk(clk), 
    .reset(reset),
    .pc_write_en(pc_write_en),
    .pc_sel(pc_sel), 
    .ex_pc_target(ex_pc_target),
    .if_pc_current(if_pc_current),
    .if_pc_plus4(if_pc_plus4),
    .if_instruction(if_instruction),
    .updatebtb_en(updatebtb_en),
    .updatebht_en(updatebht_en),
    .id_ex_pc(id_ex_pc_current),
    .update_taken(update_taken),
    .ex_is_jump(ex_is_jump),
    .ex_btb_pc(ex_btb_pc),

    .if_hit(if_hit),
    .if_predict_taken(if_predict_taken),
    .if_btb_target_address(if_btb_target_address));

    wire [31:0] if_id_pc_current, if_id_pc_plus4, if_id_instruction;
    wire if_id_hit;
    wire if_id_predict_taken;
    wire [31:0] if_id_btb_target_address;
    IF_ID_reg if_id_reg(
    .clk(clk),
    .reset(reset),
    .if_pc_current(if_pc_current),
    .if_pc_plus4(if_pc_plus4),
    .if_instruction(if_instruction),
    .if_id_write_en(if_id_write_en),
    .if_id_flush(if_id_flush),
    .if_id_pc_current(if_id_pc_current),
    .if_id_pc_plus4(if_id_pc_plus4),
    .if_id_instruction(if_id_instruction),
    .if_hit(if_hit),
    .if_predict_taken(if_predict_taken),
    .if_btb_target_address(if_btb_target_address),

    .if_id_hit(if_id_hit),
    .if_id_predict_taken(if_id_predict_taken),
    .if_id_btb_target_address(if_id_btb_target_address));
    
    wire [4:0] mem_wb_rd, id_rs1, id_rs2, id_rd;
    wire mem_wb_regWrite;
    wire [31:0] mem_wb_writeData, id_rv1, id_rv2, id_immediate, id_pc_current, id_pc_plus4;
    wire id_regWrite, id_regfile_data_src, id_lui_instr, id_aluSrcA, id_aluSrcB;
    wire id_memWrite, id_memRead, id_branch, id_jump, id_is_jalr, id_uses_rs1, id_uses_rs2;
    wire [4:0] id_aluOp;
    wire [2:0] id_funct3;
    wire id_hit;
    wire id_predict_taken;
    wire [31:0] id_btb_target_address;
    ID_stage id_s(.clk(clk),
    .reset(reset),
    .if_id_pc_current(if_id_pc_current),
    .if_id_pc_plus4(if_id_pc_plus4),
    .if_id_instruction(if_id_instruction),
    .wb_rd(mem_wb_rd),
    .wb_write_data(mem_wb_writeData),
    .wb_regWrite(mem_wb_regWrite),
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .id_rd(id_rd),
    .id_rv1(id_rv1),
    .id_rv2(id_rv2),
    .id_immediate(id_immediate),
    .id_pc_current(id_pc_current),
    .id_pc_plus4(id_pc_plus4),
    .id_regWrite(id_regWrite),
    .id_regfile_data_src(id_regfile_data_src),
    .id_lui_instr(id_lui_instr),
    .id_aluSrcA(id_aluSrcA),
    .id_aluSrcB(id_aluSrcB),
    .id_aluOp(id_aluOp),
    .id_memWrite(id_memWrite),
    .id_memRead(id_memRead),
    .id_funct3(id_funct3),
    .id_branch(id_branch),
    .id_jump(id_jump),
    .id_is_jalr(id_is_jalr),
    .id_uses_rs1(id_uses_rs1),
    .id_uses_rs2(id_uses_rs2),
    .if_id_hit(if_id_hit),
    .if_id_predict_taken(if_id_predict_taken),
    .if_id_btb_target_address(if_id_btb_target_address),

    .id_hit(id_hit),
    .id_predict_taken(id_predict_taken),
    .id_btb_target_address(id_btb_target_address));
    
    ID_EX_reg id_ex_reg(.clk(clk),
    .reset(reset),

    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .id_rd(id_rd),

    .id_rv1(id_rv1),
    .id_rv2(id_rv2),
    .id_immediate(id_immediate),

    .id_pc_current(id_pc_current),
    .id_pc_plus4(id_pc_plus4),

    .id_regWrite(id_regWrite),
    .id_regfile_data_src(id_regfile_data_src),

    .id_aluSrcA(id_aluSrcA),
    .id_aluSrcB(id_aluSrcB),
    .id_aluOp(id_aluOp),

    .id_memWrite(id_memWrite),
    .id_memRead(id_memRead),
    .id_funct3(id_funct3),

    .id_branch(id_branch),
    .id_jump(id_jump),
    .id_is_jalr(id_is_jalr),

    .id_ex_write_en(id_ex_write_en),
    .id_ex_flush(id_ex_flush),
    .id_lui_instr(id_lui_instr),

    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_rd(id_ex_rd),

    .id_ex_rv1(id_ex_rv1),
    .id_ex_rv2(id_ex_rv2),
    .id_ex_immediate(id_ex_immediate),

    .id_ex_pc_current(id_ex_pc_current),
    .id_ex_pc_plus4(id_ex_pc_plus4),

    .id_ex_regWrite(id_ex_regWrite),
    .id_ex_regfile_data_src(id_ex_regfile_data_src),
    .id_ex_lui_instr(id_ex_lui_instr),

    .id_ex_aluSrcA(id_ex_aluSrcA),
    .id_ex_aluSrcB(id_ex_aluSrcB),
    .id_ex_aluOp(id_ex_aluOp),

    .id_ex_memWrite(id_ex_memWrite),
    .id_ex_memRead(id_ex_memRead),
    .id_ex_funct3(id_ex_funct3),

    .id_ex_branch(id_ex_branch),
    .id_ex_jump(id_ex_jump),
    .id_ex_is_jalr(id_ex_is_jalr),
    .id_hit(id_hit),
    .id_predict_taken(id_predict_taken),
    .id_btb_target_address(id_btb_target_address),
    .id_ex_hit(id_ex_hit),
    .id_ex_predict_taken(id_ex_predict_taken),
    .id_ex_btb_target_address(id_ex_btb_target_address));

    wire [4:0] ex_mem_rd, ex_rd;
    wire ex_mem_regWrite, ex_flush, ex_regWrite, ex_memWrite, ex_memRead, ex_regfile_data_src;
    wire [31:0] ex_mem_aluResult, ex_aluResult_pc, ex_forwarded_data;
    wire [2:0] ex_funct3;
    EX_stage ex_s(
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_rd(id_ex_rd),

    .id_ex_rv1(id_ex_rv1),
    .id_ex_rv2(id_ex_rv2),
    .id_ex_immediate(id_ex_immediate),

    .id_ex_pc_current(id_ex_pc_current),
    .id_ex_pc_plus4(id_ex_pc_plus4),

    .id_ex_regWrite(id_ex_regWrite),
    .id_ex_regfile_data_src(id_ex_regfile_data_src),

    .id_ex_aluSrcA(id_ex_aluSrcA),
    .id_ex_aluSrcB(id_ex_aluSrcB),
    .id_ex_aluOp(id_ex_aluOp),

    .id_ex_memWrite(id_ex_memWrite),
    .id_ex_memRead(id_ex_memRead),
    .id_ex_funct3(id_ex_funct3),

    .id_ex_branch(id_ex_branch),
    .id_ex_jump(id_ex_jump),
    .id_ex_is_jalr(id_ex_is_jalr),

    .ex_mem_rd(ex_mem_rd),
    .ex_mem_regWrite(ex_mem_regWrite),
    .ex_mem_aluResult(ex_mem_aluResult),

    .mem_wb_rd(mem_wb_rd),
    .mem_wb_regWrite(mem_wb_regWrite),
    .mem_wb_writeData(mem_wb_writeData),

    .id_ex_lui_instr(id_ex_lui_instr),

    .ex_pc_sel(pc_sel),
    .ex_pc_target(ex_pc_target),
    .ex_flush(ex_flush),

    .ex_aluResult_pc(ex_aluResult_pc),
    .ex_forwarded_data(ex_forwarded_data),

    .ex_rd(ex_rd),
    .ex_funct3(ex_funct3),

    .ex_regWrite(ex_regWrite),
    .ex_memWrite(ex_memWrite),
    .ex_memRead(ex_memRead),
    .ex_regfile_data_src(ex_regfile_data_src),
    .id_ex_hit(id_ex_hit),
    .id_ex_predict_taken(id_ex_predict_taken),
    .id_ex_btb_target_address(id_ex_btb_target_address),
    .updatebtb_en(updatebtb_en),
    .updatebht_en(updatebht_en),
    .ex_btb_pc(ex_btb_pc),
    .update_taken(update_taken),
    .ex_is_jump(ex_is_jump));
    
    wire [31:0] ex_mem_forwarded_data;
    wire [2:0] ex_mem_funct3;
    wire ex_mem_memWrite, ex_mem_memRead, ex_mem_regfile_data_src;
    EX_MEM_reg ex_mem_reg(.clk(clk),
    .reset(reset),

    .ex_aluResult_pc(ex_aluResult_pc),
    .ex_forwarded_data(ex_forwarded_data),
    .ex_rd(ex_rd),
    .ex_funct3(ex_funct3),

    .ex_regWrite(ex_regWrite),
    .ex_memWrite(ex_memWrite),
    .ex_memRead(ex_memRead),
    .ex_regfile_data_src(ex_regfile_data_src),

    .ex_mem_aluResult(ex_mem_aluResult),
    .ex_mem_forwarded_data(ex_mem_forwarded_data),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_funct3(ex_mem_funct3),

    .ex_mem_regWrite(ex_mem_regWrite),
    .ex_mem_memWrite(ex_mem_memWrite),
    .ex_mem_memRead(ex_mem_memRead),
    .ex_mem_regfile_data_src(ex_mem_regfile_data_src));
    
    wire [31:0] mem_writeData;
    wire [4:0] mem_rd;
    wire mem_regWrite;
    MEM_stage mem_s(.clk(clk),
    .ex_mem_aluResult(ex_mem_aluResult),
    .ex_mem_forwarded_data(ex_mem_forwarded_data),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_funct3(ex_mem_funct3),

    .ex_mem_regWrite(ex_mem_regWrite),
    .ex_mem_memWrite(ex_mem_memWrite),
    .ex_mem_memRead(ex_mem_memRead),
    .ex_mem_regfile_data_src(ex_mem_regfile_data_src),

    .mem_writeData(mem_writeData),
    .mem_rd(mem_rd),
    .mem_regWrite(mem_regWrite));
    
    MEM_WB_reg mem_wb_reg(.clk(clk),
    .reset(reset),

    .mem_writeData(mem_writeData),
    .mem_rd(mem_rd),
    .mem_regWrite(mem_regWrite),

    .mem_wb_writeData(mem_wb_writeData),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_regWrite(mem_wb_regWrite));
    
    hazard_detection_unit HDU(
    .if_id_instruction(if_id_instruction),

    .id_ex_rd(id_ex_rd),
    .id_ex_memRead(id_ex_memRead),

    .ex_flush(ex_flush),

    .id_uses_rs1(id_uses_rs1),
    .id_uses_rs2(id_uses_rs2),

    .if_id_flush(if_id_flush),
    .if_id_write_en(if_id_write_en),

    .id_ex_flush(id_ex_flush),
    .id_ex_write_en(id_ex_write_en),

    .pc_write_en(pc_write_en));


endmodule
