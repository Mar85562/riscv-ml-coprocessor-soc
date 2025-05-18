`timescale 1ns/1ps
module alu_tb;

reg [31:0] a, b;
reg [2:0] op;
wire [31:0] result;

alu uut (.a(a), .b(b), .op(op), .result(result));

initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);
    $display("Simulation started");


    a = 32'd15; b = 32'd10;

    op = 3'b000; #10;  // ADD: 15 + 10
    op = 3'b001; #10;  // SUB: 15 - 10
    op = 3'b010; #10;  // AND
    op = 3'b011; #10;  // OR
    op = 3'b100; #10;  // XOR

    $finish;
end

endmodule
