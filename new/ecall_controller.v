`include "parameters.v"

module ecall_controller (
    input clk_100,
    input clk_23,
    input finish,
    input [6:0] opcode,
    input [2:0] funct3,

    output reg ecall
);

    // pause: monopulse generate
    reg finish_reg;
    reg pause;

    always @ (posedge clk_23) begin
        finish_reg <= finish;
    end

    always @ (posedge clk_23) begin
        if (finish && !finish_reg)
            pause <= 1;
        else
            pause <= 0;
    end

    // ecall signals
    always @ (posedge clk_100, posedge pause) begin
        if (pause)
            ecall <= 0;
        else
            ecall <= (opcode == `ECALL);
    end

endmodule