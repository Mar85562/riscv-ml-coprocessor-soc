`timescale 1ns / 1ps
module alu_tb;

    // Inputs
    logic [31:0] a, b;
    logic [3:0] alu_control;
    
    // Output
    logic [31:0] result;
    logic zero;
    
    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero)
    );
    
    // Creating a readable output
    task print_result(string op, logic [31:0] expected_result, logic expected_zero);
        $display("Operation: %-4s | a = %0h | b = %0h | result = %0h | zero = %0b", op, a, b, result, zero);
        if (result !== expected_result)
            $error("❌ MISMATCH: Expected result = %0d", expected_result);
        if (zero !== expected_zero)
            $error("❌ MISMATCH: Expected zero = %0b", expected_zero);
        else
            $display("✅ PASS");
        $display("---");
    endtask
    
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);

        // AND: 0xF0F0F0F0 & 0x0F0F0F0F = 0
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_control = 4'b0000; #10;
        print_result("AND", 32'h00000000, 1);

        // OR: a | b = FFFFFFFF
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; alu_control = 4'b0001; #10;
        print_result("OR", 32'hFFFFFFFF, 0);

        // ADD: 10 + 5 = 15
        a = 10; b = 5; alu_control = 4'b0010; #10;
        print_result("ADD", 15, 0);

        // SUB: 10 - 10 = 0
        a = 10; b = 10; alu_control = 4'b0110; #10;
        print_result("SUB", 0, 1);

        // SLT: -1 < 5 → 1
        a = -1; b = 5; alu_control = 4'b0111; #10;
        print_result("SLT", 1, 0);

        // SLTU: 5 < 10 → 1
        a = 5; b = 10; alu_control = 4'b1000; #10;
        print_result("SLTU", 1, 0);

        // XOR: 0xAAAA5555 ^ 0x12345678
        a = 32'hAAAA5555; b = 32'h12345678; alu_control = 4'b1001; #10;
        print_result("XOR", a ^ b, ((a ^ b) == 0));

        // SLL: 1 << 4 = 16
        a = 32'd1; b = 32'd4; alu_control = 4'b1010; #10;
        print_result("SLL", 32'd16, 0);

        // SRL: 16 >> 2 = 4
        a = 32'd16; b = 32'd2; alu_control = 4'b1011; #10;
        print_result("SRL", 32'd4, 0);

        // SRA: -16 >>> 2 = -4 (signed arithmetic shift)
        a = -16; b = 32'd2; alu_control = 4'b1100; #10;
        print_result("SRA", -4, 0);

        $display("✅ ALU testing complete.");
        $finish;
    end

endmodule
