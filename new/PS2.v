`timescale 1ns / 1ps

// PS2 模块定义
module PS2 (
    input           clk,      // 时钟信号
    input           rst,      // 复位信号
    input           PS2D,     // PS2 数据线
    input           PS2C,     // PS2 时钟线
    output [15:0]   key       // 输出键值
);

reg         ps2c;               // 时钟信号传输给从设备
reg         ps2d;               // 数据准备好传输给从设备
reg  [7:0]  ps2c_fliter;       // 过滤后的时钟信号
reg  [7:0]  ps2d_fliter;       // 过滤后的数据信号
reg  [10:0] shift1;            // 移位寄存器1
reg  [10:0] shift2;            // 移位寄存器2

wire [15:0] tempkey;           // 临时键值
assign      tempkey={ shift2[8:1], shift1[8:1] };

// 消抖模块实例化
debouncer u1(
        .clk(clk),
        .tempkey(tempkey),
        .finalkey(key)
);

// 时钟边沿触发的过程
always @( posedge clk or posedge rst )
begin
    if( rst )
    begin
        ps2c            <= 1;          // 复位时钟信号
        ps2d            <= 1;          // 复位数据信号
        ps2c_fliter     <= 0;          // 复位过滤后的时钟信号
        ps2d_fliter     <= 0;          // 复位过滤后的数据信号
    end
    else begin
        ps2c_fliter[7]  <= PS2C;       // 过滤时钟信号
        ps2d_fliter[7]  <= PS2D;       // 过滤数据信号
        ps2c_fliter[6:0]<= ps2c_fliter[7:1]; // 移动过滤后的时钟信号
        ps2d_fliter[6:0]<= ps2d_fliter[7:1]; // 移动过滤后的数据信号
        if( ps2c_fliter == 8'b11111111 )    // 判断时钟信号是否为全1
            ps2c <= 1;
        else if( ps2c_fliter == 8'b00000000 )   // 判断时钟信号是否为全0
            ps2c <= 0;
        else
            ps2c <= ps2c;               // 保持原状态
        if( ps2d_fliter == 8'b11111111 )    // 判断数据信号是否为全1
            ps2d <= 1;
        else if( ps2d_fliter == 8'b00000000 )   // 判断数据信号是否为全0
            ps2d <= 0; 
        else
            ps2d <= ps2d;               // 保持原状态
    end
end

// 时钟边沿触发的过程
always @( negedge ps2c or posedge rst )
begin
    if ( rst )
    begin
        shift1 <= 0;                // 复位移位寄存器1
        shift2 <= 0;                // 复位移位寄存器2
    end
    else
    begin
        shift1 <= { ps2d, shift1[10:1] };      // 移位寄存器1左移，加入新的数据
        shift2 <= { shift1[0], shift2[10:1] };  // 移位寄存器2左移，加入移位寄存器1的最低位
    end
end

endmodule
