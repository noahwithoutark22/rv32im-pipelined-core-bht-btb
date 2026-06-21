`timescale 1ns / 1ps

module EX_stage(
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    input [4:0] id_ex_rd,
    input [31:0] id_ex_rv1,
    input [31:0] id_ex_rv2,
    input [31:0] id_ex_immediate,
    input [31:0] id_ex_pc_current,
    input [31:0] id_ex_pc_plus4,
    input id_ex_regWrite,
    input id_ex_regfile_data_src,
    input id_ex_aluSrcA,
    input id_ex_aluSrcB,
    input [4:0] id_ex_aluOp,
    input id_ex_memWrite,
    input id_ex_memRead,
    input [2:0] id_ex_funct3,
    input id_ex_branch,
    input id_ex_jump,
    input id_ex_is_jalr,
    input [4:0] ex_mem_rd,
    input ex_mem_regWrite,
    input [31:0] ex_mem_aluResult,
    input [4:0] mem_wb_rd,
    input mem_wb_regWrite,
    input [31:0] mem_wb_writeData,
    input id_ex_lui_instr,
    input id_ex_hit,
    input id_ex_predict_taken,
    input [31:0] id_ex_btb_target_address,

    output ex_pc_sel,
    output [31:0] ex_pc_target,
    output ex_flush,
    output [31:0] ex_aluResult_pc,
    output [31:0] ex_forwarded_data,
    output [4:0] ex_rd,
    output [2:0] ex_funct3,
    output ex_regWrite,
    output ex_memWrite,
    output ex_memRead,
    output ex_regfile_data_src,
    output updatebtb_en,
    output updatebht_en,
    output [31:0] ex_btb_pc,
    output update_taken,
    output ex_is_jump

    );


    wire [31:0] aluInA, aluInB;
    wire [31:0] forwardedA = ( (id_ex_rs1 != 5'd0) && (ex_mem_rd == id_ex_rs1) && ex_mem_regWrite ) ? ex_mem_aluResult 
    :(((id_ex_rs1 != 5'd0) && (mem_wb_rd == id_ex_rs1) && mem_wb_regWrite )? mem_wb_writeData 
    :id_ex_rv1);
    wire [31:0] luiHandle = (id_ex_lui_instr)? 32'd0 : forwardedA; 
    
    wire [31:0] forwardedB = ( (id_ex_rs2 != 5'd0) && (ex_mem_rd == id_ex_rs2) && ex_mem_regWrite ) ? ex_mem_aluResult 
    :(((id_ex_rs2 != 5'd0) && (mem_wb_rd == id_ex_rs2) && mem_wb_regWrite )? mem_wb_writeData 
    :id_ex_rv2);
    assign aluInA = (id_ex_aluSrcA)? id_ex_pc_current : luiHandle;
    assign aluInB = (id_ex_aluSrcB)? id_ex_immediate : forwardedB;

    wire ex_flag_zero, ex_flag_less_than, ex_flag_less_than_un, ex_actual_taken; 
    wire [31:0] ex_aluResult;
    alu ALU(.a(aluInA),
    .b(aluInB),
    .alu_op(id_ex_aluOp),
    .alu_result(ex_aluResult),

    .flag_zero(ex_flag_zero),
    .flag_less_than(ex_flag_less_than),
    .flag_less_than_un(ex_flag_less_than_un));

    branch_jump_control bcu(.branch(id_ex_branch),
    .jump(id_ex_jump),
    .flag_zero(ex_flag_zero),
    .flag_less_than(ex_flag_less_than),
    .flag_less_than_un(ex_flag_less_than_un),
    .funct3(id_ex_funct3),
    .pc_sel(ex_actual_taken));
    
    wire [31:0] ex_pc_branch_jal;
    assign ex_pc_branch_jal = id_ex_pc_current + id_ex_immediate;
    wire [31:0] ex_pc_target_intermediate;
    assign ex_pc_target_intermediate = (id_ex_is_jalr) ? ({ex_aluResult[31:1], 1'b0}) : ex_pc_branch_jal;

    assign ex_aluResult_pc = (id_ex_jump)? id_ex_pc_plus4 : ex_aluResult;
    assign ex_flush = ex_pc_sel;
    assign ex_forwarded_data = forwardedB;
    assign ex_rd = id_ex_rd;
    assign ex_funct3 = id_ex_funct3;
    assign ex_regWrite = id_ex_regWrite;
    assign ex_memWrite = id_ex_memWrite;
    assign ex_memRead = id_ex_memRead;
    assign ex_regfile_data_src = id_ex_regfile_data_src;
    assign updatebht_en = id_ex_branch; // bht updation signals
    assign update_taken = ex_actual_taken; 
    wire btb_jump_update = (id_ex_jump && ((id_ex_hit && (id_ex_btb_target_address != ex_pc_target_intermediate)) 
                            || !id_ex_hit));
    wire btb_tt_targ_mismatch =  id_ex_predict_taken && ex_actual_taken && (id_ex_btb_target_address != ex_pc_target_intermediate);
    wire btb_nt_update = (!id_ex_predict_taken && ex_actual_taken && (id_ex_btb_target_address != ex_pc_target_intermediate));

    assign updatebtb_en =  btb_jump_update 
                            || (id_ex_branch && ((id_ex_hit && (btb_tt_targ_mismatch
                                                                || btb_nt_update)
                                                                )
                                                                || (!id_ex_hit && ex_actual_taken)
                                                                ))  ;                                                       
    assign ex_btb_pc = ex_pc_target_intermediate;
    assign ex_pc_target = (id_ex_jump || (id_ex_branch && ((id_ex_hit && (btb_tt_targ_mismatch
                                                                || btb_nt_update)) || (!id_ex_hit && ex_actual_taken)))) ? ex_pc_target_intermediate : (id_ex_pc_plus4);
    assign ex_pc_sel = btb_jump_update ||
                        (id_ex_branch && ((id_ex_hit && ((id_ex_predict_taken ^ ex_actual_taken) || btb_tt_targ_mismatch )) ||(!id_ex_hit && ex_actual_taken) ) ) ;
    assign ex_is_jump = id_ex_jump;
                         


endmodule
