`include "parameters.v"

module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input [1:0]  ALUOp,
    input [2:0]  funct3,
    input [6:0]  funct7,
    input ALUSrc,
    output reg [31:0] ALUResult,
    output reg zero
);

    /*
                    ALUControl Assignment
            ALUOp   funct7  funct3  ALUControl
            00      0000000 000     0010    add
            00      0100000 000     0110    sub
            00      0000000 111     0000    and
            00      0000000 110     0001    or
    */

    reg [3:0] ALUControl;

    always @(*) begin
        case(ALUOp)
            2'b00,2'b01: ALUControl = {ALUOp, 2'b10};
            2'b10: 
                if (funct7 == 7'b000_0000 && funct3 == 3'b000) 
                    ALUControl = 4'b0010; // add
                else if (funct7 == 7'b010_0000 && funct3 == 3'b000) 
                    ALUControl = 4'b0110; // sub
                else if (funct7 == 7'b000_0000 && funct3 == 3'b111)
                    ALUControl = 4'b0000; // and
                else if (funct7 == 7'b000_0000 && funct3 == 3'b110)
                    ALUControl = 4'b0001; // or
        endcase
    end

    reg [31:0] operand2;

    always @(*) begin
        case (ALUSrc)
            1'b0: operand2 = ReadData2;
            1'b1: operand2 = imm32;
        endcase
    end

    always @(*) begin
        case (ALUControl)
            4'b0010: ALUResult = ReadData1 + operand2;
            4'b0110: ALUResult = ReadData1 - operand2;
            4'b0000: ALUResult = ReadData1 & operand2;
            4'b0001: ALUResult = ReadData1 | operand2;
        endcase
    end

    always @(*) begin
        case (ALUResult)
            0: zero = 1'b1;
            default: zero = 1'b0;
        endcase
    end

endmodule
