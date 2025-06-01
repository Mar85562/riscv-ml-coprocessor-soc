`timescale 1ns / 1ps

module regfile_tb;

    // Inputs to regfile
    reg clk;
    reg w_enable;
    reg [4:0] rs1_addr;
    reg [4:0] rs2_addr;
    reg [4:0] rd_addr;
    reg [31:0] rd_data;
    
    // Outputs from regfile
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    
    regfile uut (
        .clk(clk),
        .w_enable(w_enable),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns clock period
    
    initial begin
       $dumpfile("regfile.vcd");
       $dumpvars(0, regfile_tb);
        
        clk = 0;
        w_enable = 0;
        rd_addr = 0;
        rd_data = 0;
        rs1_addr = 0;
        rs2_addr = 0;
        
        #10; // Wait for global reset
        
        //Write 0xDEADBEEF to x3
        w_enable = 1;
        rd_addr = 5'd3;
        rd_data = 32'hDEADBEEF;
        #10; // wait for posedge clk
        
        //Disable write
        w_enable = 0;
        
        // Set read addresses to x3 and x0
        rs1_addr = 5'd3;
        rs2_addr = 5'd0;
        
        #10;
        
        // Write another value to x10
        w_enable = 1;
        rd_addr = 5'd10;
        rd_data = 32'h12345678;
        #10;
        
        w_enable = 0;
        
        rs1_addr = 5'd10;
        rs2_addr = 5'd3;
        
        #20;
        
        $finish;
        
     end
    
    
endmodule