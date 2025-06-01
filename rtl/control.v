module control(
    input [6:0] opcode, // Instruction[6:0]
    output reg [1:0] alu_op, // To ALU Control
    output reg reg_write, // Enable register write
    output reg mem_read, // Enable memory read
    output reg mem_write, // Enable memory write
    output reg alu_src, // Select ALU operand 2 source (reg or imm)
    output reg mem_to_reg, // Select write-back source (ALU or mem)
    output reg branch // Enable branch comparison
    );
    
    always @(*) begin
        // Default Values (NOP)
        alu_op      = 2'b00;
        reg_write   = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        alu_src     = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        
        case (opcode)
            7'b0110011: begin // R-type
                alu_op      = 2'b10;
                reg_write   = 1'b1;
                alu_src     = 1'b0;
                mem_to_reg  = 1'b0;
            end
            
            7'b0010011: begin // I-type (ADDI, SLTI, etc.)
                alu_op      = 2'b10;
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_to_reg  = 1'b0;
            end

            7'b0000011: begin // Load (LW)
                alu_op      = 2'b00;
                reg_write   = 1'b1;
                mem_read    = 1'b1;
                alu_src     = 1'b1;
                mem_to_reg  = 1'b1;
            end

            7'b0100011: begin // Store (SW)
                alu_op      = 2'b00;
                mem_write   = 1'b1;
                alu_src     = 1'b1;
            end

            7'b1100011: begin // Branch (BEQ)
                alu_op      = 2'b01;
                branch      = 1'b1;
                alu_src     = 1'b0;
            end

            default: begin
                // Unknown instruction: keep defaults
            end
        endcase 
    end
endmodule
