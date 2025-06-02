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
            
        // Preload dummy instructions for testing
        instr_memory[0]  = 32'h00500093; // addi x1, x0, 5
        instr_memory[1]  = 32'h00A00113; // addi x2, x0, 10
        instr_memory[2]  = 32'h002081B3; // add  x3, x1, x2
        instr_memory[3]  = 32'h40110233; // sub  x4, x2, x1
        instr_memory[4]  = 32'h0020A2B3; // and  x5, x1, x2
        instr_memory[5]  = 32'h0020B333; // or   x6, x1, x2
        instr_memory[6]  = 32'h0020C3B3; // xor  x7, x1, x2
        instr_memory[7]  = 32'h0070A023; // sw   x7, 0(x1)
        instr_memory[8]  = 32'h0000A403; // lw   x8, 0(x1)
        instr_memory[9]  = 32'h00408663; // beq  x1, x4, +8
        instr_memory[10] = 32'h06300493; // addi x9, x0, 99
        instr_memory[11] = 32'h0010A533; // add  x10, x1, x1
            
    end 
//    always @(*) begin
//        $display("Instruction Fetch: addr = %h, index = %0d, instr = %h", addr, addr[7:2], instr_memory[addr[7:2]]);
//    end

    
endmodule
