`include "../parameters.v"

// module debounce (
//     input wire clk,
//     input wire btn_in,
//     output reg btn_out
// );

//     reg [3:0] count;
//     reg btn_in_last;
//     reg [1:0] state;

//     always @(posedge clk) begin
//         btn_in_last <= btn_in;
//     end

//     always @(posedge clk) begin
//         if (btn_in != btn_in_last) begin
//             count <= `DEBOUNCE_PERIOD;
//         end else if (count > 0) begin
//             count <= count - 1;
//         end
//         if (count == 0) begin
//             btn_out <= btn_in;
//         end
//     end

// endmodule

module debounce(
    input clk,
    // input [15:0] tempkey,
    input tempkey,
    // output reg [15:0] finalkey
    output reg finalkey
    );
    
    // reg [15:0] key_prev;
    reg key_prev;
    // reg [15:0] key_debounced;
    reg key_debounced;
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