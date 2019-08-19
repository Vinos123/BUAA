//////////////////////////////////////////////////////////////////////////////////
// Module name    uartctrl.v
// ˵����          ������ڽ��յ����ݣ����ͽ��յ������ݵ����ڣ����û�н��յ����ݣ�Ĭ�ϲ��ϵķ���
//                �洢���ַ���
//////////////////////////////////////////////////////////////////////////////////
module uart_ctrl(
      input                   clk,
		input                   rdsig,                //���ڽ���������Ч�ź�
		input      [7:0]        rxdata,               //���ڽ�������
	   output                  wrsig,                //���ڷ���ָʾ�ź�
		output     [7:0]        dataout,              //���ڷ�������
		input		  [27:0]			Num_x,
		input		  [27:0]		   Num_s,
		input		  [31:0]			cnt_high,
		input      [31:0]       cnt_low
		//output		reg				LEDD
);

reg [17:0] uart_wait;
reg [15:0] uart_cnt;
reg rx_data_valid;
reg [7:0] store [19:0];                        //�洢�����ַ�
reg [2:0] uart_stat;                           //uart״̬��
reg [8:0] k;                                   //����ָʾ���͵ĵڼ�������
reg [7:0] dataout_reg;
reg data_sel;
reg wrsig_reg;

//wire[27:0] Num_x,Num_s;
  
assign dataout = data_sel ?  dataout_reg : rxdata ;            //��������ѡ��data_sel�ߣ�ѡ��洢���ַ�����data_sel���ͣ�ѡ����յ�����
assign wrsig = data_sel ?  wrsig_reg : rdsig;                  //��������ѡ��data_sel�ߣ����ʹ洢���ַ�����data_sel���ͣ����ͽ��յ�����

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

//�洢����Ҫ���͵��ַ���
always@(posedge clk)
begin
	 store[0] <=8'h0a;                          	//���з�
	 store[1] <=Num_x[7:0];                           //�洢�ַ�w
	 store[2] <=Num_x[15:8];                          	//�洢�ַ�w
	 store[3] <=Num_x[23:16];                          	//�洢�ַ�w
	 store[4] <={4'b0,Num_x[27:24]};                          	//�洢�ַ�.
	 store[5] <=8'h0a;                          	//�洢�ַ�h                         
	 store[6] <=Num_s[7:0];                           //�洢�ַ�s
	 store[7] <=Num_s[15:8];                           //�洢�ַ�e
	 store[8] <=Num_s[23:16];                           //�洢�ַ�d
	 store[9] <={4'b0,Num_s[27:24]};                           //�洢�ַ�a
	 store[10]<=8'h0a;                           //�洢�ַ�.
	 store[11]<=cnt_high[7:0];                          	//�洢�ַ�c
	 store[12]<=cnt_high[15:8];                          	//�洢�ַ�o
	 store[13]<=cnt_high[23:16];                          	//�洢�ַ�m
	 store[14]<=cnt_high[31:24];                          	//�洢�ַ��ո�
	 store[15]<=cnt_low[7:0];                          	//�洢�ַ��ո�
	 store[16]<=cnt_low[15:8];                          	//�洢�ַ��ո�
	 store[17]<=cnt_low[23:16];                          	//�洢�ַ��ո�
	 store[18]<=cnt_low[31:24];                          	//�洢�ַ��ո�
	 store[19]<=8'h0a;                          	//���з�
end  
//���ڷ��Ϳ��ƣ�ÿ��һ��ʱ�����һ�������ַ���������  
always @(negedge clk)
begin
  if(rdsig == 1'b1) begin   //��������н��յ����ݣ�ֹͣ�����ַ���                        
		uart_wait <= 0;
		rx_data_valid <=1'b0;
  end
  else begin
    if (uart_wait ==18'h3ffff) begin                //�ȴ�һ��ʱ��(ÿ��һ��ʱ�䷢���ַ�����,������������Ըı䷢���ַ���֮���ʱ������
		uart_wait <= 0;
		rx_data_valid <=1'b1;	                      //�ȴ�ʱ�����������һ�������ַ�����Ч�ź�����
    end		
	 else begin
		uart_wait <= uart_wait+1'b1;
		rx_data_valid <=1'b0;
	 end
  end
end 
 
//////////////////////////////////////// 
//���ڷ����ַ������Ƴ������η��ʹ洢���ַ���//
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
       if (rx_data_valid == 1'b1) begin  //�����ַ�����Ч�ź�Ϊ�ߣ���ʼ�����ַ���
		    uart_stat <= 3'b001; 
			 data_sel<=1'b1; 
		 end
	 end	
	 3'b001: begin                      //����19���ַ�   
         if (k == 18 ) begin           //���͵�19���ַ�      		 
				 if(uart_cnt ==0) begin
					dataout_reg <= store[18]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;      //�����ַ�ʹ������             			
				 end	
				 else if(uart_cnt ==254) begin    //�ȴ�һ���ַ�������ɣ�����һ���ַ���ʱ��Ϊ168��ʱ�ӣ���������ȴ���ʱ����Ҫ����168
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
	     else begin                      //����ǰ18���ַ�   
				 if(uart_cnt ==0) begin      
					dataout_reg <= store[k]; 
					uart_cnt <= uart_cnt + 1'b1;
					wrsig_reg <= 1'b1;           //����ʹ��           			
				 end	
				 else if(uart_cnt ==254) begin    //�ȴ�һ�����ݷ�����ɣ�����һ���ַ���ʱ��Ϊ168��ʱ�ӣ���������ȴ���ʱ����Ҫ����168
					uart_cnt <= 0;
					wrsig_reg <= 1'b0; 
					k <= k + 1'b1;	               //k��1��������һ���ַ�        			
				 end
				 else	begin			
					 uart_cnt <= uart_cnt + 1'b1;
					 wrsig_reg <= 1'b0;  
				 end
		 end	 
	 end
	 3'b010: begin       //����finish	 
		 	uart_stat <= 3'b000;
			data_sel<=1'b0;	
	 end
	 default:uart_stat <= 3'b000;
    endcase 
  end
end

 
endmodule
