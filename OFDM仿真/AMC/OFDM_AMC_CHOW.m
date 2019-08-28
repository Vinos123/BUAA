function [RES]=OFDM_AMC_CHOW(mean_SNR)
PrefixRatio=1/4;%���������OFDM���ݵı��� 1/4
carrier_count=1024;%���ز���
L=6;%�ྶ�ŵ�����
L_SNR=30;%�ŵ�������
symbols_per_carrier=30;%ÿ���ز���������
% ===============����Ƶ���������=========================
for i=1:carrier_count 
    dB_SNR(i)=mean_SNR+(mean_SNR/2)*randn(1,1);
end
SNR=10.^(dB_SNR/10);
% ================CHOW�㷨������ÿ�����ز��ϲ�ͬ��SNR���䲻ͬ�����Ĵ���bit��=============
r_margin=0;
IterateCount=0;%��������
MaxCount=1;%������������ʵ��1�εõ���Ч�����
UsedCarriers=carrier_count;%��AMC��ʹ�õ����ز���
expected_BER=1e-4;%Ŀ��������
bit_target=4*carrier_count;%�涨�Ĵ�������
torq=-log(5*expected_BER)/1.6;%����������ص�һ������
b=zeros(1,carrier_count);%�㷨����õ��ĵ������ز�����symbolλ��Я��bit��
b_=zeros(1,carrier_count);%ȡ����0��2��4��6��8 ��Ӧ���ִ��䷽ʽ
diff=zeros(1,carrier_count);%b��b_֮��Ĳ�������������ز��ڵ�ǰ���Ʒ�ʽ�µ�����
bit_total=sum(b_);%�������ز��ڵ���symbol�������������bit��
err=bit_target/3;
while(abs(bit_total-bit_target)>err&&IterateCount<MaxCount)
    UsedCarriers=carrier_count;
    for i=1:carrier_count
        b(i)=real(log2(1+SNR(i)/(torq+r_margin)));%��������ز����ܴ����bit����
        mapping=[0,2,4,6,8];%ȡ��
        for j=1:5
            distance(j)=abs(b(i)-mapping(j));
        end
        [min_dis b_i]=min(distance);
        b_(i)=mapping(b_i);
        if(b_(i)==0)
            UsedCarriers=UsedCarriers-1;%���ز���ȫ�޷�ʹ�ã�ʹ�����ز���-1
        end
        diff(i)=b(i)-b_(i);%ȡ��
    end
    bit_total=sum(b_);
    r_margin=r_margin+10*log10(2^((bit_total-bit_target)/UsedCarriers));%�����õ��µĲ���
    IterateCount=IterateCount+1;%��������+1
end
while(bit_target<bit_total)%����ǰ�������ʴ���Ҫ������ʣ����ٴ�����
    [min_diff worst_carrier]= min(diff);%�ҵ��������ز��ŵ�����С��������
    if(b_(worst_carrier)==0)
        diff(worst_carrier)=diff(worst_carrier)+2;
    else
        b_(worst_carrier)=b_(worst_carrier)-2;
        diff(worst_carrier)=diff(worst_carrier)+2;
    end
    bit_total=sum(b_);
end
while(bit_target>bit_total)%����ǰ��������С��Ҫ������ʣ���������
    [max_diff best_carrier]= max(diff);%�ҵ�������ز��ŵ�������������
    if(b_(best_carrier)==8)
        diff(best_carrier)=diff(best_carrier)-2;
    else
        b_(best_carrier)=b_(best_carrier)+2;
        diff(best_carrier)=diff(best_carrier)-2;
    end
    bit_total=sum(b_);
end
% ======================��ͼ��bit���䷽ʽ================================
% figure(1);
% subplot(211);
% stem(1:carrier_count,dB_SNR);
% xlabel('���ز���Ŀ')
% ylabel('Ƶ�����SNR')
% subplot(212);
% stem(1:carrier_count,b_);
% xlabel('���ز���Ŀ')
% ylabel('ÿ����λbit��')
% ===========================================================================
% ==============================���ִ��䷽ʽ================================
bits_per_symbol=b_;
[resAMC,errbitAMC]=OFDM_AMC(L,L_SNR,dB_SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier);
% for i=1:carrier_count
%     bits_per_symbol(i)=8;
% end
% [res256,errbit256]=OFDM_AMC(L,L_SNR,dB_SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier);
% for i=1:carrier_count
%     bits_per_symbol(i)=6;
% end
% [res64,errbit64]=OFDM_AMC(L,L_SNR,dB_SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier);
% for i=1:carrier_count
%     bits_per_symbol(i)=4;
% end
% [res16,errbit16]=OFDM_AMC(L,L_SNR,dB_SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier);
% for i=1:carrier_count
%     bits_per_symbol(i)=2;
% end
% [res4,errbit4]=OFDM_AMC(L,L_SNR,dB_SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier);
% res=[res4,res16,res64,res256,resAMC];
% RES=res;
% =============��ͼ���ྶ����L��CP���ȶ������ʵ�Ӱ��======================
% LL=500;
% L=1:LL;
% CPP=1/2;
% CP=1/8:1/8:CPP;
% res=zeros(CPP*8,LL);
% EPOCH=1;
% for j=L
%     for k=CP*8
%         for l=1:EPOCH
%             res(k,j)=res(k,j)+OFDM_QPSK(j,20,k/8);
%             res(k,j)=res(k,j)/EPOCH;
%         end
%     end
% end
% figure(1);
% stem3(L,CP,res);
% xlabel('�ྶ����')
% ylabel('ǰ׺����')
% zlabel('������')
% ================��ͼ��SNR��L=6�����BER��Ӱ��========================
% SNRR=50;
% iSNR=10;
% SNR=iSNR:SNRR;
% res2=zeros(1,SNRR-iSNR+1);
% for j=1:SNRR-iSNR+1
%     for k=1:EPOCH
%         res2(j)=res2(j)+OFDM_QPSK(6,j+iSNR-1,1/4);
%         res2(j)=res2(j)/EPOCH;
%     end
% end
% figure(2);
% plot(SNR,res2);