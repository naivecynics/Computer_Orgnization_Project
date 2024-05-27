`include "parameters.v"

module ecall_controller (
    input clk,
    input finish,
    input [6:0] opcode,
    input [2:0] funct3,

    output reg ecall
);

    reg finish_one;
    reg pause;

    always @ (posedge clk) begin
        finish_one <= finish;
    end

    always @ (posedge clk) begin
        if (finish && finish_one)
            pause <= 1;
        else
            pause <= 0;
    end

    always @ (posedge clk, posedge pause) begin
        if (pause)
            ecall <= 0;
        else
            ecall <= (opcode == `ECALL);
    end

    // always @ (posedge clk, posedge finish) begin
    //     if (finish) begin
    //         ecall <= 0;
    //     end else begin
    //         ecall <= (opcode == `ECALL);
    //     end
    // end

endmodule