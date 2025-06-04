module ml_accel(
    input wire clk,
    input wire rst,
    
    // Memory-mapped Interface
    input wire w_en, // CPU Write enable
    input wire r_en, // CPU Read enable
    input wire [5:0] addr, // 6-bit word address: 0x00 to 0x2C
    input wire [31:0] w_data, // Write data from the CPU
    output reg [31:0] r_data, // Read data back to CPU
    output reg done // Asserted high when computation is complete
    );
    
    // ------------------------------------------
    // Internal Registers for vectors A[0..3] and B[0..3]
    // ------------------------------------------
    // Base address handled by memory interconnect
    // Offset 0x00: A[0]
    // Offset 0x04: A[1]
    // Offset 0x08: A[2]
    // Offset 0x0C: A[3]
    // Offset 0x10: B[0]
    // Offset 0x14: B[1]
    // Offset 0x18: B[2]
    // Offset 0x1C: B[3]
    // Offset 0x20: Control (write 1 to start)
    // Offset 0x24: Result (read)
    
    // Internal registers to hold the vectors and the result
    reg [31:0] vec_a [0:3];
    reg [31:0] vec_b [0:3];
    reg [31:0] result;
    
    
    // FSM State encoding
    parameter IDLE = 2'b00;
    parameter COMPUTE = 2'b01;
    parameter DONE = 2'b10;
    
    reg [1:0] state, next_state;
    
    // FSM State Register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // FSM Next state Logic
    always @(*) begin
        case (state)
            IDLE: next_state = (w_en && addr == 6'h20) ? COMPUTE : IDLE;
            COMPUTE: next_state = DONE;
            DONE: next_state = IDLE;    
            default: next_state = IDLE;
        endcase
    end
    
    // FSM Output logic + Core Computation
    always @(posedge clk) begin
        if (rst) begin
            result <= 32'd0;
            done <= 1'b0;
        end
        else begin
            case (state)
                COMPUTE: begin
                    // Perform dot product: result = sum(A[i] * B[i])
                    result <= vec_a[0]*vec_b[0] + vec_a[1]*vec_b[1] + vec_a[2]*vec_b[2] + vec_a[3]*vec_b[3];
                    done <= 1'b1;
                end
                DONE: begin
                    done <= 1'b0;
                end
            endcase
        end
    end
    
    // Interface
    always @(posedge clk) begin
        if(w_en) begin
            case (addr)
                8'h00: vec_a[0] <= w_data;
                8'h04: vec_a[1] <= w_data;
                8'h08: vec_a[2] <= w_data;
                8'h0C: vec_a[3] <= w_data;
                8'h10: vec_b[0] <= w_data;
                8'h14: vec_b[1] <= w_data;
                8'h18: vec_b[2] <= w_data;
                8'h1C: vec_b[3] <= w_data;
                // 0x20 is control register (used in FSM, no need to store)
            endcase
        end
    end
     
    
    always @(*) begin
        if (r_en && addr == 6'h24)
            r_data = result;
        else
            r_data = 32'd0;
    end
    
    
    
endmodule
