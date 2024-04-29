module controller(
    input [6:0] instruction,
    output reg Branch,      // while the instruction is beq
    output reg [1:0] ALUOp, // 00: l/s  01: beq  10: R
    output reg ALUSrc,      // while put imm into ALU
    output reg MemRead,     // while need to read memory
    output reg MemWrite,    // while need to write memory
    output reg Mem2Reg,     // while need to write memory to register
    output reg RegWrite     // while need to write registers
);
    always @ * begin
        case (instruction[6:0])
            7'h33: begin // R format
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b01000001;
            end
            7'h13: begin // I format
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b01010011;
            end
            7'h03: begin // I format - load
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b00011011;
            end
            7'h23: begin // S format
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b00010100;
            end
            7'h63: begin // B format
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b10100000;
            end
            default: begin
                {Branch, ALUOp, ALUSrc, MemRead, MemWrite, Mem2Reg, RegWrite} = 8'b00000000;
            end
        endcase
    end
endmodule