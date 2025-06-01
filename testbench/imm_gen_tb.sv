`timescale 1ns / 1ps

module imm_gen_tb;

    // Inputs and outputs
    logic [31:0] instr;
    logic [31:0] imm_out;
    
    imm_gen uut (
        .instr(instr),
        .imm_out(imm_out)
    );
    
    // Task to test and display results clearly
    task test_imm(string name, logic [31:0] i);
        instr = i;
        #1; // wait for 1 ns for result to settle
        $display("%s -> instr = 0x%8h | imm_out = 0x%8h", name, instr, imm_out);
    endtask
    
    initial begin
        $display("---- Immediate Generator Test ----");

        // I-Type (ADDI)
        test_imm("I-ADDI", 32'b000000000101_00000_000_00001_0010011);

        // I-Type (LW)
        test_imm("I-LW",   32'b000000000100_00000_010_00010_0000011);

        // S-Type (SW)
        test_imm("S-SW",   32'b0000001_00011_00010_010_00000_0100011);

        // B-Type (BEQ)
        test_imm("B-BEQ",  32'b0000000_00001_00010_000_00000_1100011);

        // U-Type (LUI)
        test_imm("U-LUI",  32'b00000000000000000001_00000_0110111);

        // U-Type (AUIPC)
        test_imm("U-AUIPC",32'b00000000000000000010_00000_0010111);

        // J-Type (JAL)
        test_imm("J-JAL",  32'b000000000001_00000000_00000_1101111);

        $display("---- Done ----");
        $finish;
    end

endmodule
