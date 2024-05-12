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