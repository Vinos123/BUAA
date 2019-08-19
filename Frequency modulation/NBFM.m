clear all; 
clc;
syms t;%�����ͱ���
f_m=10;%�����ź�Ƶ��
f_c=200;%�ز��ź�Ƶ��
f_s=10*f_c;%����Ƶ��
t_s=1/f_s;%����ʱ�䲽��
N=2^10;%FFT����
m_t=cos(2*pi*f_m*t);%�����ź�
m_c=cos(2*pi*f_c*t);%�ز��ź�
s_t=cos(2*pi*f_c*t+int(m_t,t));%�ѵ��ź�

t=t_s:t_s:0.4;%�ź�ʱ��Ϊ4�������źŵ�����
%���������ֵ
m_t_1=eval(m_t);%�����źŴ�����ֵ
m_c_1=eval(m_c);%�ز��źŴ�����ֵ
s_t_1=eval(s_t);%�ѵ��źŴ�����ֵ
S_t=fftshift(fft(s_t_1,N))*t_s;%�ѵ��ź�Ƶ��;
S_t_p=S_t.*conj(S_t);%�ѵ��źŹ�����;
%ϣ�����ر任���ѵ��źŵİ��磻
s_t_ah=hilbert(s_t_1);
s_t_a=abs(s_t_ah);
f=linspace(-f_s/2,f_s/2,N);%��ɢƵ��ת��Ϊ����Ƶ��;%�ĸ��ź�������˳���4

figure(1);
subplot(2,2,1);
plot(t,m_t_1);
title("ͼһ�������źŲ���");
xlabel("t");
ylabel("m(t)");
grid on;
subplot(2,2,2);
plot(t,m_c_1);
title("ͼ�����ز��źŲ���");
xlabel("t");
ylabel("m_c(t)");
grid on;
subplot(2,2,3);
plot(t,s_t_1);
hold on
plot(t,s_t_a,'r','linewidth',2);
legend("�ѵ��ź�","�ѵ��źŰ���");
title("ͼ�����ѵ��źŲ��μ������");
xlabel("t");
ylabel("s(t)")
grid on;
subplot(2,2,4);
plot(f,S_t_p);%������
axis([-400 400 0 0.001]);%���ƺ����᷶Χ
title("ͼ�ģ��ѵ��źŹ�����");
xlabel("f");
ylabel("G(f)");
grid on;
%