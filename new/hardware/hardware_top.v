module hardware_top (
    input clk,
    input reset,
    /* keypad */
    input [3:0] row,
    input [3:0] col,
    /* tube */
    output reg [7:0] tube_scan,
    output reg [7:0] tube_signal
    /* button */
    /* led */
    /* switch */
);

    // _ stands for debounced
    wire reset_;
    wire [3:0] row_;
    wire [3:0] col_;

        debounce reset (clk, reset, reset_);
        debounce row (clk, row[0], row_[0]);
        debounce row (clk, row[1], row_[1]);
        debounce row (clk, row[2], row_[2]);
        debounce row (clk, row[3], row_[3]);
        debounce col (clk, col[0], col_[0]);
        debounce col (clk, col[1], col_[1]);
        debounce col (clk, col[2], col_[2]);
        debounce col (clk, col[3], col_[3]);

    wire [4:0] key_origin;
    wire [31:0] reg_data;

    brain brain_inst (
        .clk(clk),
        .reset(reset_),
        .in(key_origin),
        .out(reg_data)
    );

    keypad keypad_inst (
        .clk(clk),
        .reset(reset_),
        .row(row_),
        .col(col_),
        .key(key_origin)
    );

    tube tube_inst (
        .clk(clk),
        .reset(reset_),
        .reg_data(reg_data),
        .tube_scan(tube_scan),
        .tube_signal(tube_signal)
    );

endmodule