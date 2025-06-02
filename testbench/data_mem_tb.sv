`timescale 1ns / 1ps

module data_mem_tb;

    // DUT signals
    logic        clk;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] addr;
    logic [31:0] write_data;
    logic [31:0] read_data;

    // Instantiate the DUT
    data_mem dut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Task for writing to memory
    task write_word(input int address, input int data);
        begin
            addr        = address;
            write_data  = data;
            mem_write   = 1;
            mem_read    = 0;
            #10; // wait one cycle
            mem_write   = 0;
        end
    endtask

    // Task for reading from memory
    task read_word(input int address);
        begin
            addr        = address;
            mem_read    = 1;
            mem_write   = 0;
            #1; // short delay to allow read_data to update
            $display("Read from addr %0h: %0h", address, read_data);
            mem_read    = 0;
        end
    endtask

    // Main test sequence
    initial begin
        // Init
        clk = 0;
        mem_read = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;

        $display("\n=== Data Memory Test Start ===");

        // Write to memory
        write_word(32'h00000000, 32'hDEADBEEF);
        write_word(32'h00000004, 32'hCAFEBABE);
        write_word(32'h00000010, 32'hFEEDFACE);

        // Read back from memory
        read_word(32'h00000000); // Expect: DEADBEEF
        read_word(32'h00000004); // Expect: CAFEBABE
        read_word(32'h00000010); // Expect: FEEDFACE

        // Invalid read (no write performed here)
        read_word(32'h0000001C); // Expect: 00000000

        $display("=== Data Memory Test End ===\n");
        $finish;
    end

endmodule
