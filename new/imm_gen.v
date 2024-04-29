module imm_gen(
    input [31:0] in,
    output reg [31:0] imm
);
    always @ (in) begin
        if (in[6:0] == 7'b0100011) begin 
            imm = {{20{in[31]}}, in[31:25], in[11:7]};
        end
        ////   I   //// 
        else if (in[6:0] == 7'b0000011 || in[6:0] == 7'b0001111 || in[6:0] == 7'b0010011 || 
        in[6:0] == 7'b0011011 || in[6:0] == 7'b1100111 || in[6:0] == 7'b1110011) begin
            if (in[6:0] == 7'b0010011 && (in[14:12] == 3'b001 || in[14:12] == 3'b101)) begin
                imm = {{27{in[24]}}, in[24:20]};
            end else begin
                imm = {{20{in[31]}}, in[31:20]};
            end
        end
        ////   SB   ////
        else if(in[6:0] == 7'b1100011) begin
            imm = {{19{in[31]}}, in[31], in[7], in[30:25], in[11:8], 1'b0};
        end
        ////   U    ////
        else if(in[6:0] == 7'b0110111) begin
            imm = {{12{in[31]}}, in[31:12]};
        end
        else if(in[6:0] == 7'b1101111) begin
            imm = {{11{in[31]}}, in[31], in[19:12], in[20], in[30:21], 1'b0};
        end
        else if(in[6:0] == 7'b0111011) begin
            imm = 0;   
        end
    end
endmodule