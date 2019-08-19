`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                   uartrx.v
//////////////////////////////////////////////////////////////////////////////////
module uart_rx(clk, rx, dataout, rdsig, dataerror, frameerror);
input clk;             //����ʱ��
input rx;              //UART��������
output dataout;        //�����������
output rdsig;
output dataerror;      //���ݳ���ָʾ
output frameerror;     //֡����ָʾ
reg[7:0] dataout;
reg rdsig, dataerror;
reg frameerror;
reg [7:0] cnt;
reg rxbuf, rxfall, receive;
parameter paritymode = 1'b0;
reg presult, idle;

always @(posedge clk)   //�����·���½���
begin
  rxbuf <= rx;
  rxfall <= rxbuf & (~rx);
end

always @(posedge clk)
begin
  if (rxfall && (~idle)) begin//��⵽��·���½��ز���ԭ����·Ϊ���У������������ݽ���  
    receive <= 1'b1;
  end
  else if(cnt == 8'd168) begin //�����������
    receive <= 1'b0;
  end
end

always @(posedge clk)
begin
  if(receive == 1'b1) begin
   case (cnt)
   8'd0:begin
      idle <= 1'b1;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd24:begin                  //���յ�0λ����
	   idle <= 1'b1;
      dataout[0] <= rx;
      presult <= paritymode^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd40:begin                 //���յ�1λ����  
	   idle <= 1'b1;
      dataout[1] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd56:begin                 //���յ�2λ����   
	   idle <= 1'b1;
      dataout[2] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd72:begin               //���յ�3λ����   
	   idle <= 1'b1;
      dataout[3] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd88:begin               //���յ�4λ����    
	   idle <= 1'b1;
      dataout[4] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd104:begin            //���յ�5λ����    
	   idle <= 1'b1;
      dataout[5] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd120:begin            //���յ�6λ����    
	   idle <= 1'b1;
      dataout[6] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b0;
   end
   8'd136:begin            //���յ�7λ����   
	   idle <= 1'b1;
      dataout[7] <= rx;
      presult <= presult^rx;
      cnt <= cnt + 8'd1;
      rdsig <= 1'b1;
   end
   8'd152:begin            //������żУ��λ    
	   idle <= 1'b1;
      if(presult == rx)
        dataerror <= 1'b0;
      else
        dataerror <= 1'b1;       //�����żУ��λ���ԣ���ʾ���ݳ���
      cnt <= cnt + 8'd1;
      rdsig <= 1'b1;
   end
   8'd168:begin
     idle <= 1'b1;
     if(1'b1 == rx)
       frameerror <= 1'b0;
     else
       frameerror <= 1'b1;      //���û�н��յ�ֹͣλ����ʾ֡����
     cnt <= cnt + 8'd1;
     rdsig <= 1'b1;
   end
   default: begin
      cnt <= cnt + 8'd1;
   end
   endcase
  end
  else begin
    cnt <= 8'd0;
    idle <= 1'b0;
    rdsig <= 1'b0;
  end
 end
endmodule
