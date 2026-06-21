`timescale 1ns / 1ps

module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
    );

    reg [31:0] imem[0:1023];
    integer i;
    initial begin
        for(i=0; i<1024; i=i+1) begin
            imem[i] = 32'h00000013; // NOP addi x0, x0, 0
        end
        $readmemh("C:/Users/yashd/Downloads/var2matmult.hex", imem);
    end

    always @(*) begin
        if((address[1:0] == 0) && (address[31:2] < 1024)) begin
            instruction = imem[address[31:2]];
        end
        else begin
            instruction = 32'h00000013;
        end

    end

endmodule
