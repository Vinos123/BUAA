clear all;
N=3e6;%���ɶ����Ʊ���������Ϊ4N
logpe=-1:-0.5:-4;
Pe=10.^(logpe);%����������
Le=length(Pe);%����ĸ���
Data_bit=round(rand(4*N,1));%���ɳ���Ϊ4N�Ķ����Ʊ�����

G=[1 0 0 0 1 1 1;
   0 1 0 0 1 1 0;
   0 0 1 0 1 0 1;
   0 0 0 1 0 1 1];
H=[1 1 1 0 1 0 0;
   1 1 0 1 0 1 0;
   1 0 1 1 0 0 1];

Data_bit_4=reshape(Data_bit,4,N);
Data_bit_4_extr=repmat(Data_bit_4',1,1,Le);
Data_hamming=mod(Data_bit_4'*G,2);%�õ���Ӧ�ĺ�����
%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%%
[x y]=size(Data_hamming);
Data_ham_Pe_b=reshape(Data_hamming,x*y,1);%��Ϊһ��
Data_ham_Pe_extr=repmat(Data_ham_Pe_b,1,Le);
Num_e=rand(x*y,Le);%ÿһ����Ӧ������������һ��0��1�����������,ÿһ�ж�Ӧһ��������
Pe_extr=ones(x*y,Le);%��Pe��չΪx*y�У�ÿһ�ж���ͬ
Pe_extr=Pe_extr.*Pe;
Num_e=1.*(Num_e<=Pe_extr)+0.*(Num_e>Pe_extr);%С�������ʵ�Ϊ1�����������ʵ�Ϊ0��
Data_ham_Pe=mod(Data_ham_Pe_extr+Num_e,2);%����ȡ��
Data_ham_de=reshape(Data_ham_Pe,x,y,Le);
Data_ham_decode=Data_ham_de;
S=zeros(x,3,Le);%У���Ӿ���
for jj=1:1:Le
    S(:,:,jj)=mod(Data_ham_de(:,:,jj)*H',2);
    S_test=bi2de(S(:,:,jj),'left-msb');%��У����ת��Ϊʮ���ƣ�ȷ����Ҫ��������Ϣλ�ı��

    Data_ham_change=Data_ham_de(:,:,jj);%ȡ��ÿ�������ʶ�Ӧ������
   
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
error=double(Data_ham_information ~= Data_bit_4_extr);%�ҵ����뷢����λ��
error=reshape(error,4*N,Le);%�����������
Pb=mean((error));%���������ȡ��ֵ����������
loglog(Pe,Pb);%��������
hold on
loglog(Pe,Pe);
set(gca,'XDir','rev');
grid on
xlabel('�ŵ��������P_e');
ylabel('�����������P_b');
title('������������ܷ���');
legend('������','ԭʼ�������');


