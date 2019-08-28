function [BER,receive_stream,Rx_phase,Rx_mag,Rx_phase_before,Rx_mag_before,complex_carrier_matrix]=QPSK(L,SNR,PrefixRatio,bit_stream,symbols_per_carrier)
carrier_count=1024;%子载波数
bits_per_symbol=2;%每符号含比特数,QPSK调制
IFFT_bin_length=4096;%FFT点数
%PrefixRatio=1/4;%保护间隔与OFDM数据的比例 1/4
GI=PrefixRatio*IFFT_bin_length ;%每一个OFDM符号添加的循环前缀长度为1/4*IFFT_bin_length  即保护间隔长度为512
beta=1/64;%窗函数滚降系数
GIP=beta*(IFFT_bin_length+GI);%循环后缀的长度80
%SNR=20; %信噪比dB
%L=6;%多径信道数量
max_length=L;
%================信号产生=============
baseband_out_length_nonpilot=carrier_count*symbols_per_carrier*bits_per_symbol;%所输入的比特数目
%================生成导频=============
pilot_length=carrier_count*bits_per_symbol;
baseband_out_pilot=round(rand(1,pilot_length));%输出待调制的二进制比特流，产生随机数0、1,作为导频；
baseband_out_length = baseband_out_length_nonpilot+pilot_length;
%================输入图像的二进制比特流
baseband_out(1:length(bit_stream))=(bit_stream)';
baseband_out(baseband_out_length_nonpilot+1:baseband_out_length)=baseband_out_pilot;
baseband_out_nonpilot=(bit_stream);
carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% 共轭对称子载波映射  复数数据对应的IFFT点坐标
conjugate_carriers = IFFT_bin_length - carriers + 2;%共轭对称子载波映射  共轭复数对应的IFFT点坐标
%==============QPSK调制==============
complex_carrier_matrix=QPSK_modu(baseband_out);%列向量，将0、1->0-16->-3，-1，1，3->复数（1024*2）
%complex_carrier_matrix_pilot=QPSK_modu(baseband_out_pilot);
complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier+1)';%12*1024（子载波符号数*子载波数）矩阵
%complex_carrier_matrix_pilot=reshape(complex_carrier_matrix_pilot',carrier_count,1)';
%=================IFFT===========================
IFFT_modulation=zeros(symbols_per_carrier+1,IFFT_bin_length);%添0组成IFFT_bin_length IFFT 运算 (12*2048)
IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%未添加导频信号 ，子载波映射在此处（0，1024）传正频率部分
IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%共轭复数映射，（-1024，0）传负频率部分
%=================================================================
signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM调制 即二维IFFT变换，得到（12*2048）
time_wave_matrix =signal_after_IFFT;%时域波形矩阵，行为每载波所含符号数，列IFFT点数，1024个子载波映射在其内，每一行即为一个OFDM符号
%===========================================================
%=====================添加循环前缀与后缀====================================
XX=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%（12*2048+前缀512+后缀80）
for k=1:symbols_per_carrier+1 %（1；12）
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
for i = 1:symbols_per_carrier+1 %（1；12）
windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%加窗  升余弦窗，矩阵（12*2640）
end  
%========================生成发送信号，并串变换==================================================
%前缀与后缀相叠加
windowed_Tx_data=zeros(1,(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP);%（1*（12*（2048+512）+80））
windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%第一行放在最前面
for i = 1:symbols_per_carrier
    windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%并串转换，循环后缀与循环前缀相叠加
end
%其余行放在后面，后缀在12个symbol之后
%=====================取出导频信号===============================
windowed_Tx_data_pilot=windowed_Tx_data((end-(IFFT_bin_length+GIP-1)):end);
%=======================================================
%前缀与后缀不叠加
Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP),1)';%加窗后 循环前缀与后缀不叠加 的串行信号
%=================================================================
temp_time1 = (symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP);%加窗后 循环前缀与后缀不叠加 发送总位数 12*2640
% figure (2)
% subplot(2,1,1);
% plot(0:temp_time1-1,Tx_data );%循环前缀与后缀不叠加 发送的信号波形
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('循环前后缀不叠加的OFDM Time Signal')
temp_time2 =(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP; %相叠加 12*（2048+512）+80
% subplot(2,1,2);
% plot(0:temp_time2-1,windowed_Tx_data);%循环后缀与循环前缀相叠加 发送信号波形
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('循环前后缀叠加的OFDM Time Signal')
%===============加窗的发送信号频谱=================================
symbols_per_average = ceil((symbols_per_carrier+1)/5);%符号数的1/5，3
avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%点数，10行数据，10个符号 2640*3
averages = floor(temp_time1/avg_temp_time); %4
average_fft(1:avg_temp_time) = 0;%分成4段 （1：2640*3）
for a = 0:(averages-1)
    subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%利用循环前缀后缀未叠加的串行加窗信号计算频谱
    subset_ofdm_f = abs(fft(subset_ofdm));%分段求频谱
    average_fft = average_fft + (subset_ofdm_f/averages);%总共的数据分为5段，分段进行FFT，平均相加
end
average_fft_log = 20*log10(average_fft);
%====================多径高斯信道=============================
delta=zeros(1,max_length);
alr=zeros(1,L);
ali=zeros(1,L);
for j = 1:L
    alr(:)=1/(2*L).^(1/2).*randn(1,L);
    ali(:)=1/(2*L).^(1/2).*randn(1,L);
    delta(1,j)=alr(1,j)+1i*ali(1,j);
end
windowed_ht_Tx_data=zeros(1,length(windowed_Tx_data)+max_length-1);
windowed_ht_Tx_data=conv(windowed_Tx_data,delta);
%====================添加噪声=================================
Tx_signal_power = mean((windowed_ht_Tx_data).*conj(windowed_ht_Tx_data));%发送信号功率
linear_SNR=10^(SNR/10);%线性信噪比 
noise_sigma=Tx_signal_power/linear_SNR;%噪声功率
noise_scale_factor = sqrt(noise_sigma/2);%标准差sigma
noise_length=((symbols_per_carrier+1)*(IFFT_bin_length+GI))+GIP+max_length-1;
noise=randn(1,noise_length)*noise_scale_factor+1i*randn(1,noise_length)*noise_scale_factor;%产生正态分布噪声序列
%============导频通过信道===========================
%windowed_ht_pilot_data=conv(windowed_Tx_data_pilot,delta);
Rx_data=windowed_ht_Tx_data+noise;%接收到的信号加噪声
windowed_ht_data_p=Rx_data((end-(IFFT_bin_length+GIP-1+max_length-1)):(end-(max_length-1)));
%=====================接收信号  串并变换 去除前缀与后缀==========================================
Rx_data_matrix=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%（12*2640）
for i=1:symbols_per_carrier+1
    Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%串并变换
end
Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%去除循环前缀与循环后缀，得到有用信号矩阵
%Rx_pilot=Rx_data_matrix(symbols_per_carrier+1:GI+1:IFFT_bin_length+GI);
%==============================================================
%                      OFDM解码   16QAM解码
%=================FFT变换=================================
Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM解码 即FFT变换
%=================导频的频域函数============================
X_p=fft(windowed_Tx_data_pilot,IFFT_bin_length,2);
Y_p=fft(windowed_ht_data_p,IFFT_bin_length,2);
%=================LS信道估计================================
Delta=Y_p./X_p;
%=================MMSE频域均衡===============================
W0=conj(Delta)./((abs(Delta)).^2+1/linear_SNR);
for ii=1:symbols_per_carrier
    Y1(ii,:)=W0.*Y0(ii,:);
end
Rx_carriers=Y1(:,carriers);%除去IFFT/FFT变换添加的0，选出映射的子载波，实部的1024个信息，也即子载波携带的有用信息
Rx_phase =angle(Rx_carriers);%接收信号的相位
Rx_mag = abs(Rx_carriers);%接收信号的幅度

Rx_carriers_before=Y0(1:symbols_per_carrier,carriers);
Rx_phase_before=angle(Rx_carriers_before);
Rx_mag_before=abs(Rx_carriers_before);

% figure(4);
% subplot(2,1,1);
% polar(Rx_phase_before,Rx_mag_before,'bd');
% title('极坐标下的接收信号的星座图-频域均衡前')
% subplot(2,1,2);
% polar(Rx_phase, Rx_mag,'bd');%极坐标坐标下画出接收信号的星座图
% title('极坐标下的接收信号的星座图-频域均衡后')
[M, N]=pol2cart(Rx_phase, Rx_mag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_phase_before, Rx_mag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
%====================QPSK解调=======================================
Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
Rx_decoded_binary_symbols=QPSK_demodu(Rx_serial_complex_symbols);
%============================================================
baseband_in = Rx_decoded_binary_symbols;
%================误码率计算==========================================
baseband_in_nonpilot=baseband_in(1:length(bit_stream));
bit_errors=find(baseband_in_nonpilot ~=baseband_out_nonpilot);
receive_stream=baseband_in_nonpilot;
bit_error_count = size(bit_errors, 2);
ber=bit_error_count/baseband_out_length_nonpilot;
BER=ber;