`timescale 1ns / 1ps

module pc(
    input clk,
    input rst,
    input pc_write_en,
    input [31:0] pc_next,
    output reg [31:0] pc_out
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            pc_out <= 32'd0;
        else if (pc_write_en)
            pc_out <= pc_next;
    end
endmodule
