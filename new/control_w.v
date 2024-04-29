module control_w(
    input [31:0] instruction,
    output reg write_R,
    output reg write_M
);
// R: I, R, U
// M: S
// N: SB, J
    always @ (instruction) begin
        casex (instruction[6:0])
            // 7'b0010111: begin // auipc
            //     {write_R, write_M} = 2'b00;
            // end
            7'b00?????: begin // I format
                {write_R, write_M} = 2'b10;
            end
            7'b0100011: begin // S format
                {write_R, write_M} = 2'b01;
            end
            7'b01?????: begin // R format + lui
                {write_R, write_M} = 2'b10;
            end
            7'b11?????: begin // SB format + UJ format
                {write_R, write_M} = 2'b00;
            end
            default: begin
                {write_R, write_M} = 2'b00;
            end
        endcase 
    end
endmodule
