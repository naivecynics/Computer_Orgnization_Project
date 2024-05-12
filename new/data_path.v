module data_path(
    input clk,
    input rst_n
);

    //instantiating the instruction decoder

    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imme;
    wire [31:0] R_data_1;
    wire [31:0] R_data_2;

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

    // controller module

    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire [1:0] ALUOp;

    controller controller_inst(
        .inst(instr),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp)
    );

    // data memory module

    

    //instantiating the program counter
    
    wire [31:0] pc;

    pc pc_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc),
        .pc_out(pc)
    );

    //instantiating the register file
    regfile regfile_inst(
        .clk(clk),
        .reset(rst_n),
        .R_reg_1(rs1),
        .R_reg_2(rs2),
        .W_reg(rd),
        .W_data(W_data),
        .W_en(RegWrite),
        .R_data_1(R_data_1),
        .R_data_2(R_data_2)
    );

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

    // data memory module

    wire [31:0] ram_data_out;
    dememory dememory_inst(
        .ram_clk_i(clk),
        .ram_wen_i(MemWrite),
        .ram_adr_i(ALUResult[13:0]),
        .ram_dat_i(R_data_2),
        .ram_dat_o(ram_data_out)
    );


    //mux for selecting data to be written to the register file


    always @(*) begin
        if (MemtoReg) begin
            W_data = ram_data_out;
        end
        else begin
            W_data = ALUResult;
        end
    end


    // mux for selecting data to ALU operand2

        // ALU mux is already implemented in the ALU module

    // mux for selecting data to PC

        // PC mux is already implemented in the PC module


endmodule