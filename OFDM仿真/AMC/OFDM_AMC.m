function [BER,ERRBIT]=OFDM_AMC(L,L_SNR,SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier)
carrier_count=1024;%子载波数
%symbols_per_carrier=12;%每子载波含符号数
%bits_per_symbol=6;%每符号含比特数,调制方式
IFFT_bin_length=4096;%FFT点数
%PrefixRatio=1/4;%保护间隔与OFDM数据的比例 1/4
GI=PrefixRatio*IFFT_bin_length;%每一个OFDM符号添加的循环前缀长度为1/4*IFFT_bin_length  即保护间隔长度为512
beta=1/32;%窗函数滚降系数
GIP=beta*(IFFT_bin_length+GI);%循环后缀的长度80
%L_SNR=20; %信噪比dB
%L=6;%多径信道数量
W=20e6;%带宽20MHz
T=1/15000/(IFFT_bin_length+GI);%每一个点数的时间
%==================================================
%================信号产生===================================
sum_bits_per_symbol=0;
for i=1:carrier_count
    sum_bits_per_symbol=sum_bits_per_symbol + bits_per_symbol(i);
end
baseband_out_length = symbols_per_carrier * sum_bits_per_symbol;%所输入的比特数目
carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% 共轭对称子载波映射  复数数据对应的IFFT点坐标
conjugate_carriers = IFFT_bin_length - carriers + 2;%共轭对称子载波映射  共轭复数对应的IFFT点坐标
baseband_out=round(rand(1,baseband_out_length));%输出待调制的二进制比特流，产生随机数0、1
%==============AMC调制====================================
complex_carrier_matrix=modu(baseband_out,bits_per_symbol,carrier_count,symbols_per_carrier);%列向量，将0、1->0-4->-1，1->复数（1024*2）
for i=1:carrier_count * symbols_per_carrier%加有色噪声
    SNR_factor(i)=sqrt(1/10^(SNR(ceil(i/symbols_per_carrier))/10));%每个子载波的SNR
    rand_fi=(2*rand-1)*pi;%随机相位
    complex_carrier_matrix(i,1)=complex_carrier_matrix(i,1)+abs(complex_carrier_matrix(i,1))*SNR_factor(i)*randn(1,1)*(cos(rand_fi)+1i*sin(rand_fi));%加随机噪声到频域上
end
complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier)';%12*1024（子载波符号数*子载波数）矩阵
%=================IFFT===========================
IFFT_modulation=zeros(symbols_per_carrier,IFFT_bin_length);%添0组成IFFT_bin_length IFFT 运算 (12*2048)
IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%未添加导频信号 ，子载波映射在此处（0，1024）传正频率部分
IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%共轭复数映射，（-1024，0）传负频率部分
%=================================================================
signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM调制 即二维IFFT变换，得到（12*2048）
time_wave_matrix =signal_after_IFFT;%时域波形矩阵，行为每载波所含符号数，列IFFT点数，1024个子载波映射在其内，每一行即为一个OFDM符号
%===========================================================
%=====================添加循环前缀与后缀====================================
XX=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%（12*2048+前缀512+后缀80）
for k=1:symbols_per_carrier %（1；12）
    for i=1:IFFT_bin_length %（1；2048）
        XX(k,i+GI)=signal_after_IFFT(k,i); %挪出前缀的位置 xx（k,i+512)=signal(k,i)
    end
    for i=1:GI
        XX(k,i)=signal_after_IFFT(k,i+IFFT_bin_length-GI);%添加循环前缀 xx(k,i)=signal(k,i+2048-512) 后面的部分做前缀
    end
    for j=1:GIP %(1:40)
        XX(k,IFFT_bin_length+GI+j)=signal_after_IFFT(k,j);%添加循环后缀 xx(k,j+2048+512)=signal(k,j) 前面的部分做后缀
    end
end
time_wave_matrix_cp=XX;%添加了循环前缀与后缀的时域信号矩阵,此时一个OFDM符号长度为IFFT_bin_length+GI+GIP=2048+512+80，矩阵（12*2640）
%==============OFDM符号加窗==========================================
windowed_time_wave_matrix_cp=zeros(1,IFFT_bin_length+GI+GIP);%（1，2640）
for i = 1:symbols_per_carrier %（1；12）
    windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%加窗  升余弦窗，矩阵（12*2640）
end  
%========================生成发送信号，并串变换==================================================
%前缀与后缀相叠加
windowed_Tx_data=zeros(1,symbols_per_carrier*(IFFT_bin_length+GI)+GIP);%（1*（12*（2048+512）+80））
windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%第一行放在最前面
for i = 1:symbols_per_carrier-1 
    windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%并串转换，循环后缀与循环前缀相叠加
end
%其余行放在后面，后缀在12个symbol之后
%=======================================================
%前缀与后缀不叠加
Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier)*(IFFT_bin_length+GI+GIP),1)';%加窗后 循环前缀与后缀不叠加 的串行信号
%=================================================================
temp_time1 = (symbols_per_carrier)*(IFFT_bin_length+GI+GIP);%加窗后 循环前缀与后缀不叠加 发送总位数 12*2640
% figure (2)
% subplot(2,1,1);
% plot(0:temp_time1-1,Tx_data );%循环前缀与后缀不叠加 发送的信号波形
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('循环前后缀不叠加的OFDM Time Signal')
% temp_time2 =symbols_per_carrier*(IFFT_bin_length+GI)+GIP; %相叠加 12*（2048+512）+80
% subplot(2,1,2);
% plot(0:temp_time2-1,windowed_Tx_data);%循环后缀与循环前缀相叠加 发送信号波形
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('循环前后缀叠加的OFDM Time Signal')
%===============加窗的发送信号频谱=================================
symbols_per_average = ceil(symbols_per_carrier/5);%符号数的1/5，3
avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%点数，10行数据，10个符号 2640*3
averages = floor(temp_time1/avg_temp_time); %4
average_fft=zeros(1,avg_temp_time);
average_fft(1:avg_temp_time) = 0;%分成4段 （1：2640*3）
for a = 0:(averages-1)
    subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%利用循环前缀后缀未叠加的串行加窗信号计算频谱
    subset_ofdm_f = abs(fft(subset_ofdm));%分段求频谱
    average_fft = average_fft + (subset_ofdm_f/averages);%总共的数据分为5段，分段进行FFT，平均相加
end
average_fft_log = 20*log10(average_fft);
% figure (3)
% plot((0:(avg_temp_time-1))/avg_temp_time, average_fft_log)%归一化  0/avg_temp_time  :  (avg_temp_time-1)/avg_temp_time
% hold on
% plot(0:1/IFFT_bin_length:1, -35, 'rd')
% grid on
% axis([0 0.5 -40 max(average_fft_log)])
% ylabel('Magnitude (dB)')
% xlabel('Normalized Frequency (0.5 = fs/2)')
% title('加窗的发送信号频谱')
%====================添加噪声=================================
Tx_signal_power = var(windowed_Tx_data);%发送信号功率
linear_SNR=10^(L_SNR/10);%线性信噪比 
noise_sigma=Tx_signal_power/linear_SNR;%噪声功率
noise_scale_factor = noise_sigma^(1/2);%标准差sigma
max_length=floor((L-1)/W/T)+1;
noise_length=((symbols_per_carrier)*(IFFT_bin_length+GI))+GIP+max_length-1;
noise=randn(1,noise_length)*noise_scale_factor;%产生正态分布噪声序列
% ============================信道响应======================================
alr=zeros(1,L);
ali=zeros(1,L);
delta=zeros(1,max_length);
windowed_ht_Tx_data=zeros(1,length(windowed_Tx_data)+max_length-1);%生成L个信道的传递函数
for j = 1:L
    alr(:)=1/L.*randn(1,L);
    ali(:)=1/L.*randn(1,L);
    delta(1,floor((j-1)/W/T)+1)=alr(1,j)+ali(1,j)*i;
end
windowed_ht_Tx_data=conv(windowed_Tx_data,delta);%时域卷积
Rx_data=windowed_ht_Tx_data+noise;%接收到的信号加信道噪声
%=====================接收信号  串/并变换 去除前缀与后缀==========================================
Rx_data_matrix=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%（12*2640）
for i=1:symbols_per_carrier
    Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%串并变换
end
Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%去除循环前缀与循环后缀，得到有用信号矩阵
%==============================================================
%                      OFDM解码   AMC解码
%=================FFT变换=================================
Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM解码 即FFT变换
%=================MMSE频域均衡===============================
Delta=fft(delta,length(Y0));
W=zeros(symbols_per_carrier,IFFT_bin_length);
for i=1:symbols_per_carrier
    W(i,:)=conj(Delta)./((abs(Delta)).^2);
end
Y1=W.*Y0;
Rx_carriers=Y1(:,carriers);%除去IFFT/FFT变换添加的0，选出映射的子载波，实部的1024个信息，也即子载波携带的有用信息
% ========================绘图：极坐标====================================
Rx_phase =angle(Rx_carriers);%接收信号的相位
Rx_mag = abs(Rx_carriers);%接收信号的幅度
% figure(4);
% polar([0 2*pi], [0 25]);
% hold on;
% polar(Rx_phase, Rx_mag,'bd');%极坐标坐标下画出接收信号的星座图
% title('极坐标下的接收信号的星座图')
% ====================绘图： 直角坐标==================================================
[M, N]=pol2cart(Rx_phase, Rx_mag); 
Rx_complex_carrier_matrix = complex(M, N);
% figure(5);
% plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
% title('XY坐标接收信号的星座图')
% axis([-16, 16, -16, 16]);
% grid on
%====================AMC解调=======================================
Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
Rx_decoded_binary_symbols=demodu(Rx_serial_complex_symbols,bits_per_symbol,carrier_count,symbols_per_carrier);
%============================================================
baseband_in = Rx_decoded_binary_symbols;
% figure(6);
% subplot(2,1,1);
% stem(baseband_out(1:100));
% title('输出待调制的二进制比特流')
% subplot(2,1,2);
% stem(baseband_in(1:100));
% title('接收解调后的二进制比特流')
%================误码率计算==========================================
errcount=1;
errbit=zeros(1,baseband_out_length);%挨个位置比较，检查正误，记录错误的bit所在位置，计算错误总数，回传
for i=1:baseband_out_length
    if baseband_in(i)~=baseband_out(i)
        errbit(errcount)=i;
        errcount=errcount+1;
    end
end
ber=(errcount-1)/baseband_out_length;
BER=ber;
ERRBIT=errbit;