`timescale 1ns / 1ps

module BHT64Entry(
    input clk,
    input reset,

    input [31:0] current_pc, // From IF
    output predict_taken,

    // For EX
    input updatebht_en, // updates the bht row
    input [31:0] new_pc, // New PC from ex stage
    input update_taken // This creates a update counter

    );

    reg [1:0] bht64 [0:63];

    assign predict_taken = bht64[current_pc[7:2]][1];

    reg [1:0] old_cntr, new_cntr;

    always @(*) begin
        old_cntr = bht64[new_pc[7:2]];
        case(old_cntr)
            2'b00: new_cntr = update_taken? 2'b01 : 2'b00;
            2'b01: new_cntr = update_taken? 2'b10 : 2'b00;
            2'b10: new_cntr = update_taken? 2'b11 : 2'b01;
            2'b11: new_cntr = update_taken? 2'b11 : 2'b10;
            default: new_cntr = 2'b01;
        endcase
    end
    integer i;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for(i=0;i<64;i=i+1)begin
                bht64[i] <= 2'b01;
            end
        end
        else if(updatebht_en) begin
            bht64[new_pc[7:2]] <= new_cntr;
        end
    end


endmodule
