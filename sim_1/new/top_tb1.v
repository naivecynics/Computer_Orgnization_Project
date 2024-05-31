module top_tb1();
    reg clk, rst;
    wire [7:0] tube_scan;
    wire [7:0] tube_signal_left;
    wire [7:0] tube_signal_right;
    reg finish;
    reg [7:0] switch_in;

    wire [7:0] test_pc;
    wire [7:0] switch;

    cpu_top dut (
        .clk_100(clk),
        .rst_n(rst),
        .tube_scan(tube_scan),
        .tube_signal_left(tube_signal_left),
        .tube_signal_right(tube_signal_right),
        .finish(finish),
        .switch_in(switch_in),
        .test_pc(test_pc),
        .switch(switch)
    );

    // initial begin
    //     switch_in = 8'b00000111;
    //     clk = 0;
    //     rst = 0;
    //     finish = 0;
    //     forever #10 clk = ~clk;
    // end

    initial fork
        switch_in = 8'b00000111;
        clk = 0;
        rst = 1;
        finish = 0;
        forever #10 clk = ~clk;
        #50 rst = 0;
        #10000 rst = 1;
        // #1100 finish = 0;
    join

endmodule
