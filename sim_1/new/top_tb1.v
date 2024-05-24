module top_tb1();
    reg clk, rst;
    wire [7:0] tube_scan;
    wire [7:0] tube_signal;

    cpu_top dut (
        .clk_100(clk),
        .rst(rst),
        .tube_scan(tube_scan),
        .tube_signal(tube_signal)
    );

    initial begin
        clk = 0;
        rst = 0;
        #101200 rst = 1;
        #101400 rst = 0;
        forever #10 clk = ~clk;
        #208800 $finish;
    end
endmodule
