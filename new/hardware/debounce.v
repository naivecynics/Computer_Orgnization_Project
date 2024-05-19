`include "../parameters.v"

module debounce (
    input wire clk,
    input wire btn_in,
    output reg btn_out
);

    reg [3:0] count;
    reg btn_in_last;
    reg [1:0] state;

    always @(posedge clk) begin
        btn_in_last <= btn_in;
    end

    always @(posedge clk) begin
        if (btn_in != btn_in_last) begin
            count <= `DEBOUNCE_PERIOD;
        end else if (count > 0) begin
            count <= count - 1;
        end
        if (count == 0) begin
            btn_out <= btn_in;
        end
    end

endmodule
