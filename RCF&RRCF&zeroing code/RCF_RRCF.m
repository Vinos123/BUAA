clear all;
a=[0.2 0.5 1];
Ts=1;%符号周期
fs=100;%频率间隔（指多少个Ts）
f=-5:1/fs:(5-1/fs);%频域坐标
N=2^12;%ifft点数

%%%%%%%%%%%%%%%升余弦滤波器频域表达式%%%%%%%%%%%%%%%%
for ii=1:length(a)
    G_f(ii,:)=Ts.*( abs(f) <= (1-a(ii))/(2*Ts) ) + ...
    (Ts/2)*(1+cos(pi*Ts/a(ii)*(abs(f)-(1-a(ii))/(2*Ts))))...
    .*( (abs(f) > (1-a(ii))/(2*Ts)) & (abs(f) <= (1+a(ii))/(2*Ts))) +...
    0.*(abs(f) > (1+a(ii))/(2*Ts));
    g_t(ii,:)=abs(ifftshift(ifft(G_f(ii,:),N)))*N/fs;%升余弦滤波器时域函数

    %%%%%%%%%%%%%%根升余弦滤波器频域函数%%%%%%%%%%%%%%%%%
    GG_f(ii,:)=G_f(ii,:).^(1/2);
    gg_t(ii,:)=abs(ifftshift(ifft(GG_f(ii,:),N)))*N/fs;%根升余弦滤波器时域函数
end


t=fs/N*(-N/2:1:((N-1)/2));%时间轴与频域对应坐标相匹配，能量守恒
%%%%%%%%%%%%%%画图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
for jj=1:length(a)
    subplot(2,2,1);
    plot(f,G_f(jj,:));
    grid on;
    hold on;
end
legend('\alpha=0.2','\alpha=0.5','\alpha=1');
title('升余弦滤波器频域波形');
for kk=1:length(a)
    subplot(2,2,2);
    plot(t,g_t(kk,:));
    axis([-3*Ts 3*Ts 0 inf]);
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('升余弦滤波器时域波形');
for ll=1:length(a)
    subplot(2,2,3);
    plot(f,GG_f(ll,:));
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('根升余弦滤波器频域波形');
for mm=1:length(a)
    subplot(2,2,4);
    plot(t,gg_t(mm,:));
    axis([-3*Ts 3*Ts 0 inf]);
    grid on;
    hold on;
end
    legend('\alpha=0.2','\alpha=0.5','\alpha=1');
    title('根升余弦滤波器时域波形');
