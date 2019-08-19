clear all;
clc;
A=5;%�ߵ�ƽ����
Num=1e5;%�����Ʊ�����Ŀ
SNR=(0:1:15);%�����
SNRR=10.^(SNR./10);
S_in=round(rand(1e5,1));%����1e5����������Ʊ�����
extr=ones(1,length(SNR));%������չ
S_extr=S_in.*extr;%������ �ź���չΪ16��
S_single = A.*(S_in == 1) + 0.*(S_in == 0);%���������Թ�����
S_double = A.*(S_in == 1) + (-A).*(S_in == 0);%����˫���Թ�����
P_single=mean(S_single.^2);%���㹦��
P_double=mean(S_double.^2);%���㹦��
%%%%%%%%%%%%%%%%%%%%��������
Pn_single=(P_single)./SNRR;%���㵥������������
Pn_double=(P_double)./SNRR;%����˫������������

N_single=(Pn_single).^(1/2).*randn(1e5,1);%��������������ÿһ�д���һ������ȵ�����
N_double=(Pn_double).^(1/2).*randn(1e5,1);%˫������������ÿһ�д���һ������ȵ�����

So_single_1=S_single.*extr;%��չΪ16��
So_double_1=S_double.*extr;%��չΪ16��
%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%5
So_single=So_single_1+N_single;
So_double=So_double_1+N_double;
%%%%%%%%%%%%%%%�о�%%%%%%%%%%%%%%%%%%%%%%%%%
S_decode_single=1.*(So_single >= A/2 ) + 0.*( So_single < A/2 );
S_decode_double=1.*(So_double >= 0) + 0.*( So_double < 0 );
%%%%%%%%%%%%%%%����������%%%%%%%%%%%%%%%%%%%
BER_single=sum(double(S_decode_single~=S_extr))/Num;
BER_double=sum(double(S_decode_double~=S_extr))/Num;
%%%%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
semilogy(SNR,BER_single,'-+');
hold on
grid on 
semilogy(SNR,BER_double,'-*');
grid on
legend('�����Էǹ�����','˫���Էǹ�����');
xlabel('SNR/dB');
ylabel('BER');
title('�����Էǹ������˫���Էǹ�����������������ȱ仯');
