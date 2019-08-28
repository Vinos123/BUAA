function [BER,ERRBIT]=OFDM_AMC(L,L_SNR,SNR,PrefixRatio,bits_per_symbol,symbols_per_carrier)
carrier_count=1024;%���ز���
%symbols_per_carrier=12;%ÿ���ز���������
%bits_per_symbol=6;%ÿ���ź�������,���Ʒ�ʽ
IFFT_bin_length=4096;%FFT����
%PrefixRatio=1/4;%���������OFDM���ݵı��� 1/4
GI=PrefixRatio*IFFT_bin_length;%ÿһ��OFDM������ӵ�ѭ��ǰ׺����Ϊ1/4*IFFT_bin_length  �������������Ϊ512
beta=1/32;%����������ϵ��
GIP=beta*(IFFT_bin_length+GI);%ѭ����׺�ĳ���80
%L_SNR=20; %�����dB
%L=6;%�ྶ�ŵ�����
W=20e6;%����20MHz
T=1/15000/(IFFT_bin_length+GI);%ÿһ��������ʱ��
%==================================================
%================�źŲ���===================================
sum_bits_per_symbol=0;
for i=1:carrier_count
    sum_bits_per_symbol=sum_bits_per_symbol + bits_per_symbol(i);
end
baseband_out_length = symbols_per_carrier * sum_bits_per_symbol;%������ı�����Ŀ
carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% ����Գ����ز�ӳ��  �������ݶ�Ӧ��IFFT������
conjugate_carriers = IFFT_bin_length - carriers + 2;%����Գ����ز�ӳ��  �������Ӧ��IFFT������
baseband_out=round(rand(1,baseband_out_length));%��������ƵĶ����Ʊ����������������0��1
%==============AMC����====================================
complex_carrier_matrix=modu(baseband_out,bits_per_symbol,carrier_count,symbols_per_carrier);%����������0��1->0-4->-1��1->������1024*2��
for i=1:carrier_count * symbols_per_carrier%����ɫ����
    SNR_factor(i)=sqrt(1/10^(SNR(ceil(i/symbols_per_carrier))/10));%ÿ�����ز���SNR
    rand_fi=(2*rand-1)*pi;%�����λ
    complex_carrier_matrix(i,1)=complex_carrier_matrix(i,1)+abs(complex_carrier_matrix(i,1))*SNR_factor(i)*randn(1,1)*(cos(rand_fi)+1i*sin(rand_fi));%�����������Ƶ����
end
complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier)';%12*1024�����ز�������*���ز���������
%=================IFFT===========================
IFFT_modulation=zeros(symbols_per_carrier,IFFT_bin_length);%��0���IFFT_bin_length IFFT ���� (12*2048)
IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%δ��ӵ�Ƶ�ź� �����ز�ӳ���ڴ˴���0��1024������Ƶ�ʲ���
IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%�����ӳ�䣬��-1024��0������Ƶ�ʲ���
%=================================================================
signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM���� ����άIFFT�任���õ���12*2048��
time_wave_matrix =signal_after_IFFT;%ʱ���ξ�����Ϊÿ�ز���������������IFFT������1024�����ز�ӳ�������ڣ�ÿһ�м�Ϊһ��OFDM����
%===========================================================
%=====================���ѭ��ǰ׺���׺====================================
XX=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%��12*2048+ǰ׺512+��׺80��
for k=1:symbols_per_carrier %��1��12��
    for i=1:IFFT_bin_length %��1��2048��
        XX(k,i+GI)=signal_after_IFFT(k,i); %Ų��ǰ׺��λ�� xx��k,i+512)=signal(k,i)
    end
    for i=1:GI
        XX(k,i)=signal_after_IFFT(k,i+IFFT_bin_length-GI);%���ѭ��ǰ׺ xx(k,i)=signal(k,i+2048-512) ����Ĳ�����ǰ׺
    end
    for j=1:GIP %(1:40)
        XX(k,IFFT_bin_length+GI+j)=signal_after_IFFT(k,j);%���ѭ����׺ xx(k,j+2048+512)=signal(k,j) ǰ��Ĳ�������׺
    end
end
time_wave_matrix_cp=XX;%�����ѭ��ǰ׺���׺��ʱ���źž���,��ʱһ��OFDM���ų���ΪIFFT_bin_length+GI+GIP=2048+512+80������12*2640��
%==============OFDM���żӴ�==========================================
windowed_time_wave_matrix_cp=zeros(1,IFFT_bin_length+GI+GIP);%��1��2640��
for i = 1:symbols_per_carrier %��1��12��
    windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%�Ӵ�  �����Ҵ�������12*2640��
end  
%========================���ɷ����źţ������任==================================================
%ǰ׺���׺�����
windowed_Tx_data=zeros(1,symbols_per_carrier*(IFFT_bin_length+GI)+GIP);%��1*��12*��2048+512��+80����
windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%��һ�з�����ǰ��
for i = 1:symbols_per_carrier-1 
    windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%����ת����ѭ����׺��ѭ��ǰ׺�����
end
%�����з��ں��棬��׺��12��symbol֮��
%=======================================================
%ǰ׺���׺������
Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier)*(IFFT_bin_length+GI+GIP),1)';%�Ӵ��� ѭ��ǰ׺���׺������ �Ĵ����ź�
%=================================================================
temp_time1 = (symbols_per_carrier)*(IFFT_bin_length+GI+GIP);%�Ӵ��� ѭ��ǰ׺���׺������ ������λ�� 12*2640
% figure (2)
% subplot(2,1,1);
% plot(0:temp_time1-1,Tx_data );%ѭ��ǰ׺���׺������ ���͵��źŲ���
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('ѭ��ǰ��׺�����ӵ�OFDM Time Signal')
% temp_time2 =symbols_per_carrier*(IFFT_bin_length+GI)+GIP; %����� 12*��2048+512��+80
% subplot(2,1,2);
% plot(0:temp_time2-1,windowed_Tx_data);%ѭ����׺��ѭ��ǰ׺����� �����źŲ���
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('ѭ��ǰ��׺���ӵ�OFDM Time Signal')
%===============�Ӵ��ķ����ź�Ƶ��=================================
symbols_per_average = ceil(symbols_per_carrier/5);%��������1/5��3
avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%������10�����ݣ�10������ 2640*3
averages = floor(temp_time1/avg_temp_time); %4
average_fft=zeros(1,avg_temp_time);
average_fft(1:avg_temp_time) = 0;%�ֳ�4�� ��1��2640*3��
for a = 0:(averages-1)
    subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%����ѭ��ǰ׺��׺δ���ӵĴ��мӴ��źż���Ƶ��
    subset_ofdm_f = abs(fft(subset_ofdm));%�ֶ���Ƶ��
    average_fft = average_fft + (subset_ofdm_f/averages);%�ܹ������ݷ�Ϊ5�Σ��ֶν���FFT��ƽ�����
end
average_fft_log = 20*log10(average_fft);
% figure (3)
% plot((0:(avg_temp_time-1))/avg_temp_time, average_fft_log)%��һ��  0/avg_temp_time  :  (avg_temp_time-1)/avg_temp_time
% hold on
% plot(0:1/IFFT_bin_length:1, -35, 'rd')
% grid on
% axis([0 0.5 -40 max(average_fft_log)])
% ylabel('Magnitude (dB)')
% xlabel('Normalized Frequency (0.5 = fs/2)')
% title('�Ӵ��ķ����ź�Ƶ��')
%====================�������=================================
Tx_signal_power = var(windowed_Tx_data);%�����źŹ���
linear_SNR=10^(L_SNR/10);%��������� 
noise_sigma=Tx_signal_power/linear_SNR;%��������
noise_scale_factor = noise_sigma^(1/2);%��׼��sigma
max_length=floor((L-1)/W/T)+1;
noise_length=((symbols_per_carrier)*(IFFT_bin_length+GI))+GIP+max_length-1;
noise=randn(1,noise_length)*noise_scale_factor;%������̬�ֲ���������
% ============================�ŵ���Ӧ======================================
alr=zeros(1,L);
ali=zeros(1,L);
delta=zeros(1,max_length);
windowed_ht_Tx_data=zeros(1,length(windowed_Tx_data)+max_length-1);%����L���ŵ��Ĵ��ݺ���
for j = 1:L
    alr(:)=1/L.*randn(1,L);
    ali(:)=1/L.*randn(1,L);
    delta(1,floor((j-1)/W/T)+1)=alr(1,j)+ali(1,j)*i;
end
windowed_ht_Tx_data=conv(windowed_Tx_data,delta);%ʱ����
Rx_data=windowed_ht_Tx_data+noise;%���յ����źż��ŵ�����
%=====================�����ź�  ��/���任 ȥ��ǰ׺���׺==========================================
Rx_data_matrix=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%��12*2640��
for i=1:symbols_per_carrier
    Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%�����任
end
Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%ȥ��ѭ��ǰ׺��ѭ����׺���õ������źž���
%==============================================================
%                      OFDM����   AMC����
%=================FFT�任=================================
Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM���� ��FFT�任
%=================MMSEƵ�����===============================
Delta=fft(delta,length(Y0));
W=zeros(symbols_per_carrier,IFFT_bin_length);
for i=1:symbols_per_carrier
    W(i,:)=conj(Delta)./((abs(Delta)).^2);
end
Y1=W.*Y0;
Rx_carriers=Y1(:,carriers);%��ȥIFFT/FFT�任��ӵ�0��ѡ��ӳ������ز���ʵ����1024����Ϣ��Ҳ�����ز�Я����������Ϣ
% ========================��ͼ��������====================================
Rx_phase =angle(Rx_carriers);%�����źŵ���λ
Rx_mag = abs(Rx_carriers);%�����źŵķ���
% figure(4);
% polar([0 2*pi], [0 25]);
% hold on;
% polar(Rx_phase, Rx_mag,'bd');%�����������»��������źŵ�����ͼ
% title('�������µĽ����źŵ�����ͼ')
% ====================��ͼ�� ֱ������==================================================
[M, N]=pol2cart(Rx_phase, Rx_mag); 
Rx_complex_carrier_matrix = complex(M, N);
% figure(5);
% plot(Rx_complex_carrier_matrix,'*r');%XY��������źŵ�����ͼ
% title('XY��������źŵ�����ͼ')
% axis([-16, 16, -16, 16]);
% grid on
%====================AMC���=======================================
Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
Rx_decoded_binary_symbols=demodu(Rx_serial_complex_symbols,bits_per_symbol,carrier_count,symbols_per_carrier);
%============================================================
baseband_in = Rx_decoded_binary_symbols;
% figure(6);
% subplot(2,1,1);
% stem(baseband_out(1:100));
% title('��������ƵĶ����Ʊ�����')
% subplot(2,1,2);
% stem(baseband_in(1:100));
% title('���ս����Ķ����Ʊ�����')
%================�����ʼ���==========================================
errcount=1;
errbit=zeros(1,baseband_out_length);%����λ�ñȽϣ�������󣬼�¼�����bit����λ�ã���������������ش�
for i=1:baseband_out_length
    if baseband_in(i)~=baseband_out(i)
        errbit(errcount)=i;
        errcount=errcount+1;
    end
end
ber=(errcount-1)/baseband_out_length;
BER=ber;
ERRBIT=errbit;