module pc(
    input clk,
    input rst_n,
    input stop_flag,            // ecall
    input jump_flag,
    input [31:0] ALU_result,    // jump address
    output [31:0] inst,
    output reg [31:0] pc_out,

    //uart
    input upg_rst_i,
    input upg_clk_i,
    input upg_wen_i,
    input [13:0] upg_adr_i,
    input [31:0] upg_dat_i,
    input upg_done_i
);

    reg [31:0] next_pc;

    always @(negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pc_out <= 32'h00000000;
        end else begin
            pc_out <= next_pc;
        end
    end

    always @* begin
        if (stop_flag == 1) begin
            next_pc = pc_out;
        end else if (jump_flag == 1) begin
            next_pc = ALU_result;
        end else begin
            next_pc = pc_out + 4;
        end
    end


    wire kickOff = upg_rst_i | (!upg_rst_i & upg_done_i);

    // prgrom prgrom_inst(
    //     .clka(clk),
    //     .addra(pc_out[15:2]),
    //     .douta(inst)
    // );

    prgrom prgrom_inst(
        .clka(kickOff?clk:upg_clk_i),
        .wea(kickOff?1'b0:upg_wen_i),
        .addra(kickOff?pc_out[15:2]:upg_adr_i),
        .dina(kickOff?32'h00000000:upg_dat_i),
        .douta(inst)
    );

endmodule