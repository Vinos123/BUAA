clear all;
N=1e6;%生成二进制比特流长度为4N

SNR=(3:1:11);%信噪比
SNRR=10.^(SNR./10);
LN=length(SNR);

Data_bit=round(rand(4*N,1));%生成长度为4N的二进制比特流

G=[1 0 0 0 1 1 1;
   0 1 0 0 1 1 0;
   0 0 1 0 1 0 1;
   0 0 0 1 0 1 1];
H=[1 1 1 0 1 0 0;
   1 1 0 1 0 1 0;
   1 0 1 1 0 0 1];

Data_bit_4=reshape(Data_bit,4,N);
Data_bit_4_extr=repmat(Data_bit_4',1,1,LN);
Data_hamming=mod(Data_bit_4'*G,2);%得到对应的汉明吗
Data_hamming_extr=repmat(Data_hamming,1,1,LN);
Data_BPSK = 1.* (Data_hamming == 1) +(-1).*(Data_hamming == 0);%产生双极性归零码
Data_BPSK_extr=repmat(Data_BPSK,1,1,LN);
[xs ys zs]=size(Data_BPSK_extr);
%%%%%%%%%%%添加噪声%%%%%%%%%%%%%%%%%%%%%%%
Pn=1./SNRR;%噪声功率
Noise=randn(xs,ys,LN);

Pn=reshape(Pn,1,1,LN);
Noise=Noise.*((Pn).^(1/2));%噪声，每页代表一个信噪比的噪声？reshape有问题？

Data_Noise=Data_BPSK_extr+Noise;%噪声叠加

Data_BPSK_decode=1.*(Data_Noise>0)+0.*(Data_Noise<0);%BPSK解码

Data_ham_decode=Data_BPSK_decode;
S=zeros(xs,3,LN);%校正子矩阵
for jj=1:1:LN
    S(:,:,jj)=mod(Data_BPSK_decode(:,:,jj)*H',2);
    S_test=bi2de(S(:,:,jj),'left-msb');%将校正子转化为十进制，确定需要纠正的信息位的编号
    Data_ham_change=Data_ham_decode(:,:,jj);%取出每个误码率对应的码组
   
    S_change=4.*(S_test==3)+3.*(S_test==5)+...
         2.*(S_test==6)+1.*(S_test==7);%找到每个校正子对应的误码位置(这里校正位误码对应为0)
    S_index=find(S_change);%生成在信息位发生误码的对应索引（由于，校正位的误码为零，这里相当于只考虑了信息位的误码）
     S_change=4.*(S_test(S_index)==3)+3.*(S_test(S_index)==5)+...
         2.*(S_test(S_index)==6)+1.*(S_test(S_index)==7);%找到每个校正子对应的误码位置
    Data_ham_change(sub2ind(size(Data_ham_change),S_index,S_change))=~ ...
        Data_ham_change(sub2ind(size(Data_ham_change),S_index,S_change));%纠正误码（运用了双下标转单下标）
    Data_ham_decode(:,:,jj)=Data_ham_change;%将纠正后的结果保存
end
Data_ham_information=Data_ham_decode(:,1:4,:);%取出信息位
Data_none_information=Data_BPSK_decode(:,1:4,:);%取出未经编码的信息位；
error=double(Data_ham_information ~= Data_bit_4_extr);%找到误码发生的位置
error_bpsk=double(Data_none_information ~=Data_bit_4_extr);
error=reshape(error,4*N,LN);%重塑误码矩阵
error_bpsk=reshape(error_bpsk,4*N,LN);
Pb=mean((error));%对误码矩阵取均值即得误码率
Pb_original=mean(error_bpsk);
semilogy(SNR,Pb);%对数曲线
hold on
semilogy(SNR,Pb_original);
grid on
xlabel('E_b/N_0');
ylabel('误比特率P_b');
legend('汉明码','未编码');
title('汉明码经过BPSK调制通过AWGN信道');
