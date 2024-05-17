 module Decoder(
      input clk, rst,
      input regWrite,
      input [31:0] inst,
      input [31:0] writeData,
      output [31:0] rs1Data, rs2Data,
      output reg [31:0] imm32
    );

    reg[31:0] register[0:31];

    assign rs1Data = register[inst[19:15]];
    assign rs2Data = register[inst[24:20]];

    integer i;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 0;
            end 
        end else begin
            if (regWrite && inst[11:7] != 5'b00000) begin
                register[inst[11:7]] <= writeData;
            end
        end
    end


    always @ (inst) begin
        // S_type:store
        if (inst[6:0] == 7'b0100011) begin
            imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        end
        // I_type:load
        else if(inst[6:0] == 7'b0000011) begin
            imm32 = {{20{inst[31]}}, inst[31:20]};
        end
        // I_type:arith
        else if(inst[6:0] == 7'b0010011) begin
            if (inst[31:25] == 7'b0000000 || inst[31:25] == 7'b0100000) begin
                imm32 = {27'b0,inst[24:20]}; // shift part
            end
            else begin
                imm32 = {{20{inst[31]}}, inst[31:20]}; // other part
            end
        end
        // I_type:jalr
        else if(inst[6:0] == 7'b1100111) begin
            imm32 = {{20{inst[31]}},inst[31:20]};
        end
        // B_type:branch
        else if(inst[6:0] == 7'b1100011) begin
            imm32 = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
        end
        // U_type:lui, auipc
        else if(inst[6:0] == 7'b0110111 || inst[6:0] == 7'b0010111) begin
            imm32 = {inst[31:12], 12'b0};
        end
        // J_type:jal
        else if(inst[6:0] == 7'b1101111) begin
            imm32 = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
        end
        // R_type: no imm32 needed
        else if (inst[6:0] == 7'b0110011) begin
            imm32 = 32'b0;
        end
    end


endmodule