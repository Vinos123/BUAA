`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:20 04/27/2019 
// Design Name: 
// Module Name:    Count 
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
module Count(clk, gate, cnt_out
    );
input clk, gate;
output[27:0] cnt_out;

reg[27:0] cnt,cnt_out,cnt1,cnt2;
reg gatebuf;//���źŻ���

initial
begin
cnt_out<=28'd0;
end

always@(posedge clk)
begin
gatebuf<=gate;//��¼ǰһ��ʱ�ӵ����ź����
end

always@(posedge clk)
begin
if((gatebuf==1'b0)&&(gate==1'b1))//������
begin
cnt<=28'b1;
end
else if((gatebuf==1'b1)&&(gate==1'b0))//��һ��ʱ����Ϊ1����ǰʱ����Ϊ0���������ֹ
begin
cnt_out<=cnt;//�������
end
else if((gatebuf==1'b1))//�ߵ�ƽ״̬
begin
cnt<=cnt+1'b1;
end
end



endmodule
