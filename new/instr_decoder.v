module instr_decoder(
    input [31:0] instr, // instruction
    output [6:0] opcode, // opcode
    output [2:0] funct3, // funct3
    output [6:0] funct7, // funct7
    output [4:0] rs1, // source register 1
    output [4:0] rs2, // source register 2
    output [4:0] rd, // destination register
    output [31:0] imme // immediate value
);

    assign opcode = instr[6:0];
    assign func3 = instr[14:12];
    assign func7 = instr[31:25];
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd = instr[11:7];

    imm_gen imm_gen(
        .in(instr),
        .imm(imme)
    );
    endmodule