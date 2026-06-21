`timescale 1ns/1ps

module BHT64Entry_tb;

reg clk;
reg reset;

reg [31:0] current_pc;
wire predict_taken;

reg updatebht_en;
reg [31:0] new_pc;
reg update_taken;

integer errors;

BHT64Entry dut(
    .clk(clk),
    .reset(reset),
    .current_pc(current_pc),
    .predict_taken(predict_taken),
    .updatebht_en(updatebht_en),
    .new_pc(new_pc),
    .update_taken(update_taken)
);

always #5 clk = ~clk;

//------------------------------------------------------
// Update one BHT entry
//------------------------------------------------------
task update_entry;
input [31:0] pc;
input taken;
begin
    @(negedge clk);
    new_pc = pc;
    update_taken = taken;
    updatebht_en = 1;

    @(posedge clk);
    #1;
    updatebht_en = 0;
end
endtask

//------------------------------------------------------
// Check prediction
//------------------------------------------------------
task check_prediction;
input [31:0] pc;
input expected;
begin
    current_pc = pc;
    #1;

    if(predict_taken !== expected) begin
        $display("FAIL @ %0t : PC=%h Expected=%b Got=%b",
                 $time, pc, expected, predict_taken);
        errors = errors + 1;
    end
    else begin
        $display("PASS @ %0t : PC=%h Prediction=%b",
                 $time, pc, predict_taken);
    end
end
endtask

initial begin

    clk = 0;
    reset = 1;

    current_pc = 0;
    new_pc = 0;
    updatebht_en = 0;
    update_taken = 0;

    errors = 0;

    //---------------- Reset ----------------
    #20;
    reset = 0;
    #2;

    //---------------- Initial state = 01 ----------------
    check_prediction(32'h20,0);

    //---------------- 01 -> 10 ----------------
    update_entry(32'h20,1);
    check_prediction(32'h20,1);

    //---------------- 10 -> 11 ----------------
    update_entry(32'h20,1);
    check_prediction(32'h20,1);

    //---------------- 11 -> 11 ----------------
    update_entry(32'h20,1);
    check_prediction(32'h20,1);

    //---------------- 11 -> 10 ----------------
    update_entry(32'h20,0);
    check_prediction(32'h20,1);

    //---------------- 10 -> 01 ----------------
    update_entry(32'h20,0);
    check_prediction(32'h20,0);

    //---------------- 01 -> 00 ----------------
    update_entry(32'h20,0);
    check_prediction(32'h20,0);

    //---------------- 00 -> 00 ----------------
    update_entry(32'h20,0);
    check_prediction(32'h20,0);

    //---------------- Independent entry ----------------
    check_prediction(32'h40,0);

    if(errors==0) begin
        $display("");
        $display("======================================");
        $display("      ALL BHT TESTS PASSED");
        $display("======================================");
    end
    else begin
        $display("");
        $display("======================================");
        $display("      BHT TEST FAILED");
        $display("Errors = %0d", errors);
        $display("======================================");
    end

    $finish;

end

endmodule