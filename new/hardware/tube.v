`include "../parameters.v"

module tube(
    input clk,      // 100MHz
    input reset,
    input [31:0] reg_data,

    output reg [7:0] tube_scan,
    output reg [7:0] tube_signal
);

    // parameter reg_data = 32'h56789abc; 

    // slow clock

    reg slow_clk;  // 1000Hz
    reg [31:0] slow_cnt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
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

    always @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            tube_scan <= 8'b1111_1110;
        end
        else begin
            tube_scan <= {tube_scan[6:0], tube_scan[7]};
        end
    end

    reg [4:0] half_byte_in;

    always @* begin
        case (tube_scan)
            8'b1111_1110: half_byte_in = {1, reg_data[3:0]};        
        endcase
    end

    // tube signal

    always @* begin
        case (half_byte_in)
            4'b0000: tube_signal = `ZERO;
            4'b0001: tube_signal = `ONE;
            4'b0010: tube_signal = `TWO;
            4'b0011: tube_signal = `THREE;
            4'b0100: tube_signal = `FOUR;
            4'b0101: tube_signal = `FIVE;
            4'b0110: tube_signal = `SIX;
            4'b0111: tube_signal = `SEVEN;
            4'b1000: tube_signal = `EIGHT;
            4'b1001: tube_signal = `NINE;
            4'b1010: tube_signal = `A;
            4'b1011: tube_signal = `B;
            4'b1100: tube_signal = `C;
            4'b1101: tube_signal = `D;
            4'b1110: tube_signal = `E;
            4'b1111: tube_signal = `F;
        endcase
    end

endmodule
