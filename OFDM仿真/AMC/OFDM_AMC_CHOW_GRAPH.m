%画图函数，更改频率选择性的噪声大小均值，观察在不同情况下，AMC调制的效果
clear all
close all
max_SNR=30;%最大SNR
figure(1);
ii=1:1:max_SNR;
for i=ii
    res(:,ceil(i/5))=OFDM_AMC_CHOW(i)
end
[length_x,length_y]=size(res);
for i=1:length_y-1
    semilogy(ii,res(i,:))
    ylabel('BER(误码率）')
    xlabel('Eb/N0（dB）')
    title('不同编码算法对BER的影响')
    legend('4QAM','16QAM','64QAM','256QAM','AMC调制')
    hold on
end