module pc(
    input clk,
    input rst_n,
    input Branch,
    input zero,
    input [31:0] imm,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin   
            pc_out <= 32'h00000000;
        end else begin
            // beq instruction
            // todo: add other instructions & controllers
            if (Branch && zero) begin
                pc_out <= pc_in + imm;
            end 
            else begin
                pc_out <= pc_in + 4;
            end
        end
    end

endmodule

module pc(
    input clk,
    input rst_n,
    input [31:0] instruction,    // instruction from memory
    input [31:0] addr_result,    // jump address
    input [31:0] read_data_1,    // jr address from decoder
    input branch,                // from controller -- beq
    input n_branch,              // from controller -- bne
    input jmp,                   // from controller
    input jal,                   // from controller
    input jr,                    // from controller
    input zero,                  // from ALU, zero == 1 means two equal
    output [31:0] pc_plus_4,     // pc + 4
    output reg [31:0] pc         // pc output
);

// internal signals
reg [31:0] next_pc;

assign pc_plus_4 = pc + 4;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pc <= 32'b0;
        next_pc <= 32'b0;
    end else begin
        if ((branch == 1 && zero == 1) || (n_branch == 1 && zero == 0)) begin // beq or bne
            next_pc <= addr_result;
        end else if (jmp || jal) begin      // jmp or jal
            next_pc <= {pc[31:28], instruction[25:0], 2'b00};
        end else if (jr) begin       // jr
            next_pc <= read_data_1;  
        end else begin
            next_pc <= pc + 4;
        end

        if (jal) begin  // jal
            pc <= pc + 4;
        end else begin
            pc <= next_pc;
        end
    end
end

endmodule