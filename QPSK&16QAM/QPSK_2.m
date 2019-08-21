clear all
close all
symbols_per_carrier=7;
carrier_count=1024;%���ز���
L=6;
SNR=20;
PrefixRatio=1/4;
bits_per_symbol=2;
%=====================ͼ����====================
Pic=imread('/Users/kobezhe/Desktop/IMG_7905.JPG');%ͼƬ����Ϊ����
[x,y,z]=size(Pic);%��ȡͼƬ����Ĵ�С
% Pic_1=reshape(Pic,x*y*z,1);
%ÿ�η��Ͷ��ٸ�OFDM����
C_1=de2bi(Pic);%��ʮ���ƾ���תΪ������
[m,n]=size(C_1);%��ȡ����Ĵ�С
bit_stream_before=reshape(C_1,m*n,1);
bit_stream(1:m*n)=bit_stream_before;
num_symbol=symbols_per_carrier*carrier_count*bits_per_symbol;
%=====================����================
times=ceil(length(bit_stream)/num_symbol);
sum_BER=0;
BER=zeros(1,times);
for ii=1:times-1
    in_bit_stream=bit_stream((1+(ii-1)*num_symbol):ii*num_symbol);
    [BER(ii),receive_stream((1+(ii-1)*num_symbol):ii*num_symbol),...
        Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp,complex_carrier_matrix_temp]=...
        QPSK(L,SNR,PrefixRatio,in_bit_stream,symbols_per_carrier);%�����������
    if ii<2
        Rx_real=Rx_real_temp;
        Rx_imag=Rx_imag_temp;
        Rx_real_before=Rx_real_before_temp;
        Rx_imag_before=Rx_imag_before_temp;
        complex_carrier_matrix=complex_carrier_matrix_temp;%Ϊ����ͼ��������ֵ
    elseif ii<50
        Rx_real=cat(1,Rx_real,Rx_real_temp);
        Rx_imag=cat(1,Rx_imag,Rx_imag_temp);
        Rx_real_before=cat(1,Rx_real_before,Rx_real_before_temp);
        Rx_imag_before=cat(1,Rx_imag_before,Rx_imag_before_temp);
        complex_carrier_matrix=cat(1,complex_carrier_matrix,complex_carrier_matrix_temp);%��ͬ֡�õ��ľ������ƴ�ӣ�
    end
    sum_BER=sum_BER+BER(ii)*(num_symbol);
end      
ii=times;
last_bit_stream=bit_stream((1+(ii-1)*num_symbol):end);
[BER(ii),receive_stream((1+(ii-1)*num_symbol):((1+(ii-1)*num_symbol)+length(last_bit_stream)-1)),...
    Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp]=...
    QPSK(L,SNR,PrefixRatio,last_bit_stream,symbols_per_carrier);
figure(1);
plot(complex_carrier_matrix,'*r');%QPSK���ƺ�����ͼ
title('QPSK���ƺ�����ͼ')
axis([-3, 3, -3, 3]);
grid on
figure(2);
subplot(2,1,1);
polar(Rx_real_before,Rx_imag_before,'bd');
title('�������µĽ����źŵ�����ͼ-Ƶ�����ǰ')
subplot(2,1,2);
polar(Rx_real, Rx_imag,'bd');%�����������»��������źŵ�����ͼ
title('�������µĽ����źŵ�����ͼ-Ƶ������');
[M, N]=pol2cart(Rx_real, Rx_imag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_real_before, Rx_imag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
figure(3);
subplot(2,1,1);
plot(Rx_complex_carrier_matrix_before,'*r');%XY��������źŵ�����ͼ
title('XY��������źŵ�����ͼ-Ƶ�����ǰ')
axis([-1, 1, -1, 1]);
grid on
subplot(2,1,2);
plot(Rx_complex_carrier_matrix,'*r');%XY��������źŵ�����ͼ
title('XY��������źŵ�����ͼ-Ƶ������')
axis([-1, 1, -1, 1]);
grid on
sum_BER=sum_BER+BER(ii)*length(last_bit_stream);
BER=sum_BER/length(bit_stream)
%================��ԭͼƬ============================================
Pic_out_test=reshape(receive_stream,length(bit_stream_before)/8,8);
Pic_out_stream=bi2de(Pic_out_test);
Pic_out=reshape(Pic_out_stream,x,y,z);
Pic_result=uint8(Pic_out);
imwrite(Pic_result,'/Users/kobezhe/Desktop/result.JPG');
figure(4);
imshow('/Users/kobezhe/Desktop/result.JPG');

