module data_mem(
    input clk, // Clock Signal
    input mem_read, // Enable Signal for a read
    input mem_write, // Enable Signal for a write
    input [31:0] addr, // Address to read/write (word-aligned)
    input [31:0] write_data, // Data to write (Store)
    output reg [31:0] read_data // Data read (Load) 
    );
    
    // ---------------------------------
    // Memory Declaration
    // --------------------------------
    // 64 words = 256 bytes
    // Each word is 32 bits wide
    reg [31:0] memory [0:63];
    
    integer i;
    
    // -----------------------------------
    // Initialize Memory to zero
    // -----------------------------------
    initial begin
        for (i = 0; i < 64; i = i + 1)
            memory[i] = 32'b0;   // Clear Memory
    end
    
    //------------------------------------
    // Combinational Read Logic
    // -----------------------------------
    // Always update read_data with memory value at given address
    // Only Valid when mem_read = 1 
    always @(*) begin
        if (mem_read)
            read_data = memory[addr[7:2]]; // Word-aligned read
        else
            read_data = 32'b0;             // Default to zero
    end
    
    // ------------------------------------
    // Synchronous Write Logic
    // ------------------------------------
    // Write occurs only when mem_write = 1, on the positive clock edge
    always @(posedge clk) begin
        if (mem_write)
            memory[addr[7:2]] <= write_data; // Store data
    end
    
    
    
endmodule