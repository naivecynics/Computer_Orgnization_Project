`include "../parameters.v"

module tube(
    input clk,      // 100MHz
    input rst_n,
    input [31:0] reg_data,

    output reg [7:0] tube_scan,
    output reg [7:0] tube_signal_left,
    output reg [7:0] tube_signal_right
);

    // parameter reg_data = 32'h56789abc; 

    // slow clock

    reg slow_clk;  // 1000Hz
    reg [31:0] slow_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            slow_cnt <= 0;
            slow_clk <= 0;
        end else begin
            // 100MHz / 50000 / 2 ≈ 1000Hz
            if (slow_cnt == `TUBE_SCAN) begin  
                slow_cnt <= 0;
                slow_clk <= ~slow_clk;  
            end else begin
                slow_cnt <= slow_cnt + 1;
            end
        end
    end

    // scan signal

    always @(posedge slow_clk or negedge rst_n) begin
        if (!rst_n) begin
            // tube_scan <= ~8'b1111_1110;
            tube_scan <= ~8'b1110_1110;
        end
        else begin
            // tube_scan <= {tube_scan[6:0], tube_scan[7]};
            tube_scan <= {tube_scan[6:4], tube_scan[7], tube_scan[2:0], tube_scan[3]};
        end
    end

    reg [3:0] input_left;
    reg [3:0] input_right;

    always @* begin
        case (tube_scan)
            ~8'b1110_1110: begin
                input_left = reg_data[19:16];
                input_right = reg_data[3:0];
            end
            ~8'b1101_1101: begin
                input_left = reg_data[23:20];
                input_right = reg_data[7:4];
            end
            ~8'b1011_1011: begin
                input_left = reg_data[27:24];
                input_right = reg_data[11:8];
            end
            ~8'b0111_0111: begin
                input_left = reg_data[31:28];
                input_right = reg_data[15:12];
            end
            default: begin
                input_left = 4'b0000;
                input_right = 4'b0000;
            end
        endcase
    end

    // tube signal

    always @* begin
        case (input_left)
            4'b0000: tube_signal_left = `ZERO;
            4'b0001: tube_signal_left = `ONE;
            4'b0010: tube_signal_left = `TWO;
            4'b0011: tube_signal_left = `THREE;
            4'b0100: tube_signal_left = `FOUR;
            4'b0101: tube_signal_left = `FIVE;
            4'b0110: tube_signal_left = `SIX;
            4'b0111: tube_signal_left = `SEVEN;
            4'b1000: tube_signal_left = `EIGHT;
            4'b1001: tube_signal_left = `NINE;
            4'b1010: tube_signal_left = `A;
            4'b1011: tube_signal_left = `B;
            4'b1100: tube_signal_left = `C;
            4'b1101: tube_signal_left = `D;
            4'b1110: tube_signal_left = `E;
            4'b1111: tube_signal_left = `F;
        endcase
    end

    always @* begin
        case (input_right)
            4'b0000: tube_signal_right = `ZERO;
            4'b0001: tube_signal_right = `ONE;
            4'b0010: tube_signal_right = `TWO;
            4'b0011: tube_signal_right = `THREE;
            4'b0100: tube_signal_right = `FOUR;
            4'b0101: tube_signal_right = `FIVE;
            4'b0110: tube_signal_right = `SIX;
            4'b0111: tube_signal_right = `SEVEN;
            4'b1000: tube_signal_right = `EIGHT;
            4'b1001: tube_signal_right = `NINE;
            4'b1010: tube_signal_right = `A;
            4'b1011: tube_signal_right = `B;
            4'b1100: tube_signal_right = `C;
            4'b1101: tube_signal_right = `D;
            4'b1110: tube_signal_right = `E;
            4'b1111: tube_signal_right = `F;
        endcase
    end

endmodule
