`timescale 1ns / 1ps


module instr_mem_tb;

    reg [31:0] addr;
    wire [31:0] instruction;
    
    instr_mem uut (
        .addr(addr),
        .instruction(instruction)
    );
    
    initial begin
        $display("Testing instruction memory...");
        
        //Initial values
        addr = 0;
        
        
        // Test memory access
        addr = 32'd0; #10;
        $display("Address 0: %h", instruction);
        
        addr = 32'd4; #10;
        $display("Address 4: %h", instruction);
        
        addr = 32'd8; #10;
        $display("Address 8: %h", instruction);
        
        addr = 32'd12; #10;
        $display("Address 12: %h", instruction);
        
        #20 $finish;
    end

endmodule