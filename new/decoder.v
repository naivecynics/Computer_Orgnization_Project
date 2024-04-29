module decoder(
    input clk,
    input reset,
    input [31:0] instruction,

    output [31:0] imm,
    output [31:0] R_data_1,
    output [31:0] R_data_2
);
    wire write_R, write_M;
    
    control_w control_w(
        .instruction(instruction),
        .write_R(write_R),
        .write_M(write_M)
    );

    imm_gen imm_gen(
        .in(instruction),
        .imm(imm)
    );

    reg_file reg_file(
        .clk(clk),
        .reset(reset),
        .R_reg_1(instruction[19:15]),
        .R_reg_2(instruction[24:20]),
        .W_reg(instruction[11:7]),
        .W_data(imm),
        .W_en(write_R),
        .R_data_1(R_data_1),
        .R_data_2(R_data_2)
    )
endmodule
