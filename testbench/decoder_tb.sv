`timescale 1ns / 1ps

module decoder_tb;

    // Inputs
    logic [31:0] instr;

    // Outputs
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    // Instantiate the Unit Under Test (UUT)
    decoder uut (
        .instr(instr),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );

    initial begin
        $display("=== Decoder Testbench ===");

        // Optional VCD dump
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_tb);

        // R-type: add x1, x2, x3 => 0x006100b3
        instr = 32'h006100b3;
        #10;
        $display("R-type: opcode=%b, rd=%0d, rs1=%0d, rs2=%0d, funct3=%b, funct7=%b",
                 opcode, rd, rs1, rs2, funct3, funct7);

        // I-type: addi x1, x2, 5 => 0x00510093
        instr = 32'h00510093;
        #10;
        $display("I-type: opcode=%b, rd=%0d, rs1=%0d, funct3=%b",
                 opcode, rd, rs1, funct3);

        // S-type: sw x3, 0(x2) => 0x00312023
        instr = 32'h00312023;
        #10;
        $display("S-type: opcode=%b, rs1=%0d, rs2=%0d, funct3=%b",
                 opcode, rs1, rs2, funct3);

        // B-type: beq x1, x2, 8 => 0x00208663
        instr = 32'h00208663;
        #10;
        $display("B-type: opcode=%b, rs1=%0d, rs2=%0d, funct3=%b",
                 opcode, rs1, rs2, funct3);

        // U-type: lui x1, 0x12345 => 0x12345037
        instr = 32'h12345037;
        #10;
        $display("U-type: opcode=%b, rd=%0d", opcode, rd);

        // J-type: jal x1, 0x20 => 0x0200006f
        instr = 32'h0200006f;
        #10;
        $display("J-type: opcode=%b, rd=%0d", opcode, rd);

        $finish;
    end

endmodule
