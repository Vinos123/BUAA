//////////////////////////////////////////////////////////////////////////////////
// Module name    uartctrl.v
// 说明：          如果串口接收到数据，发送接收到的数据到串口，如果没有接收到数据，默认不断的发送
//                存储的字符串
//////////////////////////////////////////////////////////////////////////////////
module uart_ctrl(
      input                   clk,
		input                   rdsig,                //串口接收数据有效信号
		input      [7:0]        rxdata,               //串口接收数据
	   output                  wrsig,                //串口发送指示信号
		output     [7:0]        dataout,              //串口发送数据
		input		  [27:0]			Num_x,
		input		  [27:0]		   Num_s,
		input		  [31:0]			cnt_high,
		input      [31:0]       cnt_low
		//output		reg				LEDD
);

reg [17:0] uart_wait;
reg [15:0] uart_cnt;
reg rx_data_valid;
reg [7:0] store [19:0];                        //存储发送字符
reg [2:0] uart_stat;                           //uart状态机
reg [8:0] k;                                   //用于指示发送的第几个数据
reg [7:0] dataout_reg;
reg data_sel;
reg wrsig_reg;

//wire[27:0] Num_x,Num_s;
  
assign dataout = data_sel ?  dataout_reg : rxdata ;            //发送数据选择：data_sel高，选择存储的字符串，data_sel：低，选择接收的数据
assign wrsig = data_sel ?  wrsig_reg : rdsig;                  //发送请求选择：data_sel高，发送存储的字符串，data_sel：低，发送接收的数据

//always @(posedge clk)
//begin
//	if(rdsig==1) begin
//		case(rxdata)
//		8'd1:begin
//			LEDD=1;
//			end
//		8'd2:begin
//			LEDD=0;
//			end
//		default: LEDD=1;
//		endcase
//	end
//end

//存储串口要发送的字符串
always@(posedge clk)
begin
	 store[0] <=8'h0a;                          	//换行符
	 store[1] <=Num_x[7:0];                           //存储字符w
	 store[2] <=Num_x[15:8];                          	//存储字符w
	 store[3] <=Num_x[23:16];                          	//存储字符w
	 store[4] <={4'b0,Num_x[27:24]};                          	//存储字符.
	 store[5] <=8'h0a;                          	//存储字符h                         
	 store[6] <=Num_s[7:0];                           //存储字符s
	 store[7] <=Num_s[15:8];                           //存储字符e
	 store[8] <=Num_s[23:16];                           //存储字符d
	 store[9] <={4'b0,Num_s[27:24]};                           //存储字符a
	 store[10]<=8'h0a;                           //存储字符.
	 store[11]<=cnt_high[7:0];                          	//存储字符c
	 store[12]<=cnt_high[15:8];                          	//存储字符o
	 store[13]<=cnt_high[23:16];                          	//存储字符m
	 store[14]<=cnt_high[31:24];                          	//存储字符空格
	 store[15]<=cnt_low[7:0];                          	//存储字符空格
	 store[16]<=cnt_low[15:8];                          	//存储字符空格
	 store[17]<=cnt_low[23:16];                          	//存储字符空格
	 store[18]<=cnt_low[31:24];                          	//存储字符空格
	 store[19]<=8'h0a;                          	//换行符
end  
//串口发送控制，每隔一段时间产生一个发送字符串的命令  
always @(negedge clk)
begin
  if(rdsig == 1'b1) begin   //如果串口有接收到数据，停止发送字符串                        
		uart_wait <= 0;
		rx_data_valid <=1'b0;
  end
  else begin
    if (uart_wait ==18'h3ffff) begin                //等待一段时间(每隔一段时间发送字符串）,调整这参数可以改变发送字符串之间的时间间隔。
		uart_wait <= 0;
		rx_data_valid <=1'b1;	                      //等待时间结束，产生一个发送字符串有效信号脉冲
    end		
	 else begin
		uart_wait <= uart_wait+1'b1;
		rx_data_valid <=1'b0;
	 end
  end
end 
 
//////////////////////////////////////// 
//串口发送字符串控制程序，依次发送存储的字符串//
////////////////////////////////////////	
always @(posedge clk)
begin
  if(rdsig == 1'b1) begin   
		uart_cnt <= 0;
		uart_stat <= 3'b000; 
		data_sel<=1'b0;
		k<=0;
  end
  else begin
  	 case(uart_stat)
	 3'b000: begin               
       if (rx_data_valid == 1'b1) begin  //发送字符串有效信号为高，开始发送字符串
		    uart_stat <= 3'b001; 
			 data_sel<=1'b1; 
		 end
	 end	
	 3'b001: begin                      //发送19个字符   
         if (k == 18 ) begin           //发送第19个字符      		 
				 if(uart_cnt ==0) begin
					dataout_reg <= store[18]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;      //发送字符使能脉冲             			
				 end	
				 else if(uart_cnt ==254) begin    //等待一个字符发送完成，发送一个字符的时间为168个时钟，所以这里等待的时间需要大于168
					uart_cnt <= 0;
					wrsig_reg <= 1'b0; 				
					uart_stat <= 3'b010; 
					k <= 0;
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig_reg <= 1'b0;  
				 end
		  end
	     else begin                      //发送前18个字符   
				 if(uart_cnt ==0) begin      
					dataout_reg <= store[k]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;           //发送使能           			
				 end	
				 else if(uart_cnt ==254) begin    //等待一个数据发送完成，发送一个字符的时间为168个时钟，所以这里等待的时间需要大于168
					uart_cnt <= 0;
					wrsig_reg <= 1'b0; 
					k <= k + 1'b1;	               //k加1，发送下一个字符        			
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig_reg <= 1'b0;  
				 end
		 end	 
	 end
	 3'b010: begin       //发送finish	 
		 	uart_stat <= 3'b000;
			data_sel<=1'b0;	
	 end
	 default:uart_stat <= 3'b000;
    endcase 
  end
end

 
endmodule
