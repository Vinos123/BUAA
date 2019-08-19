`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:55:55 04/27/2019 
// Design Name: 
// Module Name:    RealG 
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
module RealG(D_in,pregate,Realgate
    );// µº ’¢√≈
input D_in,pregate;
output Realgate;

reg Realgate;

always@(posedge D_in)
begin
Realgate<=pregate;
end


endmodule
