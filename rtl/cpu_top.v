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
    
    // ------------------------------------
    // Instruction Fetch
    // ------------------------------------
    wire [31:0] instruction;
    
    instr_mem imem_inst (
        .addr(pc_out),
        .instruction(instruction)
    );
    
//    always @(posedge clk) begin
//        $display("Fetched Instruction @ PC=%0d: %h", pc_out, instruction);
//    end
    
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
    wire [3:0] alu_ctrl;
    
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7(funct7),
        .alu_control(alu_ctrl)
    );
    
    // -----------------------------------------
    // Register File
    // -----------------------------------------
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] write_data; // To be slected later using MemToReg MUX
    
    regfile regfile_inst (
        .clk(clk),
        .w_enable(reg_write),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rd_addr(rd),
        .rd_data(write_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
     );
     
     // -----------------------------------------
     // Immediate Generator
    // ------------------------------------------
    wire [31:0] imm;
    
    imm_gen imm_gen_inst (
        .instr(instruction),
        .imm_out(imm)
    );
    
    // -------------------------------------------
    // ALU Source MUX
    // -------------------------------------------
    wire [31:0] alu_src_b;
    
    assign alu_src_b = (alu_src) ? imm : rs2_data; // Choose immediate or rs2_data
    
    // -----------------------------------------------
    // ALU
    // -----------------------------------------------
    wire [31:0] alu_result;
    wire        zero; // Zero flag 
    
    alu alu_inst (
        .a(rs1_data),
        .b(alu_src_b),
        .alu_control(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );
    
    always @(posedge clk) begin
    $display("=== BRANCH DEBUG ===");
    $display("  rs1_data = %0d", rs1_data);
    $display("  rs2_data = %0d", rs2_data);
    $display("  ALU result = %0d", alu_result);
    $display("  Zero flag  = %b", zero);
    $display("  Branch     = %b", branch);
    $display("  is_branch_taken = %b", is_branch_taken);
    $display("=====================");
end
    
    // ------------------------------------
    // Branch Target Logic
    // ------------------------------------
    wire [31:0] pc_branch_target = pc_out + (imm); // Target address is PC + immediate
    wire [31:0] pc_plus_4 = pc_out + 32'd4;     // default next PC
    
    wire is_branch_taken = branch && zero;
    assign pc_next = is_branch_taken ? pc_branch_target : pc_plus_4;

//    assign pc_next = (branch && zero) ? pc_branch_target : pc_plus_4; // BEQ condition
    
    // -----------------------------------------------
    // Data Memory - This is added here only for testing CPU in isolation before adding
    // the ML Accelerator to the SoC and integrating them in soc_top.v. When soc_top is under development
    // This module will be commented out from cpu_top.v and moved to soc_top.v
    // -----------------------------------------------
    wire [31:0] mem_read_data; // output from memory (lw)
    
    data_mem data_mem_inst (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(rs2_data),
        .read_data(mem_read_data)
    );
    
    // -------------------------------------
    // Writeback MUX (MemToReg) - will probably moved to the top or modified when cpu is integrated with SoC
    // --------------------------------------
    assign write_data = (mem_to_reg) ? mem_read_data : alu_result;
    
 
endmodule
