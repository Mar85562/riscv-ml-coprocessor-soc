`timescale 1ns / 1ps

module ml_accel_tb;

    reg clk = 0;
    reg rst = 1;
    
    reg [5:0] addr;
    reg [31:0] w_data;
    reg w_en;
    reg r_en;
    wire [31:0] r_data;
    
     ml_accel uut (
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .w_data(w_data),
        .w_en(w_en),
        .r_en(r_en),
        .r_data(r_data)
    );
    
    always #5 clk = ~clk;
    
    // Utility task to write to accelerator
    task mm_write(input [31:0] address, input [31:0] data);
        begin
            @(posedge clk);
            addr = address;
            w_data = data;
            w_en = 1'b1;
            r_en = 1'b0;
            @(posedge clk);
            w_en = 1'b0;
        end
    endtask
    
    // Utility task to read from accelerator
    task mm_read(input [31:0] address);
        begin
            @(posedge clk);
            addr = address;
            w_en = 1'b0;
            r_en = 1'b1;
            @(posedge clk);
            r_en = 1'b0;
        end
    endtask
    
    initial begin
        $display("=== ML Accelerator Testbench ===");
        $dumpfile("ml_accel.vcd");
        $dumpvars;
        
        // Initial reset
        #2 rst = 1;
        #10 rst = 0;
        
        // Load Vector A: [1, 2, 3, 4]
        mm_write(32'h00, 32'd1); // A0
        mm_write(32'h04, 32'd2); // A1
        mm_write(32'h08, 32'd3); // A2
        mm_write(32'h0C, 32'd4); // A3
        
        // Load Vector B: [5, 6, 7, 8]
        mm_write(32'h10, 32'd5); // B0
        mm_write(32'h14, 32'd6); // B1
        mm_write(32'h18, 32'd7); // B2
        mm_write(32'h1C, 32'd8); // B3
        
        // Trigger computation
        $display("[TB] Triggering accelerator...");
        mm_write(32'h20, 32'd1); // Any write to control triggers calculation
        
        // Wait for DONE
        wait (uut.state == 2'b10); // Wait for DONE state
        $display("[TB] Accelerator signaled DONE");
        
        // Read back result
        mm_read(32'h24); // Read result from status register
        $display("[TB] Dot product result = %0d (Expected: 70)", r_data);
        
        $finish;
    end
        
    

endmodule