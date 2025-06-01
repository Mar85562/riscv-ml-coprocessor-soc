module alu_control(
    input [1:0] alu_op, // From main control unit
    input [2:0] funct3, // From Instruction [14:12]
    input [6:0] funct7, // From Instruction [31:25]
    output reg [3:0] alu_control // Output to ALU
    );
    
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0010; // Load/Store are always ADD
            2'b01: alu_control = 4'b0110; // Branch: Use SUB and the zero flag
            2'b10: begin
                case (funct3)
                    3'b000: alu_control = (funct7 == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB : ADD
                    3'b111: alu_control = 4'b0000; // AND
                    3'b110: alu_control = 4'b0001; // OR
                    3'b100: alu_control = 4'b1001; // XOR
                    3'b010: alu_control = 4'b0111; // SLT (Signed)
                    3'b011: alu_control = 4'b1000; // SLTU
                    3'b001: alu_control = 4'b1010; // SLL
                    3'b101: alu_control = (funct7 == 7'b0100000) ? 4'b1100 : 4'b1011; // SRA : SRL
                    default: alu_control = 4'b1111; // Undefined
                endcase
            end
            default: alu_control = 4'b1111; // Error State
        endcase
    end
    
endmodule
