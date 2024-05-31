`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/19 23:27:55
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debounce(
input sys_clk_i,
	input ext_rst_n,
	input [15:0]key_h, //按键未按下时高电平，按下后低电平
	output reg [15:0]key_out
    );
wire key ; //用于按键触发判断
reg[15:0] key_r ; //缓存标志key的信息
assign key = key_h[15]&key_h[14]&key_h[13]&key_h[12]&key_h[11]&key_h[10]&key_h[9]&key_h[8]&key_h[7]&key_h[6]&key_h[5]&key_h[4]&key_h[3]&key_h[2]&key_h[1]&key_h[0] ;
always@(posedge sys_clk_i or negedge ext_rst_n)begin
	if(!ext_rst_n) key_r <= 16'b1111_1111_1111_1111;
	else key_r <= {key_r[14:0],key}; //左移寄存器，最低位保存按键最新的状态
end

wire key_neg = key_r[15] & ~key_r[14] ; //key_r[14]是现态，[15]是前一个状态，采用左移寄存器
wire key_pos = ~key_r[15] & key_r[14] ;//按键全部被释放
//20ms计数，一旦出现按键按下或释放重新开始计数
reg[19:0]cnt ;
always@(posedge sys_clk_i or negedge ext_rst_n)begin
	if(!ext_rst_n) cnt <= 20'd0 ;
	else if(key_neg || key_pos ) cnt <= 20'd0 ;
	else if(cnt == 20'd999_999) cnt <= 20'd0 ;
	else cnt <= cnt + 20'd1 ;
end

reg[15:0]key_value[1:0] ;
always@(posedge sys_clk_i or negedge ext_rst_n)begin
	if(!ext_rst_n)begin
		key_value[0] = 16'b1111_1111_1111_1111; //保存最新的状态
		key_value[1] = 16'b1111_1111_1111_1111;
	end
	else begin
		if(cnt == 20'd999_999) key_value[0] = key_h ;
		else key_value[1] <= key_value[0];
	end
end
wire[15:0]key_press ;
assign key_press = key_value[1] & ~key_value[0] ;
//led状态控制模块
always@(posedge sys_clk_i or negedge ext_rst_n)begin
	if(!ext_rst_n) key_out <= 16'b1111_1111_1111_1111 ;
	else begin
		if(key_press[0]) key_out[0] <= ~key_out[0];
		if(key_press[1]) key_out[1] <= ~key_out[1];
		if(key_press[2]) key_out[2] <= ~key_out[2];
		if(key_press[3]) key_out[3] <= ~key_out[3];
		if(key_press[4]) key_out[4] <= ~key_out[4];
		if(key_press[5]) key_out[5] <= ~key_out[5];
		if(key_press[6]) key_out[6] <= ~key_out[6];
		if(key_press[7]) key_out[7] <= ~key_out[7];
		if(key_press[8]) key_out[8] <= ~key_out[8];
		if(key_press[9]) key_out[9] <= ~key_out[9];
		if(key_press[10]) key_out[10] <= ~key_out[10];
		if(key_press[11]) key_out[11] <= ~key_out[11];
		if(key_press[12]) key_out[12] <= ~key_out[12];
		if(key_press[13]) key_out[13] <= ~key_out[13];
		if(key_press[14]) key_out[14] <= ~key_out[14];
		if(key_press[15]) key_out[15] <= ~key_out[15];
	end
end
endmodule

