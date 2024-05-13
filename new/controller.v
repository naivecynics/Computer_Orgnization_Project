module controller (
    input [31:0] inst,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg RegWrite,
    output reg ALUSrc,
    output reg MemWrite,
    output reg [1:0] ALUOp
);
    wire funct3 = inst[14:12];
    //Branch
    always @ (inst) begin
        if (inst[6:0] == 7'b1100011 && funct3 == 3'b000) begin
            Branch = 1;
        end else begin
            Branch = 0;
        end
    end
    //MemRead
    always @ (inst) begin
        if (inst[6:0] == 7'b0000011) begin
            MemRead = 1;
        end else begin
            MemRead = 0;
        end
    end
    //MemtoReg
    always @ (inst) begin
        if (inst[6:0] == 7'b0000011) begin
            MemtoReg = 1;
        end else begin
            MemtoReg = 0;
        end
    end
    //MemWrite
    always @ (inst) begin
        if (inst[6:0] == 7'b0100011) begin
            MemWrite = 1;
        end else begin
            MemWrite = 0;
        end
    end
    //ALUSrc
    always @ (inst) begin
        if (inst[6:0] == 7'b0100011 || inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0010011 || inst[6:0] == 7'b1100111) begin
            //          load or store or I_type or jalr
            ALUSrc = 1;
        end else begin
            ALUSrc = 0;
        end
    end
    //RegWrite
    always @ (inst) begin
        if (inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0010011 || inst[6:0] == 7'b1100111 || inst[6:0] == 7'b0110011) begin
            //           load or I_type or jalr or R_type
            RegWrite = 1;
        end else begin
            RegWrite = 0;
        end
    end
    //ALUOp
    always @ (inst) begin
        //2'b00 load or store
        //2'b01 beq
        //2'b10 R_type 
        //2'b11 others
        if (inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0100011) begin
            ALUOp = 2'b00;
        end else if (inst[6:0] == 7'b1100011 && funct3 == 3'b000) begin
            ALUOp = 2'b01;
        end else if (inst[6:0] == 7'b0110011) begin
            ALUOp = 2'b10;
        end else begin
            ALUOp = 2'b11;
        end
    end
endmodule