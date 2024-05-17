module top_tb1();
    reg clk, rst_n;
    cpu_top dut (
       .clk(clk),
       .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        rst_n = 1;
        forever #10 clk = ~clk;
    end

endmodule