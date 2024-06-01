`include "../parameters.v"

module keyboard_debouncer (
    input clk,
    input [15:0] tempkey,
    output reg [15:0] finalkey
);
    
    reg [15:0] key_prev;
    reg [15:0] key_debounced;

    reg [23:0] debounce_counter;
    
    always @(posedge clk) begin
        if (tempkey == key_prev) begin
            if (debounce_counter < 24'd1_999_999) begin
                debounce_counter <= debounce_counter + 1;
            end else begin
                key_debounced <= tempkey;
            end
        end else begin
            debounce_counter <= 0;
        end
        key_prev <= tempkey;
    end
    
    always @(posedge clk) begin
        finalkey <= key_debounced;
    end

endmodule