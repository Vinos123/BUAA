t=0:0.0001:4;%信号时长为四个调制信号周期
f_m=1;%调制信号频率
A_0=2;%直流分量
f_c=20;%载波信号频率
m_t=cos(2*pi*f_m*t);%调制信号
M_t=fft(m_t,80002);%调制信号频域；
m_c=cos(2*pi*f_c*t);%载波信号
s_t=(A_0+m_t).*m_c;%已调信号
S_t=fft(s_t);%已调信号频谱；


%希尔伯特变换取出包络
y=hilbert(s_t);
Y_ab=abs(y);
%相干解调低通滤波之前
s_t_1=s_t.*m_c;
%变换到频域
S_t_f=fft(s_t_1);
%低通滤波器
H_l=zeros(1,length(S_t_f));
H_l(1:10)=1;
H_l((length(S_t_f)-10):length(S_t_f))=1;
%低通滤波
S_t_al=S_t_f.*H_l;
s_t_a=ifft(S_t_al);

figure(1);
subplot(3,2,1);
plot(t,m_t);%输入信号波形
title('图一：输入信号波形');
xlabel('t');
ylabel('m_t');
subplot(3,2,2);
plot(t,m_c);%调制信号波形
title('图二：载波信号波形');
xlabel('t');
ylabel('m_c');
subplot(3,2,3);
plot(t,s_t,'b');%已调信号波形
hold on
plot(t,Y_ab,'r','linewidth',2);%包络波形
xlabel('t');
ylabel('s(t)');
title('图三：已调信号波形及其包络');
legend('AM已调信号','包络信号');
subplot(3,2,4);
plot(t,s_t_1);
title('图四：低通滤波之前的波形');
xlabel('t');
ylabel('s_1(t)');
subplot(3,2,5);
plot(t,s_t_a);
title('图五：低通滤波之后的波形');
xlabel('t');
ylabel('s_a(t)');







