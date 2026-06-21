`timescale 1ns / 1ps
module alu(
    input [31:0] a,
    input [31:0] b,
    input [4:0]  alu_op,
    output reg  [31:0] alu_result,
    
    output flag_zero,
    output flag_less_than,
    output flag_less_than_un
    );

    assign flag_zero         = (alu_result == 0);
    assign flag_less_than    = ($signed(a) < $signed(b));
    assign flag_less_than_un = (a < b);

    wire [63:0] mul_signed_signed;
    wire [63:0] mul_unsign_unsign;
    wire [64:0] mul_signed_unsign;

    assign mul_signed_signed = $signed(a) * $signed(b);
    assign mul_unsign_unsign = a * b;
    assign mul_signed_unsign = $signed(a) * $signed({1'b0, b});

    always @(*) begin
        case (alu_op)
            5'd0: alu_result = a + b;                      // ADD / ADDI
            5'd1: alu_result = a - b;                      // SUB
            5'd2: alu_result = a & b;                      // AND / ANDI
            5'd3: alu_result = a | b;                      // OR / ORI
            5'd4: alu_result = a ^ b;                      // XOR / XORI
            5'd5: alu_result = a << b[4:0];                // SLL / SLLI 
            5'd6: begin                                                    // DIV
                if (b == 32'b0)
                    alu_result = 32'hFFFF_FFFF;                            // div by zero rule
                else if (a == 32'h8000_0000 && b == 32'hFFFF_FFFF)
                    alu_result = 32'h8000_0000;                            // signed overflow rule 
                else
                    alu_result = $signed(a) / $signed(b);
            end
            5'd7: begin                                                    // DIVU
                if (b == 32'b0)
                    alu_result = 32'hFFFF_FFFF;
                else
                    alu_result = a / b;
            end
            5'd8: alu_result = {31'b0, flag_less_than}; // SLT / SLTI
            5'd9: alu_result = a >> b[4:0];                // SRL / SRLI
            5'd10: alu_result = $signed(a) >>> b[4:0];     // SRA / SRAI 
            5'd11: alu_result = mul_unsign_unsign[31:0];                   // MUL
            5'd12: alu_result = mul_signed_signed[63:32];                  // MULH
            5'd13: alu_result = mul_unsign_unsign[63:32];                  // MULHU
            5'd14: alu_result = mul_signed_unsign[63:32];                  // MULHSU
            5'd15: begin                                                   // REM
                if (b == 32'b0)
                    alu_result = a;                                // rem by zero rule
                else if (a == 32'h8000_0000 && b == 32'hFFFF_FFFF)
                    alu_result = 32'b0;                                    // overflow remainder rule
                else
                    alu_result = $signed(a) % $signed(b);
            end
            5'd16: begin                                                   // REMU
                if (b == 32'b0)
                    alu_result = a;
                else
                    alu_result = a % b;
            end
            5'd17: alu_result = {31'b0, flag_less_than_un}; // SLTU / SLTIU
            default: alu_result = 32'b0;
        endcase
    end
endmodule
