`timescale 1ns/1ps

module control_tb;

    // Inputs
    logic [6:0] opcode;

    // Outputs
    logic [1:0] alu_op;
    logic reg_write, mem_read, mem_write, alu_src, mem_to_reg, branch;

    // DUT instantiation
    control dut (
        .opcode(opcode),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch)
    );

    // Test task
    task print_result(string instr_name, logic [1:0] exp_alu_op, logic exp_reg_write,
                      logic exp_mem_read, logic exp_mem_write, logic exp_alu_src,
                      logic exp_mem_to_reg, logic exp_branch);
        $display("Test: %-6s | opcode = %07b", instr_name, opcode);
        $display(" ALUOp = %02b (%02b)", alu_op, exp_alu_op);
        $display(" RegWrite = %b (%b), MemRead = %b (%b), MemWrite = %b (%b)",
                  reg_write, exp_reg_write, mem_read, exp_mem_read, mem_write, exp_mem_write);
        $display(" ALUSrc = %b (%b), MemToReg = %b (%b), Branch = %b (%b)\n",
                  alu_src, exp_alu_src, mem_to_reg, exp_mem_to_reg, branch, exp_branch);

        if (alu_op      !== exp_alu_op     || reg_write !== exp_reg_write ||
            mem_read    !== exp_mem_read   || mem_write !== exp_mem_write ||
            alu_src     !== exp_alu_src    || mem_to_reg !== exp_mem_to_reg ||
            branch      !== exp_branch)
            $error("❌ Mismatch in test: %s", instr_name);
        else
            $display("✅ PASS\n");
    endtask

    initial begin
        $dumpfile("control.vcd");
        $dumpvars(0, control_tb);
        
        // R-type: opcode = 0110011
        opcode = 7'b0110011; #10;
        print_result("R-type", 2'b10, 1, 0, 0, 0, 0, 0);

        // I-type: opcode = 0010011
        opcode = 7'b0010011; #10;
        print_result("I-type", 2'b10, 1, 0, 0, 1, 0, 0);

        // Load (LW): opcode = 0000011
        opcode = 7'b0000011; #10;
        print_result("LW",     2'b00, 1, 1, 0, 1, 1, 0);

        // Store (SW): opcode = 0100011
        opcode = 7'b0100011; #10;
        print_result("SW",     2'b00, 0, 0, 1, 1, 0, 0);

        // Branch (BEQ): opcode = 1100011
        opcode = 7'b1100011; #10;
        print_result("BEQ",    2'b01, 0, 0, 0, 0, 0, 1);

        // Unknown (NOP)
        opcode = 7'b1111111; #10;
        print_result("NOP",    2'b00, 0, 0, 0, 0, 0, 0);

        $display("✅ Control Unit testing complete.");
        $finish;
    end

endmodule

