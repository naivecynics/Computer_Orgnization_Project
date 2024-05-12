`timescale 1ns / 1ps

module data_path(
    input clk,
    input rst_n,
    input [31:0] instr,
    input MemtoReg,
    input RegWrite,
    input ALUSrc,
    input [31:0] R_data,
    output [6:0] opcode,
    output [31:0] W_data,
    output reg [31:0] ALUResult
);

    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire W_en;
    wire [31:0] imme;
    wire [31:0] R_data_1;
    wire [31:0] R_data_2;

    //instantiating the instruction decoder
    instr_decoder instr_decoder_inst(
        .instr(instr),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imme(imme)
    );

    

    wire [31:0] pc_in;
    wire [31:0] pc_out;

    //instantiating the program counter
    pc pc_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    //instantiating the register file
    regfile regfile_inst(
        .clk(clk),
        .reset(rst_n),
        .R_reg_1(rs1),
        .R_reg_2(rs2),
        .W_reg(rd),
        .W_data(W_data),
        .W_en(W_en),
        .R_data_1(R_data_1),
        .R_data_2(R_data_2)
    );

    wire [1:0] ALUOp;
    //instantiating the ALU
    wire zero;

    ALU alu_inst(
        .ReadData1(R_data_1),
        .ReadData2(R_data_2),
        .imm32(imme),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUSrc(ALUSrc),
        .ALUResult(ALUResult),
        .zero(zero)
    );











endmodule