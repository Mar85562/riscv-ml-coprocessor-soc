`timescale 1ns/1ps
module pc_tb;

    reg clk, rst, pc_write_en;
    reg [31:0] pc_next;
    wire [31:0] pc_out;

    // DUT instantiation
    pc uut (
        .clk(clk),
        .rst(rst),
        .pc_write_en(pc_write_en),
        .pc_next(pc_next),
        .pc_out(pc_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("pc.vcd");
        $dumpvars(0, pc_tb);
        
        // Initialize signals
        clk = 0;
        rst = 1;
        pc_write_en = 0;
        pc_next = 32'd0;

        #10;  // Apply reset
        rst = 0;

        // Write new PC values
        pc_write_en = 1; pc_next = 32'h00000004;
        #10;
        pc_next = 32'h00000008;
        #10;

        // Disable write, check hold
        pc_write_en = 0; pc_next = 32'hDEADBEEF;
        #10;

        // Finish simulation
        $finish;
    end

endmodule

