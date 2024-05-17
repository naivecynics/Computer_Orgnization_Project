
module pc(
    input clk,
    input rst_n,
    input [31:0] ALU_result,    // jump address
    input jump_flag,
    output [31:0] inst
);

reg [31:0] pc_out;


always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pc_out <= 32'h00000000;
    end 
    else begin
        if (jump_flag) begin
            pc_out <= ALU_result;
        end
        else begin
            pc_out <= pc_out + 4;
        end
    end
end

prgrom prgrom_inst(
    .clka(clk),
    .addra(pc_out[15:2]),
    .douta(inst)
);

endmodule