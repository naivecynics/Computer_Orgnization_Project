module top_tbc();
    wire clk;
    wire rst;

    cpu_top uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

endmodule
