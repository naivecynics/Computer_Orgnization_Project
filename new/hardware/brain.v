module brain (
    input clk,
    input reset,
    input [4:0] in,
    output reg [31:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
        end
        else begin
        end
    end

endmodule