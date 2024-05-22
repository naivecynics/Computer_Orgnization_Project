module cpu_top(
    input clk,
    input rst_n
);

    wire clk_23;    // for cpu  - 23 MHz (5 MHz)
    wire clk_10;    // for UART - 10 MHz   

    cpuclk cpuclk_inst(
        .clk_in1(clk),
        .clk_out1(clk_23),
        .clk_out2(clk_10)
    );

    datapath datapath_inst(
        .clk(clk_23),
        .rst_n(rst_n)
    );

endmodule