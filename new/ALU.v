`include "parameters.v"

module ALU(
    input [31:0] Read_data1,
    input [31:0] Read_data2,
    input [31:0] imme,
    input ALUSrc,
    input beq,
    input bne,
    input blt,
    input bge,
    input bltu,
    input bgeu,
    input jal,
    input jalr,
    input [3:0] ALU_control,
    output reg [31:0] ALU_result,
    output reg jump_flag
);

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
*/
reg [31:0] operand2;
always @* begin
    case(ALUSrc)
        1'b0 : operand2 = Read_data2;
        1'b1 : operand2 = imme; 
    endcase
end
// ############################################################
// hard part
reg [31:0] Hard_result;
always @* begin
    case(ALU_control)
        4'b0010 : Hard_result = Read_data1 - operand2; // subu
        4'b0111 : Hard_result = imme; // lui
        4'b1010 : Hard_result = $signed(imme) + $signed(Read_data1); // auipc
    endcase
end

// ############################################################

// ############################################################
// Arithmetic part
reg [31:0] Arithmetic_result;
always @* begin
    case(ALU_control)
        4'b0000 : Arithmetic_result = $signed(Read_data1) + $signed(operand2); // add
        4'b0001 : Arithmetic_result = $signed(Read_data1) - $signed(operand2); // sub
        4'b1100 : Arithmetic_result = Read_data1 << operand2; // sll
        4'b1101 : Arithmetic_result = Read_data1 >> operand2; // srl
        4'b1110 : Arithmetic_result = $signed(Read_data1) >>> operand2; // sra
    endcase
end

// ############################################################

// ############################################################
// Logic part
reg [31:0] Logic_result;
always @* begin
    case(ALU_control)
        4'b0100 : Logic_result = Read_data1 & operand2; // and
        4'b0101 : Logic_result = Read_data1 | operand2; // or
        4'b0110 : Logic_result = Read_data1 ^ operand2; // xor
    endcase
end
// ############################################################

// ############################################################
// Comparison part
reg [31:0] Comparison_result;
always @* begin
    case(ALU_control)
        4'b1000 : Comparison_result = ($signed(Read_data1) < $signed(Read_data2)) ? {{31{1'b0}}, 1'b1} : 32'h0; // slt}} : 32'h0; // slt
        4'b1001 : Comparison_result = (Read_data1 < Read_data2) ? {{31{1'b0}}, 1'b1} : 32'h0; // sltu
    endcase
end
// ############################################################

// jump_flag
always @* begin
    if (beq && Arithmetic_result == 32'b0)  begin
        jump_flag = 1;
    end
    else if (bne && Arithmetic_result != 32'b0)  begin
        jump_flag = 1;
    end
    else if (blt && Arithmetic_result < 32'b0)  begin
        jump_flag = 1;
    end
    else if (bge && Arithmetic_result >= 32'b0)  begin
        jump_flag = 1;
    end
    else if (bltu && Hard_result < 32'b0)  begin
        jump_flag = 1;
    end
    else if (bgeu && Hard_result >= 32'b0)  begin
        jump_flag = 1;
    end
    else if (jal || jalr)  begin
        jump_flag = 1;
    end
    else begin
        jump_flag = 0;
    end
end
//ALU_result
always @* begin
    case(ALU_control)
        4'b0010,4'b0111,4'b1010 : ALU_result = Hard_result;
        4'b0000,4'b0001,4'b1100,4'b1101,4'b1110 : ALU_result = Arithmetic_result;
        4'b0100,4'b0101,4'b0110 : ALU_result = Logic_result;
        4'b1000,4'b1001 : ALU_result = Comparison_result;
        default : ALU_result = 32'h0;
    endcase
end
//ALU_zero表示两个数是否相等，1表示相等，0表示不等
// assign ALU_zero = (ALU_result == 32'b0)? 1: 0;

endmodule



