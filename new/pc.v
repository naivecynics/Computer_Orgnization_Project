module pc(
    input clk,
    input rst_n,
    input [31:0] ALU_result,    // jump address
    input stop_flag,            // ecall
    // input stop_flag,            // ecall
    input jump_flag,
    output [31:0] inst,
    output reg [31:0] pc_out

);

    // reg [31:0] pc_out;
    reg [31:0] next_pc;

    // reg stopped;  // State to hold whether the PC is stopped

    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         stopped <= 0;  // Clear the stopped state on reset
    //     end else if (stop_flag) begin
    //         stopped <= 1;  // Set the stopped state when stop_flag is set
    //     end else if (jump_flag && !stopped) begin
    //         stopped <= 0;  // Reset stopped state on jump
    //     end
    // end

    always @(negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            pc_out <= 32'h00000000;
        end else begin
            pc_out <= next_pc;
        end
    end

    always @* begin
        // if (stop_flag == 1) begin
        //     next_pc = pc_out;
        // end else
        if (jump_flag == 1) begin
            next_pc = ALU_result;
        end else begin
            next_pc = pc_out + 4;
        end
    end


    prgrom prgrom_inst(
        .clka(clk),
        .addra(pc_out[15:2]),
        // .addra(14'b00000000000100),
        .douta(inst)
        // .ena(1)
        // .ena(!stopped && !stop_flag)
    );

endmodule