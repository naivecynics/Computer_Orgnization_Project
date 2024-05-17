module IFetch (
    input clk,
    input rst,
    input [31:0] imm32,
    input branch,
    input zero,
    output [31:0] inst
);

    reg [31:0] pc;

    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            pc <= 32'h00000000;
        end
        else if (branch && zero) begin
            pc <= pc + imm32;
        end
        else begin
            pc <= pc + 4;
        end
    end

    prgrom urom(
        .clka(clk),
        .addra(pc[15:2]),
        .douta(inst)
    );
    
endmodule