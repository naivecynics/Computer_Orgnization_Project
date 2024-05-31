module process_keyboard(
    input clk,  
    input rst_n,
    input [15:0] keyboard_out,
    output reg [31:0] reg_data,
    output reg enter
);

    wire [7:0] key_data = keyboard_out[7:0];
    reg [31:0] temp_data = 0;
    reg [3:0] shift_count = 0;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            temp_data <= 0;
            shift_count <= 0;
            reg_data <= 0;
            enter <= 0;
        end
        else begin
            if(key_data == 2'h5A) begin // Enter
                reg_data <= temp_data;
                temp_data <= 0;
                shift_count <= 0;
                enter <= 1;
            end
            else begin
                enter <= 0;
                case (key_data)
                    8'h1C: begin // A
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0a;
                    end
                    8'h32: begin // B
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0b;
                    end
                    8'h21: begin // C
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0c;
                    end
                    8'h23: begin // D
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0d;
                    end
                    8'h24: begin // E
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0e;
                    end
                    8'h2B: begin // F
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h0f;
                    end
                    8'h45: begin // 0
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h00;
                    end
                    8'h16: begin // 1
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h01;
                    end
                    8'h1E: begin // 2
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h02;
                    end
                    8'h26: begin // 3
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h03;
                    end
                    8'h25: begin // 4
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h04;
                    end
                    8'h2E: begin // 5
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h05;
                    end
                    8'h36: begin // 6
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h06;
                    end
                    8'h3D: begin // 7
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h07;
                    end
                    8'h3E: begin // 8
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h08;
                    end
                    8'h46: begin // 9
                        shift_count <= shift_count + 1;
                        temp_data <= temp_data << 4 + 2'h09;
                    end
                    default: begin
                        
                    end
                endcase
            end
        end
    end

endmodule