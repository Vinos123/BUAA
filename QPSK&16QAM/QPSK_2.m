clear all
close all
symbols_per_carrier=7;
carrier_count=1024;%子载波数
L=6;
SNR=20;
PrefixRatio=1/4;
bits_per_symbol=2;
%=====================图像处理====================
Pic=imread('/Users/kobezhe/Desktop/IMG_7905.JPG');%图片读入为矩阵
[x,y,z]=size(Pic);%读取图片矩阵的大小
% Pic_1=reshape(Pic,x*y*z,1);
%每次发送多少个OFDM符号
C_1=de2bi(Pic);%将十进制矩阵转为二进制
[m,n]=size(C_1);%读取矩阵的大小
bit_stream_before=reshape(C_1,m*n,1);
bit_stream(1:m*n)=bit_stream_before;
num_symbol=symbols_per_carrier*carrier_count*bits_per_symbol;
%=====================传入================
times=ceil(length(bit_stream)/num_symbol);
sum_BER=0;
BER=zeros(1,times);
for ii=1:times-1
    in_bit_stream=bit_stream((1+(ii-1)*num_symbol):ii*num_symbol);
    [BER(ii),receive_stream((1+(ii-1)*num_symbol):ii*num_symbol),...
        Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp,complex_carrier_matrix_temp]=...
        QPSK(L,SNR,PrefixRatio,in_bit_stream,symbols_per_carrier);%传入各个参数
    if ii<2
        Rx_real=Rx_real_temp;
        Rx_imag=Rx_imag_temp;
        Rx_real_before=Rx_real_before_temp;
        Rx_imag_before=Rx_imag_before_temp;
        complex_carrier_matrix=complex_carrier_matrix_temp;%为星座图参量赋初值
    elseif ii<50
        Rx_real=cat(1,Rx_real,Rx_real_temp);
        Rx_imag=cat(1,Rx_imag,Rx_imag_temp);
        Rx_real_before=cat(1,Rx_real_before,Rx_real_before_temp);
        Rx_imag_before=cat(1,Rx_imag_before,Rx_imag_before_temp);
        complex_carrier_matrix=cat(1,complex_carrier_matrix,complex_carrier_matrix_temp);%不同帧得到的矩阵进行拼接；
    end
    sum_BER=sum_BER+BER(ii)*(num_symbol);
end      
ii=times;
last_bit_stream=bit_stream((1+(ii-1)*num_symbol):end);
[BER(ii),receive_stream((1+(ii-1)*num_symbol):((1+(ii-1)*num_symbol)+length(last_bit_stream)-1)),...
    Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp]=...
    QPSK(L,SNR,PrefixRatio,last_bit_stream,symbols_per_carrier);
figure(1);
plot(complex_carrier_matrix,'*r');%QPSK调制后星座图
title('QPSK调制后星座图')
axis([-3, 3, -3, 3]);
grid on
figure(2);
subplot(2,1,1);
polar(Rx_real_before,Rx_imag_before,'bd');
title('极坐标下的接收信号的星座图-频域均衡前')
subplot(2,1,2);
polar(Rx_real, Rx_imag,'bd');%极坐标坐标下画出接收信号的星座图
title('极坐标下的接收信号的星座图-频域均衡后');
[M, N]=pol2cart(Rx_real, Rx_imag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_real_before, Rx_imag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
figure(3);
subplot(2,1,1);
plot(Rx_complex_carrier_matrix_before,'*r');%XY坐标接收信号的星座图
title('XY坐标接收信号的星座图-频域均衡前')
axis([-1, 1, -1, 1]);
grid on
subplot(2,1,2);
plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
title('XY坐标接收信号的星座图-频域均衡后')
axis([-1, 1, -1, 1]);
grid on
sum_BER=sum_BER+BER(ii)*length(last_bit_stream);
BER=sum_BER/length(bit_stream)
%================还原图片============================================
Pic_out_test=reshape(receive_stream,length(bit_stream_before)/8,8);
Pic_out_stream=bi2de(Pic_out_test);
Pic_out=reshape(Pic_out_stream,x,y,z);
Pic_result=uint8(Pic_out);
imwrite(Pic_result,'/Users/kobezhe/Desktop/result.JPG');
figure(4);
imshow('/Users/kobezhe/Desktop/result.JPG');

