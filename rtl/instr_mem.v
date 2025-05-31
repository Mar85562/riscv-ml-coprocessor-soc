module instr_mem(
    input [31:0] addr,
    output [31:0] instruction
    );
    
    // Making the memory
    
    reg [31:0] memory [0:63]; // 64 registers that are each 32-bits wide
    
    assign instruction = memory[addr[7:2]]; // assign the output with the value placed at specified address in memory - This is a word-aligned address that ignores lower 2 bits of byte address
    
    integer i;
    
    initial begin
    
        for (i = 0; i < 64; i = i + 1) 
            memory[i] <= 32'h00000000;
            
        // Preload dummy instructions for testing
        memory[0] <= 32'h12345678;
        memory[1] <= 32'hdeadbeef;
        memory[2] <= 32'hcafebabe;
        memory[3] <= 32'h0badcafe;
            
    end 
    
    
endmodule