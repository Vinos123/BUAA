function [BER,receive_stream,Rx_phase,Rx_mag,Rx_phase_before,Rx_mag_before,complex_carrier_matrix]=QPSK(L,SNR,PrefixRatio,bit_stream,symbols_per_carrier)
carrier_count=1024;%���ز���
bits_per_symbol=2;%ÿ���ź�������,QPSK����
IFFT_bin_length=4096;%FFT����
%PrefixRatio=1/4;%���������OFDM���ݵı��� 1/4
GI=PrefixRatio*IFFT_bin_length ;%ÿһ��OFDM������ӵ�ѭ��ǰ׺����Ϊ1/4*IFFT_bin_length  �������������Ϊ512
beta=1/64;%����������ϵ��
GIP=beta*(IFFT_bin_length+GI);%ѭ����׺�ĳ���80
%SNR=20; %�����dB
%L=6;%�ྶ�ŵ�����
max_length=L;
%================�źŲ���=============
baseband_out_length_nonpilot=carrier_count*symbols_per_carrier*bits_per_symbol;%������ı�����Ŀ
%================���ɵ�Ƶ=============
pilot_length=carrier_count*bits_per_symbol;
baseband_out_pilot=round(rand(1,pilot_length));%��������ƵĶ����Ʊ����������������0��1,��Ϊ��Ƶ��
baseband_out_length = baseband_out_length_nonpilot+pilot_length;
%================����ͼ��Ķ����Ʊ�����
baseband_out(1:length(bit_stream))=(bit_stream)';
baseband_out(baseband_out_length_nonpilot+1:baseband_out_length)=baseband_out_pilot;
baseband_out_nonpilot=(bit_stream);
carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% ����Գ����ز�ӳ��  �������ݶ�Ӧ��IFFT������
conjugate_carriers = IFFT_bin_length - carriers + 2;%����Գ����ز�ӳ��  �������Ӧ��IFFT������
%==============QPSK����==============
complex_carrier_matrix=QPSK_modu(baseband_out);%����������0��1->0-16->-3��-1��1��3->������1024*2��
%complex_carrier_matrix_pilot=QPSK_modu(baseband_out_pilot);
complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier+1)';%12*1024�����ز�������*���ز���������
%complex_carrier_matrix_pilot=reshape(complex_carrier_matrix_pilot',carrier_count,1)';
%=================IFFT===========================
IFFT_modulation=zeros(symbols_per_carrier+1,IFFT_bin_length);%��0���IFFT_bin_length IFFT ���� (12*2048)
IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%δ��ӵ�Ƶ�ź� �����ز�ӳ���ڴ˴���0��1024������Ƶ�ʲ���
IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%�����ӳ�䣬��-1024��0������Ƶ�ʲ���
%=================================================================
signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM���� ����άIFFT�任���õ���12*2048��
time_wave_matrix =signal_after_IFFT;%ʱ���ξ�����Ϊÿ�ز���������������IFFT������1024�����ز�ӳ�������ڣ�ÿһ�м�Ϊһ��OFDM����
%===========================================================
%=====================���ѭ��ǰ׺���׺====================================
XX=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%��12*2048+ǰ׺512+��׺80��
for k=1:symbols_per_carrier+1 %��1��12��
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
for i = 1:symbols_per_carrier+1 %��1��12��
windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%�Ӵ�  �����Ҵ�������12*2640��
end  
%========================���ɷ����źţ������任==================================================
%ǰ׺���׺�����
windowed_Tx_data=zeros(1,(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP);%��1*��12*��2048+512��+80����
windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%��һ�з�����ǰ��
for i = 1:symbols_per_carrier
    windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%����ת����ѭ����׺��ѭ��ǰ׺�����
end
%�����з��ں��棬��׺��12��symbol֮��
%=====================ȡ����Ƶ�ź�===============================
windowed_Tx_data_pilot=windowed_Tx_data((end-(IFFT_bin_length+GIP-1)):end);
%=======================================================
%ǰ׺���׺������
Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP),1)';%�Ӵ��� ѭ��ǰ׺���׺������ �Ĵ����ź�
%=================================================================
temp_time1 = (symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP);%�Ӵ��� ѭ��ǰ׺���׺������ ������λ�� 12*2640
% figure (2)
% subplot(2,1,1);
% plot(0:temp_time1-1,Tx_data );%ѭ��ǰ׺���׺������ ���͵��źŲ���
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('ѭ��ǰ��׺�����ӵ�OFDM Time Signal')
temp_time2 =(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP; %����� 12*��2048+512��+80
% subplot(2,1,2);
% plot(0:temp_time2-1,windowed_Tx_data);%ѭ����׺��ѭ��ǰ׺����� �����źŲ���
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('ѭ��ǰ��׺���ӵ�OFDM Time Signal')
%===============�Ӵ��ķ����ź�Ƶ��=================================
symbols_per_average = ceil((symbols_per_carrier+1)/5);%��������1/5��3
avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%������10�����ݣ�10������ 2640*3
averages = floor(temp_time1/avg_temp_time); %4
average_fft(1:avg_temp_time) = 0;%�ֳ�4�� ��1��2640*3��
for a = 0:(averages-1)
    subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%����ѭ��ǰ׺��׺δ���ӵĴ��мӴ��źż���Ƶ��
    subset_ofdm_f = abs(fft(subset_ofdm));%�ֶ���Ƶ��
    average_fft = average_fft + (subset_ofdm_f/averages);%�ܹ������ݷ�Ϊ5�Σ��ֶν���FFT��ƽ�����
end
average_fft_log = 20*log10(average_fft);
%====================�ྶ��˹�ŵ�=============================
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
%====================�������=================================
Tx_signal_power = mean((windowed_ht_Tx_data).*conj(windowed_ht_Tx_data));%�����źŹ���
linear_SNR=10^(SNR/10);%��������� 
noise_sigma=Tx_signal_power/linear_SNR;%��������
noise_scale_factor = sqrt(noise_sigma/2);%��׼��sigma
noise_length=((symbols_per_carrier+1)*(IFFT_bin_length+GI))+GIP+max_length-1;
noise=randn(1,noise_length)*noise_scale_factor+1i*randn(1,noise_length)*noise_scale_factor;%������̬�ֲ���������
%============��Ƶͨ���ŵ�===========================
%windowed_ht_pilot_data=conv(windowed_Tx_data_pilot,delta);
Rx_data=windowed_ht_Tx_data+noise;%���յ����źż�����
windowed_ht_data_p=Rx_data((end-(IFFT_bin_length+GIP-1+max_length-1)):(end-(max_length-1)));
%=====================�����ź�  �����任 ȥ��ǰ׺���׺==========================================
Rx_data_matrix=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%��12*2640��
for i=1:symbols_per_carrier+1
    Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%�����任
end
Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%ȥ��ѭ��ǰ׺��ѭ����׺���õ������źž���
%Rx_pilot=Rx_data_matrix(symbols_per_carrier+1:GI+1:IFFT_bin_length+GI);
%==============================================================
%                      OFDM����   16QAM����
%=================FFT�任=================================
Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM���� ��FFT�任
%=================��Ƶ��Ƶ����============================
X_p=fft(windowed_Tx_data_pilot,IFFT_bin_length,2);
Y_p=fft(windowed_ht_data_p,IFFT_bin_length,2);
%=================LS�ŵ�����================================
Delta=Y_p./X_p;
%=================MMSEƵ�����===============================
W0=conj(Delta)./((abs(Delta)).^2+1/linear_SNR);
for ii=1:symbols_per_carrier
    Y1(ii,:)=W0.*Y0(ii,:);
end
Rx_carriers=Y1(:,carriers);%��ȥIFFT/FFT�任��ӵ�0��ѡ��ӳ������ز���ʵ����1024����Ϣ��Ҳ�����ز�Я����������Ϣ
Rx_phase =angle(Rx_carriers);%�����źŵ���λ
Rx_mag = abs(Rx_carriers);%�����źŵķ���

Rx_carriers_before=Y0(1:symbols_per_carrier,carriers);
Rx_phase_before=angle(Rx_carriers_before);
Rx_mag_before=abs(Rx_carriers_before);

% figure(4);
% subplot(2,1,1);
% polar(Rx_phase_before,Rx_mag_before,'bd');
% title('�������µĽ����źŵ�����ͼ-Ƶ�����ǰ')
% subplot(2,1,2);
% polar(Rx_phase, Rx_mag,'bd');%�����������»��������źŵ�����ͼ
% title('�������µĽ����źŵ�����ͼ-Ƶ������')
[M, N]=pol2cart(Rx_phase, Rx_mag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_phase_before, Rx_mag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
%====================QPSK���=======================================
Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
Rx_decoded_binary_symbols=QPSK_demodu(Rx_serial_complex_symbols);
%============================================================
baseband_in = Rx_decoded_binary_symbols;
%================�����ʼ���==========================================
baseband_in_nonpilot=baseband_in(1:length(bit_stream));
bit_errors=find(baseband_in_nonpilot ~=baseband_out_nonpilot);
receive_stream=baseband_in_nonpilot;
bit_error_count = size(bit_errors, 2);
ber=bit_error_count/baseband_out_length_nonpilot;
BER=ber;