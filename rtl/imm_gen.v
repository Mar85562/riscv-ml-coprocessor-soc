module imm_gen(
    input [31:0] instr,
    output reg [31:0] imm_out
    );
    
    wire [6:0] opcode = instr[6:0];
    
    always @(*) begin
        case (opcode)
            7'b0010011, // I-type (ADDI, etc...)
            7'b0000011: // I-type (LW)
                imm_out = {{20 {instr[31]}}, instr[31:20]};
                
            7'b0100011: // S-type (SW)
                imm_out = {{20 {instr[31]}}, instr[31:25], instr[11:7]};
                
            7'b1100011: // B-type (BEQ)
                imm_out = {{19 {instr[31]}},  instr[31], instr[7],
                            instr[30:25], instr[11:8], 1'b0};
                            
            7'b0110111, // U-type (LUI)
            7'b0010111: // U-type (AUIPC)
                imm_out = {instr[31:12], 12'b0};
                
            7'b1101111: // J-type (JAL)
                imm_out = {{11 {instr[31]}}, instr[31], instr[19:12],
                            instr[20], instr[30:21], 1'b0};
                            
            default: imm_out = 32'b0;
        endcase
    end
    
endmodule
