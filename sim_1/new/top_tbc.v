module top_tbc();
    reg clk;
    reg rst_n;

    cpu_top uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    initial begin
        clk = 0;
        rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;
        forever begin
            #5 clk = ~clk;
        end
    end

endmodule
