`timescale 1ns / 1ps

module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg regWrite,
    output reg [2:0] immType,
    output reg regfile_data_src,
    output reg aluSrcA,
    output reg aluSrcB,
    output reg [4:0] aluOp,
    output reg memWrite,
    output reg memRead,
    output reg branch,
    output reg jump,
    output reg is_jalr,
    output reg lui_instr,
    output reg id_uses_rs1,
    output reg id_uses_rs2
);

    always @(*) begin
        regWrite = 1'b0;
        immType = 3'b000;
        regfile_data_src = 1'b0;
        aluSrcA = 1'b0;
        aluSrcB = 1'b0;
        aluOp = 5'd0;
        memWrite = 1'b0;
        memRead = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
        is_jalr = 1'b0;
        lui_instr = 1'b0;
        id_uses_rs1 = 1'b0;
        id_uses_rs2 = 1'b0;

        case (opcode)
            // r type and m type
            7'b0110011: begin
                regWrite = 1'b1;
                immType = 3'b000;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b0;
                id_uses_rs1 = 1'b1;
                id_uses_rs2 = 1'b1;

                if (funct7 == 7'b0000001) begin
                    // m type
                    case (funct3)
                        3'b000: aluOp = 5'd11; // MUL
                        3'b001: aluOp = 5'd12; // MULH
                        3'b010: aluOp = 5'd14; // MULHSU
                        3'b011: aluOp = 5'd13; // MULHU
                        3'b100: aluOp = 5'd6;  // DIV
                        3'b101: aluOp = 5'd7;  // DIVU
                        3'b110: aluOp = 5'd15; // REM
                        3'b111: aluOp = 5'd16; // REMU
                        default: aluOp = 5'd0;
                    endcase
                end else begin
                    // r type
                    case (funct3)
                        3'b000: aluOp = (funct7[5]) ? 5'd1 : 5'd0; // SUB vs ADD
                        3'b001: aluOp = 5'd5;  // SLL
                        3'b010: aluOp = 5'd8;  // SLT
                        3'b011: aluOp = 5'd17; // SLTU
                        3'b100: aluOp = 5'd4;  // XOR
                        3'b101: aluOp = (funct7[5]) ? 5'd10 : 5'd9; // SRA vs SRL
                        3'b110: aluOp = 5'd3;  // OR
                        3'b111: aluOp = 5'd2;  // AND
                    endcase
                end
            end

            // i type
            7'b0010011: begin
                regWrite = 1'b1;
                immType = 3'b000;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b1;
                id_uses_rs1 = 1'b1;

                case (funct3)
                    3'b000: aluOp = 5'd0;  // ADDI
                    3'b010: aluOp = 5'd8;  // SLTI
                    3'b011: aluOp = 5'd17; // SLTIU
                    3'b100: aluOp = 5'd4;  // XORI
                    3'b110: aluOp = 5'd3;  // ORI
                    3'b111: aluOp = 5'd2;  // ANDI
                    3'b001: aluOp = 5'd5;  // SLLI
                    3'b101: aluOp = (funct7[5]) ? 5'd10 : 5'd9; // SRAI vs SRLI
                endcase
            end

            // memory loads
            7'b0000011: begin
                regWrite = 1'b1;
                immType = 3'b000;
                regfile_data_src = 1'b1;
                aluSrcA = 1'b0;
                aluSrcB = 1'b1;
                aluOp = 5'd0;
                memRead = 1'b1;
                id_uses_rs1 = 1'b1;
            end

            // memory stores
            7'b0100011: begin
                regWrite = 1'b0;
                immType = 3'b001;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b1;
                aluOp = 5'd0;
                memWrite = 1'b1;
                id_uses_rs1 = 1'b1;
                id_uses_rs2 = 1'b1;
            end

            // conditional branches
            7'b1100011: begin
                regWrite = 1'b0;
                immType = 3'b010;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b0;
                aluOp = 5'd1;
                branch = 1'b1;
                id_uses_rs1 = 1'b1;
                id_uses_rs2 = 1'b1;
            end

            // lui
            7'b0110111: begin
                regWrite = 1'b1;
                immType = 3'b011;
                regfile_data_src = 1'b0;
                aluOp = 5'd0;
                aluSrcB = 1'b1;
                aluSrcA = 1'b0;
                lui_instr = 1'b1;
            end

            // auipc
            7'b0010111: begin
                regWrite = 1'b1;
                immType = 3'b011;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b1;
                aluSrcB = 1'b1;
                aluOp = 5'd0;
            end

            // jal
            7'b1101111: begin
                regWrite = 1'b1;
                immType = 3'b100;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b0;
                aluOp = 5'd0;
                jump = 1'b1;
            end

            // jalr
            7'b1100111: begin
                regWrite = 1'b1;
                immType = 3'b000;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b1;
                aluOp = 5'd0;
                jump = 1'b1;
                is_jalr = 1'b1;
                id_uses_rs1 = 1'b1;
            end

            default: begin
                regWrite = 1'b1;
                immType = 3'b000;
                regfile_data_src = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 1'b0;
                id_uses_rs1 = 1'b1;
                id_uses_rs2 = 1'b1;
            end
        endcase
    end

endmodule