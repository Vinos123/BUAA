t=0:0.0001:4;%�ź�ʱ��Ϊ�ĸ������ź�����
f_m=1;%�����ź�Ƶ��
A_0=2;%ֱ������
f_c=20;%�ز��ź�Ƶ��
m_t=cos(2*pi*f_m*t);%�����ź�
M_t=fft(m_t,80002);%�����ź�Ƶ��
m_c=cos(2*pi*f_c*t);%�ز��ź�
s_t=(A_0+m_t).*m_c;%�ѵ��ź�
S_t=fft(s_t);%�ѵ��ź�Ƶ�ף�


%ϣ�����ر任ȡ������
y=hilbert(s_t);
Y_ab=abs(y);
%��ɽ����ͨ�˲�֮ǰ
s_t_1=s_t.*m_c;
%�任��Ƶ��
S_t_f=fft(s_t_1);
%��ͨ�˲���
H_l=zeros(1,length(S_t_f));
H_l(1:10)=1;
H_l((length(S_t_f)-10):length(S_t_f))=1;
%��ͨ�˲�
S_t_al=S_t_f.*H_l;
s_t_a=ifft(S_t_al);

figure(1);
subplot(3,2,1);
plot(t,m_t);%�����źŲ���
title('ͼһ�������źŲ���');
xlabel('t');
ylabel('m_t');
subplot(3,2,2);
plot(t,m_c);%�����źŲ���
title('ͼ�����ز��źŲ���');
xlabel('t');
ylabel('m_c');
subplot(3,2,3);
plot(t,s_t,'b');%�ѵ��źŲ���
hold on
plot(t,Y_ab,'r','linewidth',2);%���粨��
xlabel('t');
ylabel('s(t)');
title('ͼ�����ѵ��źŲ��μ������');
legend('AM�ѵ��ź�','�����ź�');
subplot(3,2,4);
plot(t,s_t_1);
title('ͼ�ģ���ͨ�˲�֮ǰ�Ĳ���');
xlabel('t');
ylabel('s_1(t)');
subplot(3,2,5);
plot(t,s_t_a);
title('ͼ�壺��ͨ�˲�֮��Ĳ���');
xlabel('t');
ylabel('s_a(t)');







