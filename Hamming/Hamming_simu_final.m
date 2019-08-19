clear all;
N=3e6;%生成二进制比特流长度为4N
logpe=-1:-0.5:-4;
Pe=10.^(logpe);%误码率向量
Le=length(Pe);%误码的个数
Data_bit=round(rand(4*N,1));%生成长度为4N的二进制比特流

G=[1 0 0 0 1 1 1;
   0 1 0 0 1 1 0;
   0 0 1 0 1 0 1;
   0 0 0 1 0 1 1];
H=[1 1 1 0 1 0 0;
   1 1 0 1 0 1 0;
   1 0 1 1 0 0 1];

Data_bit_4=reshape(Data_bit,4,N);
Data_bit_4_extr=repmat(Data_bit_4',1,1,Le);
Data_hamming=mod(Data_bit_4'*G,2);%得到对应的汉明吗
%%%%%%%%%%%添加误码%%%%%%%%%%%%%%%%%%%%%%%
[x y]=size(Data_hamming);
Data_ham_Pe_b=reshape(Data_hamming,x*y,1);%变为一列
Data_ham_Pe_extr=repmat(Data_ham_Pe_b,1,Le);
Num_e=rand(x*y,Le);%每一个对应的误码率生成一个0到1的随机数矩阵,每一列对应一个误码率
Pe_extr=ones(x*y,Le);%将Pe扩展为x*y行，每一行都相同
Pe_extr=Pe_extr.*Pe;
Num_e=1.*(Num_e<=Pe_extr)+0.*(Num_e>Pe_extr);%小于误码率的为1，大于误码率的为0；
Data_ham_Pe=mod(Data_ham_Pe_extr+Num_e,2);%误码取反
Data_ham_de=reshape(Data_ham_Pe,x,y,Le);
Data_ham_decode=Data_ham_de;
S=zeros(x,3,Le);%校正子矩阵
for jj=1:1:Le
    S(:,:,jj)=mod(Data_ham_de(:,:,jj)*H',2);
    S_test=bi2de(S(:,:,jj),'left-msb');%将校正子转化为十进制，确定需要纠正的信息位的编号

    Data_ham_change=Data_ham_de(:,:,jj);%取出每个误码率对应的码组
   
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
error=double(Data_ham_information ~= Data_bit_4_extr);%找到误码发生的位置
error=reshape(error,4*N,Le);%重塑误码矩阵
Pb=mean((error));%对误码矩阵取均值即得误码率
loglog(Pe,Pb);%对数曲线
hold on
loglog(Pe,Pe);
set(gca,'XDir','rev');
grid on
xlabel('信道误比特率P_e');
ylabel('解码误比特率P_b');
title('汉明码纠错性能仿真');
legend('汉明码','原始误比特率');


