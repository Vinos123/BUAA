function [RES]=OFDM_AMC_CHOW(mean_SNR)
PrefixRatio=1/4;%保护间隔与OFDM数据的比例 1/4
carrier_count=1024;%子载波数
L=6;%多径信道数量
L_SNR=30;%信道白噪声
symbols_per_carrier=30;%每子载波含符号数
% ===============生成频率相关噪声=========================
for i=1:carrier_count 
    dB_SNR(i)=mean_SNR+(mean_SNR/2)*randn(1,1);
end
SNR=10.^(dB_SNR/10);
% ================CHOW算法（根据每个子载波上不同的SNR分配不同数量的传输bit）=============
r_margin=0;
IterateCount=0;%迭代次数
MaxCount=1;%最大迭代次数，实测1次得到的效果最好
UsedCarriers=carrier_count;%在AMC中使用的子载波数
expected_BER=1e-4;%目标误码率
bit_target=4*carrier_count;%规定的传输速率
torq=-log(5*expected_BER)/1.6;%与误码率相关的一个参数
b=zeros(1,carrier_count);%算法计算得到的单个子载波单个symbol位所携带bit数
b_=zeros(1,carrier_count);%取整到0，2，4，6，8 对应五种传输方式
diff=zeros(1,carrier_count);%b和b_之间的差，用来衡量该子载波在当前调制方式下的优劣
bit_total=sum(b_);%所有子载波在单个symbol周期内所传输的bit数
err=bit_target/3;
while(abs(bit_total-bit_target)>err&&IterateCount<MaxCount)
    UsedCarriers=carrier_count;
    for i=1:carrier_count
        b(i)=real(log2(1+SNR(i)/(torq+r_margin)));%计算该子载波所能传输的bit速率
        mapping=[0,2,4,6,8];%取整
        for j=1:5
            distance(j)=abs(b(i)-mapping(j));
        end
        [min_dis b_i]=min(distance);
        b_(i)=mapping(b_i);
        if(b_(i)==0)
            UsedCarriers=UsedCarriers-1;%子载波完全无法使用，使用子载波数-1
        end
        diff(i)=b(i)-b_(i);%取差
    end
    bit_total=sum(b_);
    r_margin=r_margin+10*log10(2^((bit_total-bit_target)/UsedCarriers));%迭代得到新的参数
    IterateCount=IterateCount+1;%迭代次数+1
end
while(bit_target<bit_total)%当当前传输速率大于要求的速率，减少传输数
    [min_diff worst_carrier]= min(diff);%找到最劣子载波信道，减小传输速率
    if(b_(worst_carrier)==0)
        diff(worst_carrier)=diff(worst_carrier)+2;
    else
        b_(worst_carrier)=b_(worst_carrier)-2;
        diff(worst_carrier)=diff(worst_carrier)+2;
    end
    bit_total=sum(b_);
end
while(bit_target>bit_total)%当当前传输速率小于要求的速率，增大传输数
    [max_diff best_carrier]= max(diff);%找到最好子载波信道，增大传输速率
    if(b_(best_carrier)==8)
        diff(best_carrier)=diff(best_carrier)-2;
    else
        b_(best_carrier)=b_(best_carrier)+2;
        diff(best_carrier)=diff(best_carrier)-2;
    end
    bit_total=sum(b_);
end
% ======================绘图：bit分配方式================================
% figure(1);
% subplot(211);
% stem(1:carrier_count,dB_SNR);
% xlabel('子载波数目')
% ylabel('频率相关SNR')
% subplot(212);
% stem(1:carrier_count,b_);
% xlabel('子载波数目')
% ylabel('每符号位bit数')
% ===========================================================================
% ==============================五种传输方式================================
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
% =============画图：多径长度L和CP长度对误码率的影响======================
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
% xlabel('多径条数')
% ylabel('前缀长度')
% zlabel('误码率')
% ================画图：SNR对L=6情况下BER的影响========================
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