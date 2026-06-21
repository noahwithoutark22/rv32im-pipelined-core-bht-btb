`timescale 1ns/1ps

module riscv_core_matmult_tb;

reg clk;
reg reset;

integer i;

riscv_core dut(
    .clk(clk),
    .reset(reset)
);


initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    #20;
    reset = 0;
end

initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0,riscv_core_matmult_tb);
end

initial begin
    #6000000;

    $display("----- Matrix C -----");

    for(i=18;i<27;i=i+1)
        $display("%d : %d", i, dut.mem_s.dmem.dmem[i]);

    $finish;
end
initial begin

    // Wait long enough for program to finish
    #5000000;

    $display("---------------------------------------");
    $display("Matrix C Stored in Data Memory");
    $display("---------------------------------------");

    for(i=18;i<27;i=i+1)
    begin
        $display("MEM[%0d] = %0d",
                 i,
                 dut.mem_s.dmem.dmem[i]);
    end

    $display("---------------------------------------");

    if(dut.mem_s.dmem.dmem[18]==30 &&
       dut.mem_s.dmem.dmem[19]==24 &&
       dut.mem_s.dmem.dmem[20]==18 &&
       dut.mem_s.dmem.dmem[21]==84 &&
       dut.mem_s.dmem.dmem[22]==69 &&
       dut.mem_s.dmem.dmem[23]==54 &&
       dut.mem_s.dmem.dmem[24]==138 &&
       dut.mem_s.dmem.dmem[25]==114 &&
       dut.mem_s.dmem.dmem[26]==90)
    begin
        $display("TEST PASSED");
    end
    else
    begin
        $display("TEST FAILED");
    end

    $finish;

end

endmodule