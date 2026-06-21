`timescale 1ns / 1ps

module hazard_detection_unit(
    input [31:0] if_id_instruction,
    input [4:0] id_ex_rd,
    input id_ex_memRead,
    input ex_flush,
    input id_uses_rs1, id_uses_rs2,
    output reg if_id_flush,
    output reg if_id_write_en,
    output reg id_ex_flush,
    output reg id_ex_write_en,
    output reg pc_write_en
    );

    wire [4:0] if_rs1 = if_id_instruction[19:15];
    wire [4:0] if_rs2 = if_id_instruction[24:20]; 
    always @(*) begin
        if(ex_flush) begin
            if_id_write_en = 1'b1;
            if_id_flush = 1'b1;
            id_ex_write_en = 1'b1;
            id_ex_flush = 1'b1;
            pc_write_en = 1'b1;
        end
        else if (id_ex_memRead && (id_ex_rd != 5'd0) && ((id_uses_rs1 && (if_rs1 != 5'd0) && (if_rs1 == id_ex_rd)) ||
        (id_uses_rs2 && (if_rs2 != 5'd0) && (if_rs2 == id_ex_rd)))) begin
            if_id_write_en = 1'b0;
            if_id_flush = 1'b0;
            id_ex_write_en = 1'b1;
            id_ex_flush = 1'b1;
            pc_write_en = 1'b0;
        end
        else begin
            if_id_write_en = 1'b1;
            if_id_flush = 1'b0;
            id_ex_write_en = 1'b1;
            id_ex_flush = 1'b0;
            pc_write_en = 1'b1;
        end
    end
endmodule
