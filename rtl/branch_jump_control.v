`timescale 1ns / 1ps

module branch_jump_control(
    input branch,
    input jump,
    input flag_zero,
    input flag_less_than,
    input flag_less_than_un,
    input [2:0] funct3,
    output pc_sel
    );

    reg branch_cond_met;

    always @(*) begin
        case(funct3)
            3'b000: branch_cond_met = flag_zero;          // BEQ
            3'b001: branch_cond_met = !flag_zero;         // BNE
            3'b100: branch_cond_met = flag_less_than;     // BLT
            3'b101: branch_cond_met = !flag_less_than;    // BGE
            3'b110: branch_cond_met = flag_less_than_un;  // BLTU
            3'b111: branch_cond_met = !flag_less_than_un; // BGEU
        default: branch_cond_met = 1'b0;
        endcase

    end

    assign pc_sel = jump || (branch && branch_cond_met);
endmodule
