module PS2 (
    input           clk,
    input           rst_n,
    input           PS2D,
    input           PS2C,
    output [15:0]   key
);

    reg         ps2c;               //clock transfer to slave
    reg         ps2d;               //data ready to slave
    reg  [7:0]  ps2c_fliter;
    reg  [7:0]  ps2d_fliter;
    reg  [10:0] shift1;
    reg  [10:0] shift2;

    wire [15:0] tempkey;
    assign      tempkey={ shift2[8:1], shift1[8:1] };

    keyboard_debouncer keyboard_debouncer_inst(
        .clk(clk),
        .tempkey(tempkey),
        .finalkey(key)
    );

    always@( posedge clk or negedge rst_n )
    begin
        if( !rst_n )
        begin
            ps2c            <= 1;
            ps2d            <= 1;
            ps2c_fliter     <= 0;
            ps2d_fliter     <= 0;
        end
        else begin
            ps2c_fliter[7]  <= PS2C;
            ps2d_fliter[7]  <= PS2D;
            ps2c_fliter[6:0]<= ps2c_fliter[7:1];
            ps2d_fliter[6:0]<= ps2d_fliter[7:1];
            if( ps2c_fliter == 8'b11111111 )
                ps2c <= 1;
            else if( ps2c_fliter == 8'b00000000 )
                ps2c <= 0;
            else
                ps2c <= ps2c;
            if( ps2d_fliter == 8'b11111111 )
                ps2d <= 1;
            else if( ps2d_fliter == 8'b00000000 )
                ps2d <= 0; 
            else
                ps2d <= ps2d;
        end
    end

    always@( negedge ps2c or negedge rst_n )
    begin
        if ( !rst_n )
        begin
            shift1 <= 0;
            shift2 <= 0;
        end
        else
        begin
            shift1 <= { ps2d, shift1[10:1] };
            shift2 <= { shift1[0], shift2[10:1] };         
        end
    end



endmodule
