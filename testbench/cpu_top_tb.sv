`timescale 1ns / 1ps

module cpu_top_tb;

    logic clk, rst;

    cpu_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // VCD for waveform
    initial begin
        $dumpfile("cpu_top.vcd");
        $dumpvars(0, cpu_top_tb);
    end

    // Utility: register dump
    task print_regs;
        $display(
            "x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d x9=%0d x10=%0d | mem[5]=%0d",
            dut.regfile_inst.regs[1],
            dut.regfile_inst.regs[2],
            dut.regfile_inst.regs[3],
            dut.regfile_inst.regs[4],
            dut.regfile_inst.regs[5],
            dut.regfile_inst.regs[6],
            dut.regfile_inst.regs[7],
            dut.regfile_inst.regs[8],
            dut.regfile_inst.regs[9],
            dut.regfile_inst.regs[10],
            dut.data_mem_inst.memory[5]
        );
    endtask

    // Utility: branch debug print
    task print_branch_debug;
        $display("=== BRANCH DEBUG ===");
        $display("  rs1_data       = %0d", dut.rs1_data);
        $display("  rs2_data       = %0d", dut.rs2_data);
        $display("  ALU result     = %0d", dut.alu_result);
        $display("  Zero flag      = %0d", dut.zero);
        $display("  Branch         = %0d", dut.branch);
        $display("  is_branch_taken= %0d", dut.branch && dut.zero);
        $display("====================");
    endtask

    // Simulation control
    initial begin
        clk = 0;
        rst = 1;
        $display("\n=== CPU Full Test Start ===");
        #10 rst = 0;

        repeat (40) begin
            @(posedge clk);
            $display("\nCycle @ PC=%0d | Instr = %h", dut.pc_inst.pc_out, dut.instruction);
            print_regs();
            print_branch_debug();
        end

        $display("\n=== CPU Full Test End ===");

        // Optional: pass/fail check
        if (dut.regfile_inst.regs[10] == 10) begin
            $display("TEST PASS ✅");
        end else begin
            $display("TEST FAIL ❌");
        end

        $finish;
    end

endmodule
