module process_keyboard(
    input clk,  
    input rst_n,
    input [15:0] keyboard_out,
    output reg [31:0] reg_data,
    output reg [31:0] temp_data,
    output reg mono_clk,
    output reg enter
);

    wire [7:0] key_data;
    wire [7:0] last_key_data;
    
    assign key_data = keyboard_out[7:0];
    assign last_key_data = keyboard_out[15:8];

    // monopause clk

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mono_clk <= 0;
        end
        else begin
            if (last_key_data == 8'hF0) begin
                mono_clk <= 0;
            end
            else begin
                mono_clk <= 1;
            end
        end
    end

    // key mapping

    // idle
    reg [3:0] shift_count = 0;

    always @(negedge mono_clk or negedge rst_n) begin
        if(!rst_n) begin
            temp_data <= 0;
            shift_count <= 0;
            reg_data <= 0;
            enter <= 0;
        end
        else begin
            if(key_data == 8'h5A) begin // Enter
                reg_data <= temp_data;
                temp_data <= 0;
                shift_count <= 0;
                enter <= 1;
            end
            else begin
                enter <= 0;
                case (key_data)
                    8'h66: begin // Backspace
                        shift_count <= shift_count - 1;
                        temp_data <= temp_data >> 4;
                    end
                    8'h1C: begin // A
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'ha;
                    end
                    8'h32: begin // B
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'hb;
                    end
                    8'h21: begin // C
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'hc;
                    end
                    8'h23: begin // D
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'hd;
                    end
                    8'h24: begin // E
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'he;
                    end
                    8'h2B: begin // F
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'hf;
                    end
                    8'h45: begin // 0
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h0;
                    end
                    8'h16: begin // 1
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h1;
                    end
                    8'h1E: begin // 2
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h2;
                    end
                    8'h26: begin // 3
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h3;
                    end
                    8'h25: begin // 4
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h4;
                    end
                    8'h2E: begin // 5
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h5;
                    end
                    8'h36: begin // 6
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h6;
                    end
                    8'h3D: begin // 7
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h7;
                    end
                    8'h3E: begin // 8
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h8;
                    end
                    8'h46: begin // 9
                        shift_count <= shift_count + 1;
                        temp_data <= (temp_data << 4) + 4'h9;
                    end
                    default: begin
                        temp_data <= temp_data;
                    end
                endcase
            end
        end
    end

endmodule