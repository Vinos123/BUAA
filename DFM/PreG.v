`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:04 04/27/2019 
// Design Name: 
// Module Name:    PreG 
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
module PreG(Sys_CLK,gateout,cnt
    );//‘§÷√’¢√≈
input Sys_CLK;
output gateout;
output[27:0] cnt;


reg[27:0] cnt1;

reg gatebuf;

initial
begin

gatebuf <= 1'b0;
cnt1 <=28'd0;
end

always@(posedge Sys_CLK)
begin
	if(cnt1==28'd25_000_000)
	begin
	gatebuf<=~gatebuf;
	cnt1<=28'd0;
	end
	
	else 
	begin
	cnt1<=cnt1+28'd1;
	end
	
end

assign gateout =gatebuf;
assign cnt=cnt1;


endmodule
