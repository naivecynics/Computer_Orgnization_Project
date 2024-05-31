`include "parameters.v"

module main_controller (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    
    output reg MemRead,
    output reg MemtoReg,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg [3:0] ALU_control,

    output beq,
    output bne,
    output blt,
    output bge,
    output bltu,
    output bgeu,

    output lui,
    output auipc,
    output U_type,
    output jal,
    output jalr
);

/*
	output   [2:0]RW_type;??????????????????
*/

    //B-type()
    wire B_type = (opcode == `B_type);
    assign beq = (funct3 == 3'b000) && B_type;
    assign bne = (funct3 == 3'b001) && B_type;
    assign blt = (funct3 == 3'b100) && B_type;
    assign bge = (funct3 == 3'b101) && B_type;
    assign bltu = (funct3 == 3'b110) && B_type;
    assign bgeu = (funct3 == 3'b111) && B_type;
    //others
    assign lui = (opcode == `lui);
    assign auipc = (opcode == `auipc);
    assign U_type = lui | auipc;
    assign jal = (opcode == `jal);
    assign jalr = (opcode == `jalr);

    //R-type and I-type
    wire R_type = (opcode == `R_type);
    wire I_type = (opcode == `I_type);

    //MemRead
    always @* begin
        if (opcode == `load) begin
            MemRead = 1;
        end else begin
            MemRead = 0;
        end
    end
    //MemWrite
    always @* begin
        if (opcode == `store) begin
            MemWrite = 1;
        end else begin
            MemWrite = 0;
        end
    end
    //RegWrite
    always @* begin
        if (opcode == `load || opcode == `jalr || opcode == `jal || R_type || I_type || U_type || opcode == `ECALL) begin
            RegWrite = 1;
        end else begin
            RegWrite = 0;
        end
    end
    //ALUSrc
    always @* begin
        if (opcode == `load || opcode == `store || opcode == `jalr || I_type) begin
            ALUSrc = 1;
        end else begin
            ALUSrc = 0;
        end
    end
    //MemtoReg
    always @* begin
        if (opcode == `load) begin
            MemtoReg = 1;
        end else begin
            MemtoReg = 0;
        end
    end
    
    // ##########################################################
    // ALU control
    /*
    ALU_control specification:

    0000: add
    0001: sub

    0100: and
    0101: or
    0110: xor

    1000: signed less than
    1001: unsigned less than

    1100: shift left logical
    1101: shift right logical
    1110: shift right arithmetic


    剩余的ALU控制信号：
    0010，0011，0111，1010，1011，1111
    0010：subu
    0111：lui
    1010：auipc
    还有一些难以处理的：bge，bgeu，lui, auipc
    */
        
    always @* begin
        if (R_type) begin
            case(funct3)
                3'b000 : ALU_control = (funct7 == 7'b0000000) ? 4'b0000 : 4'b0001; //add or sub
                3'b100 : ALU_control = 4'b0110; //xor
                3'b110 : ALU_control = 4'b0101; //or
                3'b111 : ALU_control = 4'b0100; //and
                3'b001 : ALU_control = 4'b1100; //sll
                3'b101 : ALU_control = (funct7 == 7'b0000000) ? 4'b1101 : 4'b1110; //srl or sra
                3'b010 : ALU_control = 4'b1000; //slt
                3'b011 : ALU_control = 4'b1001; //sltu
                default : ALU_control = 4'b0000; 
            endcase
        end
        else if (I_type) begin // I-type: addi, xori, ori, andi, slli, srli, srai, slti, sltiu
            case(funct3)
                3'b000 : ALU_control = 4'b0000; //addi
                3'b100 : ALU_control = 4'b0110; //xori
                3'b110 : ALU_control = 4'b0101; //ori
                3'b111 : ALU_control = 4'b0100; //andi
                3'b001 : ALU_control = 4'b1100; //slli
                3'b101 : ALU_control = (funct7 == 7'b0000000) ? 4'b1101 : 4'b1110; //srli or srai
                3'b010 : ALU_control = 4'b1000; //slti
                3'b011 : ALU_control = 4'b1001; //sltiu
                default : ALU_control = 4'b0000; 
            endcase
        end
        else if (opcode == `load) begin
            case(funct3)
                3'b000 : ALU_control = 4'b0000; //lb
                3'b001 : ALU_control = 4'b0000; //lh
                3'b010 : ALU_control = 4'b0000; //lw
                3'b100 : ALU_control = 4'b0000; //lbu
                3'b101 : ALU_control = 4'b0000; //lhu
                default : ALU_control = 4'b0000;
            endcase
        end
        else if (opcode == `store) begin
            case(funct3)
                3'b000 : ALU_control = 4'b0000; //sb
                3'b001 : ALU_control = 4'b0000; //sh
                3'b010 : ALU_control = 4'b0000; //sw
                default : ALU_control = 4'b0000;
            endcase
        end
        // to do
        else if (B_type) begin
            case(funct3)
                3'b000 : ALU_control = 4'b0011; //beq
                3'b001 : ALU_control = 4'b0011; //bne
                3'b100 : ALU_control = 4'b0011; //blt
                3'b101 : ALU_control = 4'b0011; //bge
                3'b110 : ALU_control = 4'b0011; //bltu
                3'b111 : ALU_control = 4'b0011; //bgeu
                default : ALU_control = 4'b0000;
            endcase
        end
        else if (opcode == `jal) begin
            ALU_control = 4'b0011; // special case 
        end
        else if (opcode == `jalr) begin
            ALU_control = 4'b0011; // special case
        end
        else if (opcode == `lui) begin
            ALU_control = 4'b0111; // lui
        end
        else if (opcode == `auipc) begin
            ALU_control = 4'b1010; // auipc
        end
        else begin
            ALU_control = 4'b0000;
        end
    end

endmodule



