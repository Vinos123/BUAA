`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    uart_test 
//
//////////////////////////////////////////////////////////////////////////////////
module uart_top(Sys_CLK, Uart_Rx, Uart_Tx, Sys_RST,Num_x,Num_s,cnt_high,cnt_low);
input Sys_CLK;
input Sys_RST;
input Uart_Rx;
output Uart_Tx;
input[27:0] Num_x,Num_s;
input[31:0] cnt_high,cnt_low;
//output LED;
wire clk;       //clock for 9600 uart port
wire [7:0] txdata,rxdata;
wire idle;
wire dataerror;
wire frameerror;
wire[27:0] Num_x,Num_s;
wire[31:0] cnt_high,cnt_low;


uart_clk u0 (
		.clk50                   (Sys_CLK),                           
		.clkout                  (clk)                    
 );

uart_rx u1 (
		.clk                     (clk),  
      .rx	                   (Uart_Rx),  	
		.dataout                 (rxdata),                       
      .rdsig                   (rdsig),
		.dataerror               (dataerror),
		.frameerror              (frameerror)
);

uart_tx u2 (
		.clk                     (clk),                           
		.datain                  (txdata),
      .wrsig                   (wrsig), 
      .idle                    (idle), 	
	   .tx                      (Uart_Tx)		
 );

uart_ctrl u3 (
		.clk                     (clk),                           
		.rdsig                   (rdsig),
      .rxdata                  (rxdata), 		
      .wrsig                   (wrsig), 
      .dataout                 (txdata),
		.Num_x						 (Num_x),
		.Num_s						 (Num_s),
		.cnt_high					 (cnt_high),
		.cnt_low						 (cnt_low)
		//.LEDD							 (LED)
 );
 

endmodule

