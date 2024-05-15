module controller_total(

    input [6:0] opcode, // instruction[6:0]
    input [2:0] func3,  // instruction[14:12]
    input [6:0] func7,  // instruction[31:25]

    output reg MemRead,  // main control signals
    output reg MemtoReg,
    output reg ALUOp1,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,

    output reg lui,     //specific instructions signals
    output reg U,
    output reg jal,
    output reg jalr,
    output reg beq,
    output reg bne,
    output reg blt,
    output reg bge,
    output reg bltu,
    output reg bgeu,

    output reg [3:0] ALUControl, // ALU control signals
    output reg [2:0] RegWriteControl // RegWrite control signals
    
);
    
endmodule