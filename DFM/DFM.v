`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:28 04/27/2019 
// Design Name: 
// Module Name:    DFM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DFM(Sys_CLK,Sys_RST,Uart_Tx,D8,D9
    );

input Sys_CLK,Sys_RST,D8,D9;//系统时钟，系统复位，串口输入
//input [1:0] Switch;//开关
//output[7:0] SEG;//数码管段选
//output[1:0] COM;//数码管位选
output Uart_Tx;//串口输出

wire Realgate1,Realgate2,D8,D9,pregateout;
wire[27:0] Num_s,Num_x;
wire[31:0] cnt_high,cnt_low;
wire high_pulse,low_pulse;


//wire [7:0] Ns_1,Ns_2,Ns_3,Nx_1,Nx_2,Nx_3;

//reg [7:0] data_Tx;

//预置闸门

PreG PreG1 (
    .Sys_CLK(Sys_CLK), 
    .gateout(pregateout)
    );

	 
RealG RealG_1 (
    .D_in(D8), 
	 .pregate(pregateout),
    .Realgate(Realgate1)
    );
	 
//RealG RealG_2 (
//    .D_in(D_in2), 
//	 .pregate(pregateout),
//    .Realgate(Realgate2)
//    );	 
//	 
Count Count_fs (
    .clk(Sys_CLK), 
    .gate(Realgate1), 
    .cnt_out(Num_s)
    );//对标准频率计数
Count Count_fx (
    .clk(D8), 
    .gate(Realgate1), 
    .cnt_out(Num_x)
    );//对被测信号计数

rate rate1 (
    .clk(Sys_CLK), 
    .rst_n(Sys_RST), 
    .sig_in(D8), 
    .fgate(pregateout), 
    .cnt_high(cnt_high), 
    .cnt_low(cnt_low), 
    .high_pulse(high_pulse), 
    .low_pulse(low_pulse)
    );


uart_top uart_top1 (
    .Sys_CLK(Sys_CLK), 
//    .Uart_Rx(Uart_Rx), 
    .Uart_Tx(Uart_Tx), 
    .Sys_RST(Sys_RST),
	 .Num_x(Num_x),
	 .Num_s(Num_s),
	 .cnt_high(cnt_high),
	 .cnt_low(cnt_low)
    );



endmodule
