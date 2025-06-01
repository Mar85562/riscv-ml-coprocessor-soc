module alu(
    input [31:0] a, // Operand 1 (usually rs1_data from regfile)
    input [31:0] b, // Operand 2 (either rs2_data or immediate)
    input [3:0] alu_control, // ALU control signal (selects operation)
    output reg [31:0] result, // Output of the ALU
    output wire zero // Zero flag: Will be high if the result == 0
    );
    
    // Combinational ALU operation based on alu_control value
    always @(*) begin
        case (alu_control)
            4'b0000: result = a & b; // AND
            4'b0001: result = a | b; // OR
            4'b0010: result = a + b; // ADD
            4'b0110: result = a - b; // SUB
            4'b0111: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (signed)
            4'b1000: result = (a < b) ? 32'b1 : 32'b0; // SLTU (unsigned)
            4'b1001: result = a ^ b; // XOR
            4'b1010: result = a << b[4:0]; // SLL (logical left shift)
            4'b1011: result = a >> b[4:0]; // SRL (logical right shift)
            4'b1100: result = $signed(a) >>> b[4:0]; // SRA (arithmetic right shift)
            
            default: result = 32'hDEADBEEF; // Catch unhandled operations
            
        endcase
    end
    
    // Zero flag will be asserted if result is exactly 0
    //Used in branch logic to decide whether to change PC
    assign zero = (result == 32'b0);
    
endmodule
