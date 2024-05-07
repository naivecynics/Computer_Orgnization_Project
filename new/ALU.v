`timescale 1ns / 1ps

module ALU(
    input [31:0] ReadData1,
    input [31:0] ReadData2,
    input [31:0] imm32,
    input [1:0] ALUOp,
    input [31:0] instruction,
    input ALUSrc,
    output reg [31:0] ALUResult,
    output reg Zero
);
reg [3:0] ALUControl;
always @(*) begin
    case(ALUOp)
        2'b00,2'b01: ALUControl = {ALUOp, 2'b10};
        2'b10: 
            if (instruction[31:25] == 7'b000_0000 && instruction[14:12] == 3'b000) 
                ALUControl = 4'b0010; //add
            else if (instruction[31:25] == 7'b010_0000 && instruction[14:12] == 3'b000) 
                ALUControl = 4'b0110; //sub
            else if (instruction[31:25] == 7'b000_0000 && instruction[14:12] == 3'b111)
                ALUControl = 4'b0000; //and
            else if (instruction[31:25] == 7'b000_0000 && instruction[14:12] == 3'b110)
                ALUControl = 4'b0001; //or
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
        0: Zero = 1'b1;
        default: Zero = 1'b0;
    endcase
end

endmodule
