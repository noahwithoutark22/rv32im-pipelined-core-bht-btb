`timescale 1ns / 1ps

module pc(
    input [31:0] pc_in,
    input clk,
    input pc_write_en,
    input reset,
    output reg [31:0] pc_out
    );

    always @(posedge clk or posedge reset) begin
        if(reset)
            pc_out <= 0;
        else 
        if(pc_write_en)
            pc_out <= pc_in;
    end
endmodule
