clear all;
P_db=[-60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -13 -9 -6 -5 -4 -3 -2 -1 0];
%P_db=-60:2:0;
%P_db=-60:5:0;
%M_P=length(P_db);

V=1;%��������
Num=1e6;%��ֵ��Ŀ
P_I=10.^(P_db/10);%�����ź�ƽ�����ʣ�
V_I=(3*P_I).^(1/2);%�����ź�ƽ������,���ݾ��ȷֲ����ʹ�ʽ
P_e=1e-5;%�ŵ��������
N_1=11;%(1),(2)����λ��
N_2=12;%(3),(4)����λ��
    
%%%%%%%%���������%%%%%%%
S_rand=2*rand(Num,1)-1;%����e4�������
S_I=V_I.*S_rand;%���������źŹ��ʴ�-60dB~-10dB�仯�ķ��Ӿ��ȷֲ��������źš�
S_aq_N_1=code_N(N_1,V,S_I);%�������ź�
S_aq_N_2=code_N(N_2,V,S_I);%�������ź�
S_aq_F_1=code_F(N_1,V,S_I);%�۵���������ź�
S_aq_F_2=code_F(N_2,V,S_I);%�۵���������ź�

%%%%%%%�����������أ�����P_e*x*y*z�������%%%%%%%%%
[x_1 y_1]=size(S_aq_N_1);
[x_2 y_2]=size(S_aq_N_2);
[x_3 y_3]=size(S_aq_F_1);
[x_4 y_4]=size(S_aq_F_2);
size_L_1=x_1*y_1;
size_L_2=x_2*y_2;
size_L_3=x_3*y_3;
size_L_4=x_4*y_4;

L_P=length(P_db);

S_h_N_1=reshape(S_aq_N_1,size_L_1/L_P,L_P);
S_h_N_2=reshape(S_aq_N_2,size_L_2/L_P,L_P);
S_h_F_1=reshape(S_aq_F_1,size_L_3/L_P,L_P);
S_h_F_2=reshape(S_aq_F_2,size_L_4/L_P,L_P);
%%%%%%%%%%%%%%%%%%%%%%��������ط���һ%%%%%%%%%%%%%%%%%%%%%%%
Num_detect_1=rand(size_L_1/L_P,1);
Num_detect_2=rand(size_L_2/L_P,1);
Num_detect_3=rand(size_L_3/L_P,1);
Num_detect_4=rand(size_L_4/L_P,1);

Num_e_1=find(1.*(Num_detect_1 < 1e-5)+0.*(Num_detect_1 >= 1e-5));
Num_e_2=find(1.*(Num_detect_2 < 1e-5)+0.*(Num_detect_2 >= 1e-5));
Num_e_3=find(1.*(Num_detect_3 < 1e-5)+0.*(Num_detect_3 >= 1e-5));
Num_e_4=find(1.*(Num_detect_4 < 1e-5)+0.*(Num_detect_4 >= 1e-5));
%%%%%%%%%%%%%%%%%%%%%%�������뷽����%%%%%%%%%%%%%%%%%%%%%%%
% Num_e_1=round(size_L_1/10*rand(round(size_L_1/10*P_e),1));%%%��������ص���ţ�
% Num_e_2=round(size_L_2/10*rand(round(size_L_2/10*P_e),1));%%%���ɱ��ص���ţ�
% Num_e_3=round(size_L_3/10*rand(round(size_L_3/10*P_e),1));
% Num_e_4=round(size_L_4/10*rand(round(size_L_4/10*P_e),1));
S_h_N_1(Num_e_1,:)=~S_h_N_1(Num_e_1,:);%%�����ȡ��c
S_h_N_2(Num_e_2,:)=~S_h_N_2(Num_e_2,:);%%�����ȡ��
S_h_F_1(Num_e_3,:)=~S_h_F_1(Num_e_3,:);
S_h_F_2(Num_e_4,:)=~S_h_F_2(Num_e_4,:);
%%%%%%%%%%%����֮��ָ�ԭ�������ά��%%%%%%%%%%%%%%%%
S_rec_N_1=reshape(S_h_N_1,x_1,y_1);
S_rec_N_2=reshape(S_h_N_2,x_2,y_2);
S_rec_F_1=reshape(S_h_F_1,x_3,y_3);
S_rec_F_2=reshape(S_h_F_2,x_4,y_4);
%%%%%%%%%%%%����%%%%%%%%%%%%%%
S_decode_N_1=decode_N(N_1,V,S_rec_N_1);
S_decode_N_2=decode_N(N_2,V,S_rec_N_2);
S_decode_F_1=decode_F(N_1,V,S_rec_F_1);
S_decode_F_2=decode_F(N_2,V,S_rec_F_2);
S_out_N_1=(reshape(S_decode_N_1,length(P_I),Num))';
S_out_N_2=(reshape(S_decode_N_2,length(P_I),Num))';
S_out_F_1=(reshape(S_decode_F_1,length(P_I),Num))';
S_out_F_2=(reshape(S_decode_F_2,length(P_I),Num))';
%%%%%%%%%%%%�������%%%%%%%%%%%
S_e_N_1=mean((S_I-S_out_N_1).^2);
S_e_N_2=mean((S_I-S_out_N_2).^2);
S_e_F_1=mean((S_I-S_out_F_1).^2);
S_e_F_2=mean((S_I-S_out_F_2).^2);
%%%%%%%%%%%%ͳ�������%%%%%%%%%
SNR_N_1=10*log10(P_I./S_e_N_1);
SNR_N_2=10*log10(P_I./S_e_N_2);
SNR_F_1=10*log10(P_I./S_e_F_1);
SNR_F_2=10*log10(P_I./S_e_F_2);
%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%
figure(1);
plot(P_db,SNR_N_1,'r');
hold on 
plot(P_db,SNR_N_2,'b');
hold on
plot(P_db,SNR_F_1,'r--');
hold on
plot(P_db,SNR_F_2,'b--');
legend('N=11,��Ȼ����','N=12,��Ȼ����','N=11,�۵�����','N=12,�۵�����');
xlabel('S_i');
ylabel('SNR_O');
grid on
title('SNR_O~S_i');