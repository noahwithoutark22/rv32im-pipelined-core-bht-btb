`timescale 1ns / 1ps

module IF_ID_reg(
    input clk,
    input reset,
    input [31:0] if_pc_current,
    input [31:0] if_pc_plus4,
    input [31:0] if_instruction,
    input if_id_write_en,
    input if_id_flush,
    input if_hit,
    input if_predict_taken,
    input [31:0] if_btb_target_address,
    output reg [31:0] if_id_pc_current,
    output reg [31:0] if_id_pc_plus4,
    output reg [31:0] if_id_instruction,
    output reg if_id_hit,
    output reg if_id_predict_taken,
    output reg [31:0] if_id_btb_target_address
    );

    always @(posedge clk or posedge reset) begin
        if(reset || if_id_flush) begin
            if_id_pc_current <= 32'd0;
            if_id_pc_plus4 <= 32'd0;
            if_id_instruction <= 32'h00000013;
            if_id_hit <= 1'b0;
            if_id_predict_taken <= 1'b0;
            if_id_btb_target_address <= 32'd0;
        end
        else if(if_id_write_en) begin
            if_id_pc_current <= if_pc_current;
            if_id_pc_plus4 <= if_pc_plus4;
            if_id_instruction <= if_instruction;
            if_id_hit <= if_hit;
            if_id_predict_taken <= if_predict_taken;
            if_id_btb_target_address <= if_btb_target_address;
        end
    end



endmodule
