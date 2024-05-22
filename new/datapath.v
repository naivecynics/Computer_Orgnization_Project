module datapath(
    input clk,
    input rst_n
);

    wire [31:0] instr;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imme;
    

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

    // controller module

    wire MemRead;
    wire MemtoReg;
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire [3:0] ALU_control;
    wire beq;
    wire bne;
    wire blt;
    wire bge;
    wire bltu;
    wire bgeu;
    wire lui;
    wire auipc;
    wire U_type;
    wire jal;
    wire jalr;
    wire ecall;

    Main_controller Main_controller_inst (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ALU_control(ALU_control),
        .beq(beq),
        .bne(bne),
        .blt(blt),
        .bge(bge),
        .bltu(bltu),
        .bgeu(bgeu),
        .lui(lui),
        .auipc(auipc),
        .U_type(U_type),
        .jal(jal),
        .jalr(jalr),
        .ecall(ecall)
    );

    // instantiating the program counter
    
   
    wire jump_flag;
    wire [31:0] ALUResult;
    wire [31:0] pc_out;
    
    pc pc_inst(
        .clk(clk),
        .rst_n(rst_n),
        .ALU_result(ALUResult),
        .jump_flag(jump_flag),
        .stop_flag(ecall),   
        .inst(instr),
        .pc_out(pc_out)
    );


    // instantiating the register file

    reg [31:0] W_data;
    wire [31:0] R_data_1;
    wire [31:0] R_data_2;

    reg_file regfile_inst(
        .clk(clk),
        .reset(rst_n),
        // .stop_flag(?)
        .R_reg_1(rs1),
        .R_reg_2(rs2),
        .W_reg(rd),
        .W_data(W_data),
        .W_en(RegWrite),
        .R_data_1(R_data_1),
        .R_data_2(R_data_2),
        .func3(funct3),
        .func7(funct7)
    );
    // instantiating the ALU

    ALU alu_inst(
        .Read_data1(R_data_1),
        .Read_data2(R_data_2),
        .imme(imme),
        .pc_out(pc_out),
        .funct3(funct3),
        .ALUSrc(ALUSrc),
        .beq(beq),
        .bne(bne),
        .blt(blt),
        .bge(bge),
        .bltu(bltu),
        .bgeu(bgeu),
        .jal(jal),
        .jalr(jalr),
        .ALU_control(ALU_control),
        .ALU_result(ALUResult),
        .jump_flag(jump_flag)
    );

    // data memory module

    wire [31:0] ram_data_out;
    data_memory data_memory_inst(
        .clk(clk),
        .MemWrite(MemWrite),
        .ALUResult(ALUResult),
        .R_data2(R_data_2),
        .ram_data_out(ram_data_out)
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