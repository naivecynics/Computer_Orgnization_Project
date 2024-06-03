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
    output [7:0] tube_signal_right,

    /*  uart  */
    input start_pg,
    input rx,
    output tx
);

    wire clk_23;    // for cpu  - 23 MHz
    wire clk_10;    // for UART - 10 MHz   

    // debounced signals
    wire rst_n_;
    wire finish_;
    wire start_pg_;

    wire [31:0] reg_map_tube;
    wire [31:0] reg_map_led;
    assign led = reg_map_led[7:0];

    // keyboard
    wire [15:0] keyboard_out;
    wire [31:0] reg_data;
    wire [31:0] keyboard;
    wire enter;

    // small led
    assign small_led[7] = small_switch[7];    // keyboard beffer indicator
    assign small_led[6] = !upg_rst;           // uart mode indicator
    assign small_led[5] = finish_ | enter;    // enter indicator

    // reset buttun debouncer
    debounce debounce_reset(
        .clk(clk_100),
        .tempkey(rst_n),
        .finalkey(rst_n_)
    );
    
    // start_pg debouncer
    debounce debounce_start_pg(
        .clk(clk_100),
        .tempkey(start_pg),
        .finalkey(start_pg_)
    );

    // finish debouncer
    debounce debounce_finish(
        .clk(clk_100),
        .tempkey(finish),
        .finalkey(finish_)
    );

    // cpu clock
    cpuclk cpuclk_inst(
        .clk_in1(clk_100),
        .clk_out1(clk_23),
        .clk_out2(upg_clk)
    );

    // 7-seg tube controller
    tube tube_inst(
        .clk(clk_100),
        .rst_n(rst_n_),
        .reg_data(small_switch[7] ? reg_data : reg_map_tube),
        .tube_scan(tube_scan),
        .tube_signal_left(tube_signal_left),
        .tube_signal_right(tube_signal_right)   
    );

    // ps2 keyboard controller
    PS2 PS2_inst(
        .clk(clk_100),
        .rst_n(rst_n_),
        .PS2D(keyboard_data),
        .PS2C(keyboard_clk),
        .key(keyboard_out)
    );

    // keyboard process controller
    process_keyboard process_keyboard_inst(
        .clk(clk_100),
        .rst_n(rst_n_),
        .keyboard_out(keyboard_out),
        .temp_data(reg_data),
        .reg_data(keyboard),
        // .mono_clk(small_led[7]),    // pressed signal
        .enter(enter)
    );

    // cpu datapath
    datapath datapath_inst(
        .clk(clk_23),
        .clk_100(clk_100),
        .rst_n(rst),
        .switch_in(switch),
        .keyboard_in(keyboard),
        .finish(finish_ | enter),
        .reg_map_tube(reg_map_tube),
        .reg_map_led(reg_map_led),        
        .test_pc(small_led[4:0]),
        // uart
        .upg_rst(upg_rst),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o)
    );

    // uart ip core
    uart_bmpg_0 uart_bmpg_0_inst(
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o(tx)
    );

    wire upg_clk,upg_clk_o;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire spg_bufg;

    BUFG U1(.I(start_pg), .O(spg_bufg));
    
    // uart reset logic  
    reg upg_rst;
    always@ (posedge clk_100) begin
        if (spg_bufg) upg_rst <= 1'b0;
        if (!rst_n_) upg_rst <= 1'b1;
    end

    // final rst signal
    wire rst;
    assign rst = rst_n_ & upg_rst;

endmodule