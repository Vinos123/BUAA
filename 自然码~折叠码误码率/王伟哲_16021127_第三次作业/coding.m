clear all;
P_db=[-60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -13 -9 -6 -5 -4 -3 -2 -1 0];
%P_db=-60:2:0;
%P_db=-60:5:0;
%M_P=length(P_db);

V=1;%量化区间
Num=1e6;%样值数目
P_I=10.^(P_db/10);%输入信号平均功率；
V_I=(3*P_I).^(1/2);%输入信号平均幅度,根据均匀分布功率公式
P_e=1e-5;%信道误比特率
N_1=11;%(1),(2)量化位数
N_2=12;%(3),(4)量化位数
    
%%%%%%%%生成随机数%%%%%%%
S_rand=2*rand(Num,1)-1;%产生e4个随机数
S_I=V_I.*S_rand;%产生输入信号功率从-60dB~-10dB变化的服从均匀分布的输入信号。
S_aq_N_1=code_N(N_1,V,S_I);%编码后的信号
S_aq_N_2=code_N(N_2,V,S_I);%编码后的信号
S_aq_F_1=code_F(N_1,V,S_I);%折叠码编码后的信号
S_aq_F_2=code_F(N_2,V,S_I);%折叠码编码后的信号

%%%%%%%产生随机误比特，共有P_e*x*y*z个误比特%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%生成误比特方法一%%%%%%%%%%%%%%%%%%%%%%%
Num_detect_1=rand(size_L_1/L_P,1);
Num_detect_2=rand(size_L_2/L_P,1);
Num_detect_3=rand(size_L_3/L_P,1);
Num_detect_4=rand(size_L_4/L_P,1);

Num_e_1=find(1.*(Num_detect_1 < 1e-5)+0.*(Num_detect_1 >= 1e-5));
Num_e_2=find(1.*(Num_detect_2 < 1e-5)+0.*(Num_detect_2 >= 1e-5));
Num_e_3=find(1.*(Num_detect_3 < 1e-5)+0.*(Num_detect_3 >= 1e-5));
Num_e_4=find(1.*(Num_detect_4 < 1e-5)+0.*(Num_detect_4 >= 1e-5));
%%%%%%%%%%%%%%%%%%%%%%生成误码方法二%%%%%%%%%%%%%%%%%%%%%%%
% Num_e_1=round(size_L_1/10*rand(round(size_L_1/10*P_e),1));%%%生成误比特的序号；
% Num_e_2=round(size_L_2/10*rand(round(size_L_2/10*P_e),1));%%%生成比特的序号；
% Num_e_3=round(size_L_3/10*rand(round(size_L_3/10*P_e),1));
% Num_e_4=round(size_L_4/10*rand(round(size_L_4/10*P_e),1));
S_h_N_1(Num_e_1,:)=~S_h_N_1(Num_e_1,:);%%误比特取反c
S_h_N_2(Num_e_2,:)=~S_h_N_2(Num_e_2,:);%%误比特取反
S_h_F_1(Num_e_3,:)=~S_h_F_1(Num_e_3,:);
S_h_F_2(Num_e_4,:)=~S_h_F_2(Num_e_4,:);
%%%%%%%%%%%误码之后恢复原来矩阵的维度%%%%%%%%%%%%%%%%
S_rec_N_1=reshape(S_h_N_1,x_1,y_1);
S_rec_N_2=reshape(S_h_N_2,x_2,y_2);
S_rec_F_1=reshape(S_h_F_1,x_3,y_3);
S_rec_F_2=reshape(S_h_F_2,x_4,y_4);
%%%%%%%%%%%%译码%%%%%%%%%%%%%%
S_decode_N_1=decode_N(N_1,V,S_rec_N_1);
S_decode_N_2=decode_N(N_2,V,S_rec_N_2);
S_decode_F_1=decode_F(N_1,V,S_rec_F_1);
S_decode_F_2=decode_F(N_2,V,S_rec_F_2);
S_out_N_1=(reshape(S_decode_N_1,length(P_I),Num))';
S_out_N_2=(reshape(S_decode_N_2,length(P_I),Num))';
S_out_F_1=(reshape(S_decode_F_1,length(P_I),Num))';
S_out_F_2=(reshape(S_decode_F_2,length(P_I),Num))';
%%%%%%%%%%%%计算误差%%%%%%%%%%%
S_e_N_1=mean((S_I-S_out_N_1).^2);
S_e_N_2=mean((S_I-S_out_N_2).^2);
S_e_F_1=mean((S_I-S_out_F_1).^2);
S_e_F_2=mean((S_I-S_out_F_2).^2);
%%%%%%%%%%%%统计信噪比%%%%%%%%%
SNR_N_1=10*log10(P_I./S_e_N_1);
SNR_N_2=10*log10(P_I./S_e_N_2);
SNR_F_1=10*log10(P_I./S_e_F_1);
SNR_F_2=10*log10(P_I./S_e_F_2);
%%%%%%%%%%%%画图%%%%%%%%%%%%%
figure(1);
plot(P_db,SNR_N_1,'r');
hold on 
plot(P_db,SNR_N_2,'b');
hold on
plot(P_db,SNR_F_1,'r--');
hold on
plot(P_db,SNR_F_2,'b--');
legend('N=11,自然编码','N=12,自然编码','N=11,折叠编码','N=12,折叠编码');
xlabel('S_i');
ylabel('SNR_O');
grid on
title('SNR_O~S_i');