`include parameters.v

module tube(
    input clk,      // 100MHz
    input reset,
    input [31:0] reg_data,

    output reg tube_scan [7:0],
    output reg tube_signal [7:0]
);

    // slow clock

    wire slow_clk;  // 1000Hz
    reg [31:0] slow_cnt = 0;
    tube_scan = 8'b1111_1110;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            slow_cnt <= 0;
            slow_clk <= 0;
        end else begin
            // 100MHz / 50000 / 2 ≈ 1000Hz
            if (slow_cnt == `TUBE_CNT) begin  
                slow_cnt <= 0;
                slow_clk <= ~slow_clk;  
            end else begin
                slow_cnt <= slow_cnt + 1;
            end
        end
    end

    // scan signal

    wire [3:0] half_byte_in;

    always @(posedge slow_clk) begin

        tube_scan <= {tube_scan[6:0], tube_scan[7]};

        case (tube_scan[7:0])
            7'b1111_1110: half_byte_in <= reg_data[3:0];
            7'b1111_1101: half_byte_in <= reg_data[7:4];
            7'b1111_1011: half_byte_in <= reg_data[11:8];
            7'b1111_0111: half_byte_in <= reg_data[15:12];
            7'b1110_1111: half_byte_in <= reg_data[19:16];
            7'b1101_1111: half_byte_in <= reg_data[23:20];
            7'b1011_1111: half_byte_in <= reg_data[27:24];
            7'b0111_1111: half_byte_in <= reg_data[31:28];
        endcase
    end

    // tube signal

    always @* begin
        case (half_byte_in)
            4'0000: tube_signal <= `ZERO;
            4'0001: tube_signal <= `ONE;
            4'0010: tube_signal <= `TWO;
            4'0011: tube_signal <= `THREE;
            4'0100: tube_signal <= `FOUR;
            4'0101: tube_signal <= `FIVE;
            4'0110: tube_signal <= `SIX;
            4'0111: tube_signal <= `SEVEN;
            4'1000: tube_signal <= `EIGHT;
            4'1001: tube_signal <= `NINE;
            4'1010: tube_signal <= `A;
            4'1011: tube_signal <= `B;
            4'1100: tube_signal <= `C;
            4'1101: tube_signal <= `D;
            4'1110: tube_signal <= `E;
            4'1111: tube_signal <= `F;
        endcase
    end

endmodule