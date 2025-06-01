module regfile(
    input clk, // Clock signal for synchronous write 
    input w_enable,
    input [4:0] rs1_addr, // Read register 1 address (5 bits to select 1 of 32)
    input [4:0] rs2_addr, // Read register 2 address
    input [4:0] rd_addr, // Write register address
    input [31:0] rd_data, // Data to write
    output [31:0] rs1_data, // Data output of read register 1
    output [31:0] rs2_data // Data output of read register 2 
    );
    
    // 32 general-purpose registers
    reg [31:0] regs [0:31];
    
    // Combinational Read logic
    assign rs1_data = (rs1_addr == 5'd0) ? 32'b0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'b0 : regs[rs2_addr];
    
    // Synchronous write logic
    always @(posedge clk) begin
        if (w_enable && rd_addr != 5'd0) begin
            regs[rd_addr] <= rd_data;
        end
    end
endmodule