`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:37:25 04/28/2019 
// Design Name: 
// Module Name:    Freout 
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
module Freout(Sys_CLK,Num1,Num2,freout
    );
input Sys_CLK;//系统时钟
input[19:0] Num1,Num2;//Num1,被除数，Num2，除数

output reg[19:0] freout;//最终输出的频率

reg finish,cntflag;//标志位，用于判断此次除法是否结束
reg[19:0] temp,frebuf,cntbuf,Numbuf;

//计算部分
always@(posedge Sys_CLK)
begin

if((Num1 !=20'd0)&&(Num2 != 20'd0)&&(finish==1'b0))
begin
frebuf<=20'd25_000_000 * Num1;//标准频率*计数
temp <= Num2;
cntbuf <= 20'd1;
Numbuf <= Num2;
cntflag <=1'b1;
finish <=1'b1;//此次运算开始
end

else if((frebuf>temp)&&(cntflag==1'b1))
begin
temp <= temp + Numbuf;//如果被除数大于除数则将temp再加上被除数
cntbuf <= cntbuf + 1'b1;//商
end

else 
begin 
freout <= cntbuf;
finish <= 1'b0;
cntflag <= 1'b0;
end

end

endmodule
