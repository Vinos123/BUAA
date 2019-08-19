clear all; 
clc;
syms t;%符号型变量
f_m=1;%调制信号频率
f_c=20;%载波信号频率
f_s=10*f_c;%采样频率
t_s=1/f_s;%采样时间步长
N=2^10;%FFT点数
m_t=cos(2*pi*f_m*t);%调制信号
m_c=cos(2*pi*f_c*t);%载波信号
s_t=cos(2*pi*f_c*t+50*int(m_t,t));%已调信号

t=t_s:t_s:4;%信号时长为4个调制信号的周期
%代入具体数值
m_t_1=eval(m_t);%调制信号代入数值
m_c_1=eval(m_c);%载波信号代入数值
s_t_1=eval(s_t);%已调信号代入数值
S_t=fftshift(fft(s_t_1,N))*t_s;%已调信号频谱，fftshift将频谱转化为以0频为中心
S_t_p=S_t.*conj(S_t);%已调信号功率谱;
%希尔伯特变换求已调信号的包络；
s_t_ah=hilbert(s_t_1);
s_t_a=abs(s_t_ah);
f=linspace(-f_s/2,f_s/2,N);%离散频率转化为连续频率;

figure(1);
subplot(2,2,1);
plot(t,m_t_1);
title("输入信号波形");
xlabel("t");
ylabel("m(t)");
grid on;
subplot(2,2,2);
plot(t,m_c_1);
title("载波信号波形");
xlabel("t");
ylabel("m_c(t)");
grid on;
subplot(2,2,3);
plot(t,s_t_1);
hold on
plot(t,s_t_a,'r','linewidth',2);
legend("已调信号","已调信号包络");
title("已调信号波形及其包络");
xlabel("t");
ylabel("s(t)")
grid on;
subplot(2,2,4);
plot(f,S_t_p);%功率谱
axis([-40 40 0 inf]);%限制横纵轴范围，
title("已调信号功率谱");
xlabel("f");
ylabel("G(f)");
grid on;
%