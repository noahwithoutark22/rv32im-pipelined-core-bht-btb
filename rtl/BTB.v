`timescale 1ns / 1ps

module BTB(
    input clk,
    input reset,

    input [31:0] f_pc,
    output hit,
    output [31:0] f_target_address,
    output f_is_jump,
    input updatebtb_en,
    input [31:0] ex_pc,
    input [31:0] ex_branch_target,
    input ex_is_jump
    );
    // 1 bit for is_jump 24 bit tag 30 bit target 1 bit valid
    reg [55:0] btb64[0:63];

    assign hit = btb64[f_pc[7:2]][0] && (btb64[f_pc[7:2]][54:31] == f_pc[31:8]);
    assign f_target_address = {btb64[f_pc[7:2]][30:1], 2'b00};
    assign f_is_jump = btb64[f_pc[7:2]][55];
    integer i;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0;i<64;i=i+1) begin
                btb64[i] <= 56'd0;
            end
        end
        else if(updatebtb_en) begin
            btb64[ex_pc[7:2]] <= {ex_is_jump, ex_pc[31:8], ex_branch_target[31:2], 1'b1}; 
        end
    end

endmodule
