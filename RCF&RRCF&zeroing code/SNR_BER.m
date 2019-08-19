clear all;
clc;
A=5;%高电平幅度
Num=1e5;%二进制比特数目
SNR=(0:1:15);%信噪比
SNRR=10.^(SNR./10);
S_in=round(rand(1e5,1));%生成1e5个随机二进制比特流
extr=ones(1,length(SNR));%用于扩展
S_extr=S_in.*extr;%将输入 信号扩展为16列
S_single = A.*(S_in == 1) + 0.*(S_in == 0);%产生单极性归零码
S_double = A.*(S_in == 1) + (-A).*(S_in == 0);%产生双极性归零码
P_single=mean(S_single.^2);%计算功率
P_double=mean(S_double.^2);%计算功率
%%%%%%%%%%%%%%%%%%%%生成噪声
Pn_single=(P_single)./SNRR;%计算单极性噪声功率
Pn_double=(P_double)./SNRR;%计算双极性噪声功率

N_single=(Pn_single).^(1/2).*randn(1e5,1);%单极性码噪声，每一行代表一个信噪比的噪声
N_double=(Pn_double).^(1/2).*randn(1e5,1);%双极性码噪声，每一行代表一个信噪比的噪声

So_single_1=S_single.*extr;%扩展为16列
So_double_1=S_double.*extr;%扩展为16列
%%%%%%%%%%%%%%%%叠加噪声%%%%%%%%%%%%%%%%%%%%5
So_single=So_single_1+N_single;
So_double=So_double_1+N_double;
%%%%%%%%%%%%%%%判决%%%%%%%%%%%%%%%%%%%%%%%%%
S_decode_single=1.*(So_single >= A/2 ) + 0.*( So_single < A/2 );
S_decode_double=1.*(So_double >= 0) + 0.*( So_double < 0 );
%%%%%%%%%%%%%%%计算误码率%%%%%%%%%%%%%%%%%%%
BER_single=sum(double(S_decode_single~=S_extr))/Num;
BER_double=sum(double(S_decode_double~=S_extr))/Num;
%%%%%%%%%%%%%%%画图%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
semilogy(SNR,BER_single,'-+');
hold on
grid on 
semilogy(SNR,BER_double,'-*');
grid on
legend('单极性非归零码','双极性非归零码');
xlabel('SNR/dB');
ylabel('BER');
title('单极性非归零码和双极性非归零码误码率随信噪比变化');
