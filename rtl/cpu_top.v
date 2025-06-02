module cpu_top(
    input clk,
    input rst
    // Other inputs will be adder later
    );
    
    // -----------------------------------
    // PC Wires
    // -----------------------------------
    wire [31:0] pc_out; // Current PC Value
    wire [31:0] pc_next; // Next PC Value
    wire        pc_write_en = 1'b1; // Single-cycle processor so always enabled
    
    // -----------------------------------
    // PC Logic
    // -----------------------------------
    pc pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_write_en(pc_write_en),
        .pc_next(pc_next),
        .pc_out(pc_out)
    );
    
    assign pc_next = pc_out + 32'd4; // Default Increment
    
    // ------------------------------------
    // Instruction Fetch
    // ------------------------------------
    wire [31:0] instruction;
    
    instr_mem imem_inst (
        .addr(pc_out),
        .instruction(instruction)
    );
    
    // ------------------------------------
    // Instruction Decode
    // ------------------------------------
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;
    
    decoder decoder_inst (
        .instr(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );
    
    // ------------------------------------
    // Main Control Unit (Using Opcode)
    // ------------------------------------
    wire [1:0] alu_op;
    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       alu_src;
    wire       mem_to_reg;
    wire       branch;
    
    control control_inst (
        .opcode(opcode),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .branch(branch)
    );
    
    // ----------------------------------------
    // ALU Control Unit (Using funct3/funct7)
    // ----------------------------------------
    wire [3:0] alu_control;
    
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_control)
    );
    
    // -----------------------------------------
    // NOTE: This module is currently under construction.
    // Integration of datapath components is still in progress
    // -----------------------------------------
    
// TODO: Complete wiring of remaining components before finalizing
// endmodule
