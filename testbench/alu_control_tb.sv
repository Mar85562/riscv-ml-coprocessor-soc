`timescale 1ns / 1ps

module alu_control_tb;

    // DUT inputs
    logic [1:0] alu_op;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // DUT output
    logic [3:0] alu_control;

    // Instantiate the DUT
    alu_control dut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );
    // Task to check and print results
    task print_result(
        input string desc,
        input [3:0] expected
    );
        $display("Test: %-20s | alu_op=%02b funct3=%03b funct7=%07b | alu_control = %04b | expected = %04b",
                 desc, alu_op, funct3, funct7, alu_control, expected);
        if (alu_control !== expected)
            $error("❌ MISMATCH in '%s'", desc);
        else
            $display("✅ PASS\n");
    endtask

    initial begin
        $dumpfile("alu_control_tb.vcd");
        $dumpvars(0, alu_control_tb);
        
        // --- ALUOp = 00 (Load/Store) -> Always ADD
        alu_op = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        print_result("Load/Store ADD", 4'b0010);

        // --- ALUOp = 01 (Branch) -> Always SUB
        alu_op = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        print_result("Branch SUB", 4'b0110);

        // --- ALUOp = 10 (R-type)
        alu_op = 2'b10;

        // ADD (funct7 = 0000000)
        funct3 = 3'b000; funct7 = 7'b0000000; #10;
        print_result("ADD", 4'b0010);

        // SUB (funct7 = 0100000)
        funct3 = 3'b000; funct7 = 7'b0100000; #10;
        print_result("SUB", 4'b0110);

        // AND
        funct3 = 3'b111; funct7 = 7'b0000000; #10;
        print_result("AND", 4'b0000);

        // OR
        funct3 = 3'b110; funct7 = 7'b0000000; #10;
        print_result("OR", 4'b0001);

        // XOR
        funct3 = 3'b100; funct7 = 7'b0000000; #10;
        print_result("XOR", 4'b1001);

        // SLT
        funct3 = 3'b010; funct7 = 7'b0000000; #10;
        print_result("SLT", 4'b0111);

        // SLTU
        funct3 = 3'b011; funct7 = 7'b0000000; #10;
        print_result("SLTU", 4'b1000);

        // SLL
        funct3 = 3'b001; funct7 = 7'b0000000; #10;
        print_result("SLL", 4'b1010);

        // SRL
        funct3 = 3'b101; funct7 = 7'b0000000; #10;
        print_result("SRL", 4'b1011);

        // SRA
        funct3 = 3'b101; funct7 = 7'b0100000; #10;
        print_result("SRA", 4'b1100);

        $display("✅ ALU Control Unit test completed.");
        $finish;
    end

endmodule
