`timescale 1ns /1ps

/*
The following is the first full test I made for the CPU, it tests each datapath component individually.
It has steps testing each component with the expected results. Its corresponding instructions are also
commented out in instr_mem.v. Below it is a realistic program flow that was done after each component
was successfully tested.
*/

//module cpu_top_tb;

//    reg clk = 0;
//    reg rst = 1;
    
//    // Instantiate DUT
//    cpu_top dut (
//        .clk(clk),
//        .rst(rst)
//    );
    
//    // Clock generation 
//    always #5 clk = ~clk;
    
//    // VCD output
//    initial begin
//        $dumpfile("cpu_top.vcd");
//        $dumpvars(0, cpu_top_tb);
//    end
   
            
//    initial begin        
//        // Deassert reset
//        #10 rst = 0;
        
        
//        //STEP 1: Wait 3 instructions (addi, addi, add)
//         repeat (6) @(posedge clk); // Run 6 cycles = 3 instructions
         
//         // Checking the results
//         $display("\n=== STEP 1: ADDI + ADD TEST ===");
//         $display("x1 = %0d | expected = 5", dut.regfile_inst.regs[1]);
//         $display("x2 = %0d | expected = 10", dut.regfile_inst.regs[2]);
//         $display("x3 = %0d | expected = 15", dut.regfile_inst.regs[3]);
         
//         if (dut.regfile_inst.regs[1] == 5 && dut.regfile_inst.regs[2] == 10 && dut.regfile_inst.regs[3] == 15)
//            $display(" STEP 1 PASS\n");
//         else
//            $display(" STEP 2 FAIL\n");
            
//        // STEP 2: SUB, AND, OR, XOR (4 instructions)
//        repeat (8) @(posedge clk); // 4 instructions x 2 cycles = 8 cycles
        
//        $display("\n=== STEP 2: ALU Ops TEST ===");
//        $display("x4 (sub) = %0d | Expected = 5", dut.regfile_inst.regs[4]);
//        $display("x5 (and) = %0d | Expected = 0", dut.regfile_inst.regs[5]);
//        $display("x6 (or) = %0d | Expected = 15", dut.regfile_inst.regs[6]);
//        $display("x7 (xor) = %0d | Expected = 15", dut.regfile_inst.regs[7]);
        
//        if (dut.regfile_inst.regs[4] == 5 &&
//            dut.regfile_inst.regs[5] == 0 &&
//            dut.regfile_inst.regs[6] == 15 &&
//            dut.regfile_inst.regs[7] == 15)
//            $display(" STEP 2 PASS\n");
//        else
//            $display(" STEP 2 FAIL\n");
                                 
    
        
        
////         STEP 3: Memory Ops (SW, LW)
//        repeat (2) @(posedge clk); // 2 instructions
//        $display("\n== STEP 3: SW + LW TEST ===");
//        $display("x8     = %0d | expected = 15", dut.regfile_inst.regs[8]);
        
        
//        if (dut.regfile_inst.regs[8] == 15)
//            $display(" STEP 3 PASS \n");
//        else
//            $display(" STEP 3 FAIL \n");
        
//        // Step 4: BEQ Part 1: Branch NOT taken
//        repeat (6) @(posedge clk); // 3 instructions
        
//        $display("\n=== STEP 4.1: BEW Branch NOT Taken TEST ===");
//        $display("x1 = %0d", dut.regfile_inst.regs[1]);
//        $display("x2 = %0d", dut.regfile_inst.regs[2]);
//        $display("x9 = %0d | expected = 99", dut.regfile_inst.regs[9]);
//        $display("x10 = %0d | expected = 10", dut.regfile_inst.regs[10]);
        
//        if (dut.regfile_inst.regs[9] == 99 && dut.regfile_inst.regs[10] == 10)
//            $display(" STEP 4.1 PASS\n");
//        else
//            $display(" STEP 4.1 FAIL\n");
        
//        // Step 4: BEQ Part 2 Branch Taken
//        repeat (6) @(posedge clk); // 3 instructions
        
//        $display("\n === STEP 4.2: BEQ Branch Taken TEST ===");
//        $display("x1 = %0d", dut.regfile_inst.regs[1]);
//        $display("x11 = %0d | expected = 0/x (skipped)", dut.regfile_inst.regs[11]);
//        $display("x12 = %0d | expected = 77", dut.regfile_inst.regs[12]);
        
//        if (dut.regfile_inst.regs[12] == 77)
//            $display(" STEP 4.2 PASS\n");
//        else
//            $display(" STEP 4.2 FAIL\n");
       
        
//        $display("\n=== STEP 5: SLT / SLTU TEST ===");
//        $display("x13 (slt  x1 < x2)   = %0d | Expected = 1", dut.regfile_inst.regs[13]);
//        $display("x14 (slt  x2 < x1)   = %0d | Expected = 0", dut.regfile_inst.regs[14]);
//        $display("x15 (addi -1)        = %0d | Expected = -1 or 4294967295", dut.regfile_inst.regs[15]);
//        $display("x16 (addi +1)        = %0d | Expected = 1", dut.regfile_inst.regs[16]);
//        $display("x17 (sltu x15 < x16) = %0d | Expected = 0", dut.regfile_inst.regs[17]);
//        $display("x18 (sltu x16 < x15) = %0d | Expected = 1", dut.regfile_inst.regs[18]);
        
//        if (dut.regfile_inst.regs[13] == 1 &&
//            dut.regfile_inst.regs[14] == 0 &&
//            dut.regfile_inst.regs[16] == 1 &&
//            dut.regfile_inst.regs[17] == 0 &&
//            dut.regfile_inst.regs[18] == 1)
//            $display(" STEP 5 PASS \n");
//        else
//            $display(" STEP 5 FAIL \n");
        
//        $finish;
//    end
    

//endmodule

/*
Full Program with relistic instructions to test out whole CPU flow with the major datapath oprations:

addi x1, x0, 5       // x1 = 5
addi x2, x0, 10      // x2 = 10
add  x3, x1, x2      // x3 = 15
slt  x4, x1, x2      // x4 = 1
sltu x5, x2, x1      // x5 = 0
sw   x3, 0(x0)       // mem[0] = x3 = 15
lw   x6, 0(x0)       // x6 = mem[0] = 15
beq  x1, x1, +8      // branch to skip next addi
addi x7, x0, 99      // should be skipped
addi x8, x0, 42      // x8 = 42

| Reg | Expected Value | Reason                  |
| --- | -------------- | ----------------------- |
| x1  | 5              | addi                    |
| x2  | 10             | addi                    |
| x3  | 15             | add                     |
| x4  | 1              | slt (5 < 10)            |
| x5  | 0              | sltu (10 !< 5 unsigned) |
| x6  | 15             | loaded from mem\[0]     |
| x7  | *Don't Care*   | skipped by branch       |
| x8  | 42             | executed after branch   |

This program offers a short instruction flow that does a comprehensive test of the major operations
together. The data_mem is still part of the cpu in this test because we are assuming the SoC has
not been integrated yet. This testbench will remain the same even after integration because a new
soc_top_tb.sv file will be made to test out the integrated SoC after moving the data memory outside the
CPU. If for any reason an issue arises with the cpu the testbench will be changed to reflect the fact that
the data memory is now outside the CPU.
*/

module cpu_top_tb;

    reg clk = 0;
    reg rst = 1;
    
    // Instantiate DUT
    cpu_top dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock generation 
    always #5 clk = ~clk;
    
    // VCD output
    initial begin
        $dumpfile("cpu_top.vcd");
        $dumpvars(0, cpu_top_tb);
    end
   
            
    initial begin        
        // Deassert reset
        #10 rst = 0;
        
        // Final Program: 10 instructions = 20 cycles
        repeat (20) @(posedge clk);
        
        $display("\n=== FINAL FULL PROGRAM TEST ===");
        $display("x1 = %0d | Expected = 5", dut.regfile_inst.regs[1]);
        $display("x2 = %0d | Expected = 10", dut.regfile_inst.regs[2]);
        $display("x3 = %0d | Expected = 15", dut.regfile_inst.regs[3]);
        $display("x4 = %0d | Expected = 1", dut.regfile_inst.regs[4]);
        $display("x5 = %0d | Expected = 0", dut.regfile_inst.regs[5]);
        $display("x6 = %0d | Expected = 15", dut.regfile_inst.regs[6]);
        $display("x7 = %0d | Expected = x (skipped)", dut.regfile_inst.regs[7]);
        $display("x8 = %0d | Expected = 42", dut.regfile_inst.regs[8]);
        
        if (dut.regfile_inst.regs[1] == 5  &&
            dut.regfile_inst.regs[2] == 10 &&
            dut.regfile_inst.regs[3] == 15 &&
            dut.regfile_inst.regs[4] == 1  &&
            dut.regfile_inst.regs[5] == 0  &&
            dut.regfile_inst.regs[6] == 15 &&
            dut.regfile_inst.regs[8] == 42)
            $display(" FINAL PROGRAM PASS\n");
        else
            $display(" FINAL PROGRAM FAIL\n");
        
        $finish;
    end
    

endmodule