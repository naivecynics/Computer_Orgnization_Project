module reg_file(
    input clk,
    input reset,
    input stop_flag,
    input [4:0] R_reg_1,
    input [4:0] R_reg_2,
    input [4:0] W_reg,
    input [31:0] W_data,
    input W_en,
    input [6:0] func7,
    input [2:0] func3,

    output reg [31:0] R_data_1,
    output reg [31:0] R_data_2,
    output [31:0] reg_map_tube
);

    reg [31:0] register[0:31];

    // directly map last register to tube
    assign reg_map_tube = register[5'b11111];

    always @(*) begin
        //sb
        if (func7 == 7'b0100011 && func3 == 3'b000) begin
            R_data_2 = {{24{register[R_reg_2][7]}},register[R_reg_2][7:0]};
        end
        //sh
        else if (func7 == 7'b0100011 && func3 == 3'b001) begin
            R_data_2 = {{16{register[R_reg_2][15]}},register[R_reg_2][15:0]};
        end
        //sw
        else begin
            R_data_2 = register[R_reg_2];
            R_data_1 = register[R_reg_1];
        end
    end

    integer i;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 0;
            end 
        end else begin
            if (W_en && W_reg != 5'b00000) begin
                //lb
                if (func7 == 7'b0000011 && func3 == 3'b000) begin
                    register[W_reg] <= {{24{W_data[7]}}, W_data[7:0]};
                end
                //lh
                else if (func7 == 7'b0000011 && func3 == 3'b001) begin
                    register[W_reg] <= {{16{W_data[15]}}, W_data[15:0]};
                end
                //lbu
                else if (func7 == 7'b0000011 && func3 == 3'b100) begin
                    register[W_reg] <= {{24{1'b0}}, W_data[7:0]};
                end
                //lhu
                else if (func7 == 7'b0000011 && func3 == 3'b101) begin
                    register[W_reg] <= {{16{1'b0}}, W_data[15:0]};
                end
                // ecall
                else if (stop_flag) begin
                    // read the data to a0 register
                    register[5'b01010] <= W_data;
                end
                else begin
                    register[W_reg] <= W_data;
                end
            end
        end
    end
    
endmodule