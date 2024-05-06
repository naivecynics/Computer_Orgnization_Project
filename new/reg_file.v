module reg_file(
    input clk,
    inout reset,
    input [4:0] R_reg_1,
    input [4:0] R_reg_2,
    input [4:0] W_reg,
    input [31:0] W_data,
    input W_en,

    output [31:0] R_data_1,
    output [31:0] R_data_2
);

    reg[31:0] register[0:31];

    assign R_data_1 = register[R_reg_1];
    assign R_data_2 = register[R_reg_2];

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 0;
            end 
        end else begin
            if (W_en && W_reg != 5'b00000) begin
                register[W_reg] <= W_data;
            end
        end
    end
    
endmodule
