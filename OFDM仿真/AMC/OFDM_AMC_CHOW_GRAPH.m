%��ͼ����������Ƶ��ѡ���Ե�������С��ֵ���۲��ڲ�ͬ����£�AMC���Ƶ�Ч��
clear all
close all
max_SNR=30;%���SNR
figure(1);
ii=1:1:max_SNR;
for i=ii
    res(:,ceil(i/5))=OFDM_AMC_CHOW(i)
end
[length_x,length_y]=size(res);
for i=1:length_y-1
    semilogy(ii,res(i,:))
    ylabel('BER(�����ʣ�')
    xlabel('Eb/N0��dB��')
    title('��ͬ�����㷨��BER��Ӱ��')
    legend('4QAM','16QAM','64QAM','256QAM','AMC����')
    hold on
end