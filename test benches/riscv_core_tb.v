`timescale 1ns/1ps

module riscv_core_tb;

    reg clk;
    reg reset;
    integer cycle;
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
        cycle = 0;

        repeat(2) @(posedge clk);
        #1;
        reset = 0;
    end

    always @(posedge clk) begin
        if(!reset) begin

            #1;

            $display("\n========================================================================");
            $display("Cycle %0d", cycle);
            $display("========================================================================");

            $display("PC          : %08h", dut.if_s.if_pc_current);
            $display("Instruction : %08h", dut.if_s.if_instruction);

            $display("\nRegister File");
            $display("------------------------------------------------------------");
            $display("x1  = %08h", dut.id_s.reg_file.reg_file[1]);
            $display("x2  = %08h", dut.id_s.reg_file.reg_file[2]);
            $display("x10 = %08h", dut.id_s.reg_file.reg_file[10]);
            $display("x11 = %08h", dut.id_s.reg_file.reg_file[11]);

            // if(dut.we && (dut.wa != 0)) begin
            //     $display("\nWrite Back");
            //     $display("------------------------------------------------------------");
            //     // $display("Destination Register : x%0d", dut.wa);
            //     // $display("Data Written         : %08h", dut.w_data);
            // end
            // else begin
            //     $display("\nNo Register Write");
            // end

            cycle = cycle + 1;

        end
    end

    initial begin

        @(negedge reset);

        // Wait until the program reaches the infinite loop
        wait(dut.if_s.if_pc_current == 32'h0000002C);

        // Wait one extra cycle for final writeback
        @(posedge clk);
        #1;

        $display("\n\n");
        $display("====================================================================");
        $display("                    PROGRAM EXECUTION COMPLETE");
        $display("====================================================================");

        $display("\nFinal Register File");
        $display("--------------------------------------------------------------------");

        for(i=0;i<32;i=i+1)
            $display("x%-2d = %08h", i, dut.id_s.reg_file.reg_file[i]);

        $display("\nFirst 8 Data Memory Locations");
        $display("--------------------------------------------------------------------");

        // for(i=0;i<8;i=i+1)
        //     $display("mem[%0d] = %08h", i, dut.dmem.dmem[i]);

        $display("\n====================================================================");

        if(dut.id_s.reg_file.reg_file[11] == 32'd120) begin
            $display("                         TEST PASSED");
            $display("                  Factorial(5) = %0d", dut.id_s.reg_file.reg_file[11]);
        end
        else begin
            $display("                         TEST FAILED");
            $display("Expected Result : 120");
            $display("Obtained Result : %0d", dut.id_s.reg_file.reg_file[11]);
        end

        $display("====================================================================");

        $finish;

    end

endmodule