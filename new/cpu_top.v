module cpu_top(
    input clk_100,
    input rst_n,
    // input [31:0] keyboard_in,
    input [7:0] switch_in,
    input finish,
    output [7:0] tube_scan,
    output [7:0] tube_signal_left,
    output [7:0] tube_signal_right,

    // test
    output [7:0] test_pc,
    output [7:0] switch
);

    wire clk_23;    // for cpu  - 23 MHz (5 MHz)
    wire clk_10;    // for UART - 10 MHz   

    wire rst_n_;
    wire finish_;

    wire [31:0] reg_map_tube;
    wire [31:0] reg_map_led;
    assign switch = reg_map_led[7:0];
    
    // test light
    assign test_pc[7] = finish;

    debounce debounce_reset(
        .clk(clk_100),
        .tempkey(rst_n),
        .finalkey(rst_n_)
    );

    debounce debounce_finish(
        .clk(clk_100),
        .tempkey(finish),
        .finalkey(finish_)
    );

    cpuclk cpuclk_inst(
        .clk_in1(clk_100),
        .clk_out1(clk_23),
        .clk_out2(clk_10)
    );

    tube tube_inst(
        .clk(clk_100),
        .rst_n(rst_n_),
        .reg_data(reg_map_tube),
        .tube_scan(tube_scan),
        .tube_signal_left(tube_signal_left),
        .tube_signal_right(tube_signal_right)   
    );

    datapath datapath_inst(
        .clk(clk_23),
        .clk_100(clk_100),
        .rst_n(rst_n_),
        // .keyboard_in(keyboard_in),
        .switch_in(switch_in),
        .finish(finish_),
        .reg_map_tube(reg_map_tube),
        .reg_map_led(reg_map_led),
        .test_pc(test_pc[6:0])
    );

endmodule