`include "../parameters.v"

module keypad (
    input clk,
    input reset,
    input [3:0] row,
    input [3:0] col,
    output reg [4:0] key,
    /*
        -- key encoding --
        ------------------
        first bit - 0:idle
        ------------------
        0000 ~ 1001: 0 ~ 9
        1010 ~ 1101: A ~ D
        1110: *    1111: #
    */
    output en,
    output [3:0] row_,
    output [3:0] col_
);

    assign en = 1;
    assign row_ = row;
    assign col_ = col;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            key <= 5'b00000;
        end
        else begin
            case ({row, col})
                8'b0001_0001: key <= `KEY_1;
                8'b0001_0010: key <= `KEY_2;
                8'b0001_0100: key <= `KEY_3;
                8'b0001_1000: key <= `KEY_A;
                8'b0010_0001: key <= `KEY_4;
                8'b0010_0010: key <= `KEY_5;
                8'b0010_0100: key <= `KEY_6;
                8'b0010_1000: key <= `KEY_B;
                8'b0100_0001: key <= `KEY_7;
                8'b0100_0010: key <= `KEY_8;
                8'b0100_0100: key <= `KEY_9;
                8'b0100_1000: key <= `KEY_C;
                8'b1000_0001: key <= `KEY_STAR;
                8'b1000_0010: key <= `KEY_0;
                8'b1000_0100: key <= `KEY_SHARP;
                8'b1000_1000: key <= `KEY_D;
                default key <= 5'b00000;
            endcase
        end
    end

endmodule