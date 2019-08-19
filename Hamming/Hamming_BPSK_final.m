clear all;
N=1e6;%���ɶ����Ʊ���������Ϊ4N

SNR=(3:1:11);%�����
SNRR=10.^(SNR./10);
LN=length(SNR);

Data_bit=round(rand(4*N,1));%���ɳ���Ϊ4N�Ķ����Ʊ�����

G=[1 0 0 0 1 1 1;
   0 1 0 0 1 1 0;
   0 0 1 0 1 0 1;
   0 0 0 1 0 1 1];
H=[1 1 1 0 1 0 0;
   1 1 0 1 0 1 0;
   1 0 1 1 0 0 1];

Data_bit_4=reshape(Data_bit,4,N);
Data_bit_4_extr=repmat(Data_bit_4',1,1,LN);
Data_hamming=mod(Data_bit_4'*G,2);%�õ���Ӧ�ĺ�����
Data_hamming_extr=repmat(Data_hamming,1,1,LN);
Data_BPSK = 1.* (Data_hamming == 1) +(-1).*(Data_hamming == 0);%����˫���Թ�����
Data_BPSK_extr=repmat(Data_BPSK,1,1,LN);
[xs ys zs]=size(Data_BPSK_extr);
%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%%
Pn=1./SNRR;%��������
Noise=randn(xs,ys,LN);

Pn=reshape(Pn,1,1,LN);
Noise=Noise.*((Pn).^(1/2));%������ÿҳ����һ������ȵ�������reshape�����⣿

Data_Noise=Data_BPSK_extr+Noise;%��������

Data_BPSK_decode=1.*(Data_Noise>0)+0.*(Data_Noise<0);%BPSK����

Data_ham_decode=Data_BPSK_decode;
S=zeros(xs,3,LN);%У���Ӿ���
for jj=1:1:LN
    S(:,:,jj)=mod(Data_BPSK_decode(:,:,jj)*H',2);
    S_test=bi2de(S(:,:,jj),'left-msb');%��У����ת��Ϊʮ���ƣ�ȷ����Ҫ��������Ϣλ�ı��
    Data_ham_change=Data_ham_decode(:,:,jj);%ȡ��ÿ�������ʶ�Ӧ������
   
    S_change=4.*(S_test==3)+3.*(S_test==5)+...
         2.*(S_test==6)+1.*(S_test==7);%�ҵ�ÿ��У���Ӷ�Ӧ������λ��(����У��λ�����ӦΪ0)
    S_index=find(S_change);%��������Ϣλ��������Ķ�Ӧ���������ڣ�У��λ������Ϊ�㣬�����൱��ֻ��������Ϣλ�����룩
     S_change=4.*(S_test(S_index)==3)+3.*(S_test(S_index)==5)+...
         2.*(S_test(S_index)==6)+1.*(S_test(S_index)==7);%�ҵ�ÿ��У���Ӷ�Ӧ������λ��
    Data_ham_change(sub2ind(size(Data_ham_change),S_index,S_change))=~ ...
        Data_ham_change(sub2ind(size(Data_ham_change),S_index,S_change));%�������루������˫�±�ת���±꣩
    Data_ham_decode(:,:,jj)=Data_ham_change;%��������Ľ������
end
Data_ham_information=Data_ham_decode(:,1:4,:);%ȡ����Ϣλ
Data_none_information=Data_BPSK_decode(:,1:4,:);%ȡ��δ���������Ϣλ��
error=double(Data_ham_information ~= Data_bit_4_extr);%�ҵ����뷢����λ��
error_bpsk=double(Data_none_information ~=Data_bit_4_extr);
error=reshape(error,4*N,LN);%�����������
error_bpsk=reshape(error_bpsk,4*N,LN);
Pb=mean((error));%���������ȡ��ֵ����������
Pb_original=mean(error_bpsk);
semilogy(SNR,Pb);%��������
hold on
semilogy(SNR,Pb_original);
grid on
xlabel('E_b/N_0');
ylabel('�������P_b');
legend('������','δ����');
title('�����뾭��BPSK����ͨ��AWGN�ŵ�');
