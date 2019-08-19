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
input Sys_CLK;//ϵͳʱ��
input[19:0] Num1,Num2;//Num1,��������Num2������

output reg[19:0] freout;//���������Ƶ��

reg finish,cntflag;//��־λ�������жϴ˴γ����Ƿ����
reg[19:0] temp,frebuf,cntbuf,Numbuf;

//���㲿��
always@(posedge Sys_CLK)
begin

if((Num1 !=20'd0)&&(Num2 != 20'd0)&&(finish==1'b0))
begin
frebuf<=20'd25_000_000 * Num1;//��׼Ƶ��*����
temp <= Num2;
cntbuf <= 20'd1;
Numbuf <= Num2;
cntflag <=1'b1;
finish <=1'b1;//�˴����㿪ʼ
end

else if((frebuf>temp)&&(cntflag==1'b1))
begin
temp <= temp + Numbuf;//������������ڳ�����temp�ټ��ϱ�����
cntbuf <= cntbuf + 1'b1;//��
end

else 
begin 
freout <= cntbuf;
finish <= 1'b0;
cntflag <= 1'b0;
end

end

endmodule
