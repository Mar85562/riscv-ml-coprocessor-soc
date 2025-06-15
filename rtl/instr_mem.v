module instr_mem(
    input [31:0] addr,
    output [31:0] instruction
    );
    
    // Making the memory
    
    reg [31:0] instr_memory [0:63]; // 64 registers that are each 32-bits wide
    
    assign instruction = instr_memory[addr[7:2]]; // assign the output with the value placed at specified address in memory - This is a word-aligned address that ignores lower 2 bits of byte address
    
    integer i;
    
    initial begin
    
        for (i = 0; i < 64; i = i + 1) 
            instr_memory[i] = 32'h00000000;
            
        // Preload dummy instructions for testing the first version of the testbench
        /*
        instr_memory[0]  = 32'h00500093; // addi x1, x0, 5
        instr_memory[1]  = 32'h00A00113; // addi x2, x0, 10
        instr_memory[2]  = 32'h002081B3; // add  x3, x1, x2
        instr_memory[3]  = 32'h40110233; // sub  x4, x2, x1
        instr_memory[4]  = 32'h0020F2B3; // and  x5, x1, x2
        instr_memory[5]  = 32'h0020E333; // or   x6, x1, x2
        instr_memory[6]  = 32'h0020C3B3; // xor  x7, x1, x2
        instr_memory[7]  = 32'h0070A023; // sw   x7, 0(x1)
        instr_memory[8]  = 32'h0000A403; // lw   x8, 0(x1)
        instr_memory[9]  = 32'h00208463; // beq  x1, x2, 8
        instr_memory[10] = 32'h06300493; // addi x9, x0, 99
        instr_memory[11] = 32'h00108533; // add  x10, x1, x1
        instr_memory[12] = 32'h00108463; // beq x1, x1, 8
        instr_memory[13] = 32'h02a00593; // addi x11, x0, 42
        instr_memory[14] = 32'h04d00613; // addi x12, x0, 77
        instr_memory[15] = 32'h0020a6b3; // slt x13, x1, x2
        instr_memory[16] = 32'h00112733; // slt  x14, x2, x1
        instr_memory[17] = 32'hfff00793; // addi x15, x0, -1
        instr_memory[18] = 32'h00100813; // addi x16, x0, 1
        instr_memory[19] = 32'h0107b8b3; // sltu x17, x15, x16
        instr_memory[20] = 32'h00f83933; // sltu x18, x16, x15
        */
        
        ////////////////////////////////
        // The following are the instructions that do a comprehensive short test on the 
        // complete cpu datapath
        ///////////////////////////////
        
        instr_memory[0] = 32'h00500093; // addi x1, x0, 5
        instr_memory[1] = 32'h00a00113; // addi x2, x0, 10
        instr_memory[2] = 32'h002081b3; // add x3, x1, x2
        instr_memory[3] = 32'h0020a233; // slt x4, x1, x2
        instr_memory[4] = 32'h001132b3; // sltu x5, x2, x1
        instr_memory[5] = 32'h00302023; // sw x3, 0(x0)
        instr_memory[6] = 32'h00002303; // lw x6, 0(x0)
        instr_memory[7] = 32'h00108463; // beq x1, x1, 8
        instr_memory[8] = 32'h06300393; // addi x7, x0, 99
        instr_memory[9] = 32'h02a00413; // addi x8, x0, 42
            
    end 
//    always @(*) begin
//        $display("Instruction Fetch: addr = %h, index = %0d, instr = %h", addr, addr[7:2], instr_memory[addr[7:2]]);
//    end

    
endmodule
