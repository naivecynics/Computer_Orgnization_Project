module cpu_top(
    input clk_100,
    input rst,
    input [31:0] keyboard_in,
    input keyboard_finish,
    output [7:0] tube_scan,
    output [7:0] tube_signal
);

    wire clk_23;    // for cpu  - 23 MHz (5 MHz)
    wire clk_10;    // for UART - 10 MHz   

    wire [31:0] reg_map_tube;

    cpuclk cpuclk_inst(
        .clk_in1(clk_100),
        .clk_out1(clk_23),
        .clk_out2(clk_10)
    );

    tube tube_inst(
        .clk(clk_100),
        .reset(rst),
        .reg_data(reg_map_tube),
        .tube_scan(tube_scan),
        .tube_signal(tube_signal)
    );

    datapath datapath_inst(
        .clk(clk_23),
        .rst_n(~rst),
        .keyboard_in(keyboard_in),
        .keyboard_finish(keyboard_finish),
        .reg_map_tube(reg_map_tube)
    );

endmodule