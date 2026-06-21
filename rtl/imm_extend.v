`timescale 1ns / 1ps

module imm_extend(
    input [31:0] instruction,
    input [2:0] immediate_type,
    output reg [31:0] immediate_out  
    );

    always @(*) begin
        case(immediate_type)
            // i type
            3'b000: immediate_out = {{20{instruction[31]}}, instruction[31:20]};
            // s type
            3'b001: immediate_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            // b type 
            3'b010: immediate_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            // u type 
            3'b011: immediate_out = {instruction[31:12], 12'b0};
            // j type
            3'b100: immediate_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            default: immediate_out = 32'b0;
        endcase
    end
endmodule