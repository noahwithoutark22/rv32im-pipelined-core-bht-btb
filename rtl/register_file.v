`timescale 1ns / 1ps


module register_file(
    input [4:0] ra1, ra2, wa,
    input we,
    input [31:0] w_data,
    input clk,
    input reset,
    output [31:0] rd1, rd2
    );

    reg [31:0] reg_file[0:31];
    integer i;

    always @(negedge clk) begin
        if(reset) begin
            for(i=0; i<32; i=i + 1) begin
                reg_file[i] <= 0;
            end
        end
        else if(we && wa!=0) begin
            reg_file[wa] <= w_data;

            $display("Time = %t Writing %h to x%d", $time, w_data, wa);
        end
    end

    assign rd1 = (ra1 == 0) ? 32'b0 : reg_file[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : reg_file[ra2];
endmodule
