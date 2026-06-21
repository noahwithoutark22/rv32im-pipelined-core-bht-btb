`timescale 1ns / 1ps

module IF_stage(
    input clk, 
    input reset,
    input pc_write_en, 
    input pc_sel,
    input [31:0] ex_pc_target,
    input updatebtb_en,
    input updatebht_en,
    input [31:0] id_ex_pc,
    input update_taken,
    input ex_is_jump,
    input [31:0] ex_btb_pc,
    output [31:0] if_pc_current,
    output [31:0] if_pc_plus4,
    output [31:0] if_instruction,
    output if_hit,
    output if_predict_taken,
    output [31:0] if_btb_target_address
    ); 

    wire [31:0] pc_next, pc_current, f_target_address;
    wire f_is_jump;
    assign pc_next = (pc_sel)? ex_pc_target : ( (btbHit && (f_is_jump || predict_taken)) ? f_target_address : if_pc_plus4);

    pc prog_count(.clk(clk),
        .reset(reset),
        .pc_write_en(pc_write_en),
        .pc_in(pc_next),
        .pc_out(pc_current));

    assign if_pc_plus4 = pc_current + 32'd4;
    assign if_pc_current = pc_current;

    instruction_memory imem(.address(pc_current),
        .instruction(if_instruction));

    wire btbHit, predict_taken;

    BTB btb64(.clk(clk),
    .reset(reset),
    .f_pc(pc_current),
    .hit(btbHit),
    .f_is_jump(f_is_jump),
    .ex_is_jump(ex_is_jump),
    .f_target_address(f_target_address),
    .updatebtb_en(updatebtb_en),
    .ex_pc(id_ex_pc),
    .ex_branch_target(ex_btb_pc));

    BHT64Entry bht(.clk(clk),
    .reset(reset),
    .current_pc(pc_current),
    .predict_taken(predict_taken),
    .updatebht_en(updatebht_en),
    .new_pc(id_ex_pc),
    .update_taken(update_taken));

    assign if_hit = btbHit;
    assign if_predict_taken = predict_taken;
    assign if_btb_target_address = f_target_address;


endmodule
