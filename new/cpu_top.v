module cpu_top (
    /*  system  */
    input clk_100,
    input rst_n,

    /*  hardware  */
    input keyboard_clk,
    input keyboard_data,
    input finish,
    input [7:0] switch,
    input [7:0] small_switch,

    output [7:0] led,
    output [7:0] small_led,
    output [7:0] tube_scan,
    output [7:0] tube_signal_left,
    output [7:0] tube_signal_right
);

    wire clk_23;    // for cpu  - 23 MHz
    wire clk_10;    // for UART - 10 MHz   

    wire rst_n_;
    wire finish_;

    wire [31:0] reg_map_tube;
    wire [31:0] reg_map_led;
    assign led = reg_map_led[7:0];
    
    // test light
    // assign test_pc[7] = finish;

    // keyboard
    wire [15:0] keyboard_out;
    wire [31:0] reg_data;
    wire [31:0] keyboard;
    wire enter;

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
        .reg_data(small_switch[0] ? reg_data : reg_map_tube),
        .tube_scan(tube_scan),
        .tube_signal_left(tube_signal_left),
        .tube_signal_right(tube_signal_right)   
    );

    PS2 PS2_inst(
        .clk(clk_100),
        .rst_n(rst_n),
        .PS2D(keyboard_data),
        .PS2C(keyboard_clk),
        .key(keyboard_out)
    );

    process_keyboard process_keyboard_inst(
        .clk(clk_100),
        .rst_n(rst_n),
        .keyboard_out(keyboard_out),
        .temp_data(reg_data),
        .reg_data(keyboard),
        .mono_clk(small_led[7]),    // pressed signal
        .enter(enter)
    );

    datapath datapath_inst(
        .clk(clk_23),
        .clk_100(clk_100),
        .rst_n(rst_n_),
        .switch_in(switch),
        .keyboard_in(keyboard),
        .finish(finish_ | enter),
        .reg_map_tube(reg_map_tube),
        .reg_map_led(reg_map_led),
        .test_pc(small_led[6:0])
    );

endmodule