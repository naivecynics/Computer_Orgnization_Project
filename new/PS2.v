`timescale 1ns / 1ps

// PS2 ģ�鶨��
module PS2 (
    input           clk,      // ʱ���ź�
    input           rst,      // ��λ�ź�
    input           PS2D,     // PS2 ������
    input           PS2C,     // PS2 ʱ����
    output [15:0]   key       // �����ֵ
);

reg         ps2c;               // ʱ���źŴ�������豸
reg         ps2d;               // ����׼���ô�������豸
reg  [7:0]  ps2c_fliter;       // ���˺��ʱ���ź�
reg  [7:0]  ps2d_fliter;       // ���˺�������ź�
reg  [10:0] shift1;            // ��λ�Ĵ���1
reg  [10:0] shift2;            // ��λ�Ĵ���2

wire [15:0] tempkey;           // ��ʱ��ֵ
assign      tempkey={ shift2[8:1], shift1[8:1] };

// ����ģ��ʵ����
debounce u1(
        .clk(clk),
        .tempkey(tempkey),
        .finalkey(key)
);

// ʱ�ӱ��ش����Ĺ���
always @( posedge clk or posedge rst )
begin
    if( rst )
    begin
        ps2c            <= 1;          // ��λʱ���ź�
        ps2d            <= 1;          // ��λ�����ź�
        ps2c_fliter     <= 0;          // ��λ���˺��ʱ���ź�
        ps2d_fliter     <= 0;          // ��λ���˺�������ź�
    end
    else begin
        ps2c_fliter[7]  <= PS2C;       // ����ʱ���ź�
        ps2d_fliter[7]  <= PS2D;       // ���������ź�
        ps2c_fliter[6:0]<= ps2c_fliter[7:1]; // �ƶ����˺��ʱ���ź�
        ps2d_fliter[6:0]<= ps2d_fliter[7:1]; // �ƶ����˺�������ź�
        if( ps2c_fliter == 8'b11111111 )    // �ж�ʱ���ź��Ƿ�Ϊȫ1
            ps2c <= 1;
        else if( ps2c_fliter == 8'b00000000 )   // �ж�ʱ���ź��Ƿ�Ϊȫ0
            ps2c <= 0;
        else
            ps2c <= ps2c;               // ����ԭ״̬
        if( ps2d_fliter == 8'b11111111 )    // �ж������ź��Ƿ�Ϊȫ1
            ps2d <= 1;
        else if( ps2d_fliter == 8'b00000000 )   // �ж������ź��Ƿ�Ϊȫ0
            ps2d <= 0; 
        else
            ps2d <= ps2d;               // ����ԭ״̬
    end
end

// ʱ�ӱ��ش����Ĺ���
always @( negedge ps2c or posedge rst )
begin
    if ( rst )
    begin
        shift1 <= 0;                // ��λ��λ�Ĵ���1
        shift2 <= 0;                // ��λ��λ�Ĵ���2
    end
    else
    begin
        shift1 <= { ps2d, shift1[10:1] };      // ��λ�Ĵ���1���ƣ������µ�����
        shift2 <= { shift1[0], shift2[10:1] };  // ��λ�Ĵ���2���ƣ�������λ�Ĵ���1�����λ
    end
end

endmodule
