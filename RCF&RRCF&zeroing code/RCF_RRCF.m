clear all;
a=[0.2 0.5 1];
Ts=1;%��������
fs=100;%Ƶ�ʼ����ָ���ٸ�Ts��
f=-5:1/fs:(5-1/fs);%Ƶ������
N=2^12;%ifft����

%%%%%%%%%%%%%%%�������˲���Ƶ����ʽ%%%%%%%%%%%%%%%%
for ii=1:length(a)
    G_f(ii,:)=Ts.*( abs(f) <= (1-a(ii))/(2*Ts) ) + ...
    (Ts/2)*(1+cos(pi*Ts/a(ii)*(abs(f)-(1-a(ii))/(2*Ts))))...
    .*( (abs(f) > (1-a(ii))/(2*Ts)) & (abs(f) <= (1+a(ii))/(2*Ts))) +...
    0.*(abs(f) > (1+a(ii))/(2*Ts));
    g_t(ii,:)=abs(ifftshift(ifft(G_f(ii,:),N)))*N/fs;%�������˲���ʱ����

    %%%%%%%%%%%%%%���������˲���Ƶ����%%%%%%%%%%%%%%%%%
    GG_f(ii,:)=G_f(ii,:).^(1/2);
    gg_t(ii,:)=abs(ifftshift(ifft(GG_f(ii,:),N)))*N/fs;%���������˲���ʱ����
end


t=fs/N*(-N/2:1:((N-1)/2));%ʱ������Ƶ���Ӧ������ƥ�䣬�����غ�
%%%%%%%%%%%%%%��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
for jj=1:length(a)
    subplot(2,2,1);
    plot(f,G_f(jj,:));
    grid on;
    hold on;
end
legend('\alpha=0.2','\alpha=0.5','\alpha=1');
title('�������˲���Ƶ����');
for kk=1:length(a)
    subplot(2,2,2);
    plot(t,g_t(kk,:));
    axis([-3*Ts 3*Ts 0 inf]);
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('�������˲���ʱ����');
for ll=1:length(a)
    subplot(2,2,3);
    plot(f,GG_f(ll,:));
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('���������˲���Ƶ����');
for mm=1:length(a)
    subplot(2,2,4);
    plot(t,gg_t(mm,:));
    axis([-3*Ts 3*Ts 0 inf]);
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('���������˲���ʱ����');
