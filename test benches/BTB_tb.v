`timescale 1ns/1ps

module BTB_tb;

reg clk;
reg reset;

reg [31:0] f_pc;
wire hit;
wire [31:0] f_target_address;
wire f_is_jump;

reg updatebtb_en;
reg [31:0] ex_pc;
reg [31:0] ex_branch_target;
reg ex_is_jump;

BTB dut(
    .clk(clk),
    .reset(reset),

    .f_pc(f_pc),
    .hit(hit),
    .f_target_address(f_target_address),
    .f_is_jump(f_is_jump),

    .updatebtb_en(updatebtb_en),
    .ex_pc(ex_pc),
    .ex_branch_target(ex_branch_target),
    .ex_is_jump(ex_is_jump)
);

always #5 clk = ~clk;

integer errors;

task check;
input exp_hit;
input [31:0] exp_target;
input exp_jump;
begin
    #1;
    if(hit !== exp_hit) begin
        $display("FAIL : Hit mismatch");
        errors = errors + 1;
    end

    if(exp_hit) begin
        if(f_target_address !== exp_target) begin
            $display("FAIL : Target mismatch");
            errors = errors + 1;
        end

        if(f_is_jump !== exp_jump) begin
            $display("FAIL : Jump bit mismatch");
            errors = errors + 1;
        end
    end
end
endtask

initial begin

    clk = 0;
    reset = 1;
    errors = 0;

    f_pc = 0;
    updatebtb_en = 0;
    ex_pc = 0;
    ex_branch_target = 0;
    ex_is_jump = 0;

    #20;
    reset = 0;

    //--------------------------------------------------------
    // Test 1 : Empty BTB
    //--------------------------------------------------------
    f_pc = 32'h00000020;
    check(0,32'd0,0);

    //--------------------------------------------------------
    // Test 2 : Insert branch
    //--------------------------------------------------------
    @(posedge clk);

    updatebtb_en = 1;
    ex_pc = 32'h00000020;
    ex_branch_target = 32'h00000080;
    ex_is_jump = 0;

    @(posedge clk);
    updatebtb_en = 0;

    f_pc = 32'h00000020;
    check(1,32'h00000080,0);

    //--------------------------------------------------------
    // Test 3 : Insert jump
    //--------------------------------------------------------
    @(posedge clk);

    updatebtb_en = 1;
    ex_pc = 32'h00000040;
    ex_branch_target = 32'h00000100;
    ex_is_jump = 1;

    @(posedge clk);
    updatebtb_en = 0;

    f_pc = 32'h00000040;
    check(1,32'h00000100,1);

    //--------------------------------------------------------
    // Test 4 : Tag mismatch
    //--------------------------------------------------------
    f_pc = 32'h10000040;
    check(0,32'd0,0);

    //--------------------------------------------------------
    // Test 5 : Overwrite same entry
    //--------------------------------------------------------
    @(posedge clk);

    updatebtb_en = 1;
    ex_pc = 32'h00000020;
    ex_branch_target = 32'h00000200;
    ex_is_jump = 1;

    @(posedge clk);
    updatebtb_en = 0;

    f_pc = 32'h00000020;
    check(1,32'h00000200,1);

    //--------------------------------------------------------
    // Test 6 : Same index, different tag
    //--------------------------------------------------------
    @(posedge clk);

    updatebtb_en = 1;
    ex_pc = 32'h10000020;      // same index [7:2]
    ex_branch_target = 32'h00000300;
    ex_is_jump = 0;

    @(posedge clk);
    updatebtb_en = 0;

    f_pc = 32'h00000020;
    check(0,32'd0,0);

    f_pc = 32'h10000020;
    check(1,32'h00000300,0);

    //--------------------------------------------------------
  if(errors==0) begin
        $display("\n=================================");
        $display("      ALL BTB TESTS PASSED");
        $display("=================================\n");
  end
    else begin
        $display("\n=================================");
        $display("      BTB TEST FAILED");
        $display("Errors = %0d",errors);
        $display("=================================\n");
    end

    $finish;

end

endmodule