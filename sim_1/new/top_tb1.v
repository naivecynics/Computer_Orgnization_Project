module top_tb1();
    reg clk, rst_n;
    cpu_top dut (
       .clk(clk),
       .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        rst_n = 1;
        #101200 rst_n = 0;
        #101400 rst_n = 1;
        forever #10 clk = ~clk;
        #208800 $finish;
    end
endmodule
