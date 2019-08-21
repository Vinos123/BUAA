function [BER,receive_stream,Rx_phase,Rx_mag,Rx_phase_before,Rx_mag_before,complex_carrier_matrix]=QAM16(L,SNR,PrefixRatio,bit_stream,symbols_per_carrier)
carrier_count=1024;%????????
bits_per_symbol=4;%??????????????,16QAM????
IFFT_bin_length=4096;%FFT????
%PrefixRatio=1/4;%??????????OFDM?????????? 1/4
GI=PrefixRatio*IFFT_bin_length ;%??????OFDM????????????????????????1/4*IFFT_bin_length  ????????????????512
beta=1/64;%??????????????
GIP=beta*(IFFT_bin_length+GI);%??????????????80
%SNR=20; %??????dB
%L=6;%????????????
max_length=L;
%================????????=============
baseband_out_length_nonpilot=carrier_count*symbols_per_carrier*bits_per_symbol;%????????????????
%================????????=============
pilot_length=carrier_count*bits_per_symbol;
baseband_out_pilot=round(rand(1,pilot_length));%????????????????????????????????????0??1,??????????
baseband_out_length = baseband_out_length_nonpilot+pilot_length;
%================??????????????????????
baseband_out(1:length(bit_stream))=(bit_stream)';
baseband_out(baseband_out_length_nonpilot+1:baseband_out_length)=baseband_out_pilot;
baseband_out_nonpilot=(bit_stream);
carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% ??????????????????  ??????????????IFFT??????
conjugate_carriers = IFFT_bin_length - carriers + 2;%??????????????????  ??????????????IFFT??????
%==============QAM16????==============
complex_carrier_matrix=QAM16_modu(baseband_out);%??????????0??1->0-16->-3??-1??1??3->??????1024*2??
%complex_carrier_matrix_pilot=QPSK_modu(baseband_out_pilot);
complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier+1)';%12*1024??????????????*??????????????
%complex_carrier_matrix_pilot=reshape(complex_carrier_matrix_pilot',carrier_count,1)';
%=================IFFT===========================
IFFT_modulation=zeros(symbols_per_carrier+1,IFFT_bin_length);%??0????IFFT_bin_length IFFT ???? (12*2048)
IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%?????????????? ????????????????????0??1024??????????????
IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%????????????????-1024??0??????????????
%=================================================================
signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM???? ??????IFFT????????????12*2048??
time_wave_matrix =signal_after_IFFT;%??????????????????????????????????????IFFT??????1024??????????????????????????????????OFDM????
%===========================================================
%=====================??????????????????====================================
XX=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%??12*2048+????512+????80??
for k=1:symbols_per_carrier+1 %??1??12??
    for i=1:IFFT_bin_length %??1??2048??
        XX(k,i+GI)=signal_after_IFFT(k,i); %?????????????? xx??k,i+512)=signal(k,i)
    end
    for i=1:GI
        XX(k,i)=signal_after_IFFT(k,i+IFFT_bin_length-GI);%???????????? xx(k,i)=signal(k,i+2048-512) ????????????????
    end
    for j=1:GIP %(1:40)
        XX(k,IFFT_bin_length+GI+j)=signal_after_IFFT(k,j);%???????????? xx(k,j+2048+512)=signal(k,j) ????????????????
    end
end
time_wave_matrix_cp=XX;%??????????????????????????????????,????????OFDM??????????IFFT_bin_length+GI+GIP=2048+512+80????????12*2640??
%==============OFDM????????==========================================
windowed_time_wave_matrix_cp=zeros(1,IFFT_bin_length+GI+GIP);%??1??2640??
for i = 1:symbols_per_carrier+1 %??1??12??
windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%????  ????????????????12*2640??
end  
%========================??????????????????????==================================================
%????????????????
windowed_Tx_data=zeros(1,(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP);%??1*??12*??2048+512??+80????
windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%????????????????
for i = 1:symbols_per_carrier
    windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%??????????????????????????????????
end
%??????????????????????12??symbol????
%=====================????????????===============================
windowed_Tx_data_pilot=windowed_Tx_data((end-(IFFT_bin_length+GIP-1)):end);
%=======================================================
%????????????????
Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP),1)';%?????? ???????????????????? ??????????
%=================================================================
temp_time1 = (symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP);%?????? ???????????????????? ?????????? 12*2640
% figure (2)
% subplot(2,1,1);
% plot(0:temp_time1-1,Tx_data );%???????????????????? ??????????????
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('??????????????????OFDM Time Signal')
temp_time2 =(symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP; %?????? 12*??2048+512??+80
% subplot(2,1,2);
% plot(0:temp_time2-1,windowed_Tx_data);%???????????????????????? ????????????
% grid on
% ylabel('Amplitude (volts)')
% xlabel('Time (samples)')
% title('????????????????OFDM Time Signal')
%===============??????????????????=================================
symbols_per_average = ceil((symbols_per_carrier+1)/5);%????????1/5??3
avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%??????10????????10?????? 2640*3
averages = floor(temp_time1/avg_temp_time); %4
average_fft(1:avg_temp_time) = 0;%????4?? ??1??2640*3??
for a = 0:(averages-1)
    subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%????????????????????????????????????????????
    subset_ofdm_f = abs(fft(subset_ofdm));%??????????
    average_fft = average_fft + (subset_ofdm_f/averages);%??????????????5????????????FFT??????????
end
average_fft_log = 20*log10(average_fft);
%====================????????????=============================
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
%====================????????=================================
Tx_signal_power = mean((windowed_ht_Tx_data).*conj(windowed_ht_Tx_data));%????????????
linear_SNR=10^(SNR/10);%?????????? 
noise_sigma=Tx_signal_power/linear_SNR;%????????
noise_scale_factor = sqrt(noise_sigma/2);%??????sigma
noise_length=((symbols_per_carrier+1)*(IFFT_bin_length+GI))+GIP+max_length-1;
noise=randn(1,noise_length)*noise_scale_factor+1i*randn(1,noise_length)*noise_scale_factor;%????????????????????
%============????????????===========================
%windowed_ht_pilot_data=conv(windowed_Tx_data_pilot,delta);
Rx_data=windowed_ht_Tx_data+noise;%??????????????????
windowed_ht_data_p=Rx_data((end-(IFFT_bin_length+GIP-1+max_length-1)):(end-(max_length-1)));
%=====================????????  ???????? ??????????????==========================================
Rx_data_matrix=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%??12*2640??
for i=1:symbols_per_carrier+1
    Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%????????
end
Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%????????????????????????????????????????
%Rx_pilot=Rx_data_matrix(symbols_per_carrier+1:GI+1:IFFT_bin_length+GI);
%==============================================================
%                      OFDM????   16QAM????
%=================FFT????=================================
Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM???? ??FFT????
%=================??????????????============================
X_p=fft(windowed_Tx_data_pilot,IFFT_bin_length,2);
Y_p=fft(windowed_ht_data_p,IFFT_bin_length,2);
%=================LS????????================================
Delta=Y_p./X_p;
%=================MMSE????????===============================
W0=conj(Delta)./((abs(Delta)).^2+1/SNR);
for ii=1:symbols_per_carrier
    Y1(ii,:)=W0.*Y0(ii,:);
end
Rx_carriers=Y1(:,carriers);%????IFFT/FFT??????????0??????????????????????????1024????????????????????????????????
Rx_phase =angle(Rx_carriers);%??????????????
Rx_mag = abs(Rx_carriers);%??????????????

Rx_carriers_before=Y0(1:symbols_per_carrier,carriers);
Rx_phase_before=angle(Rx_carriers_before);
Rx_mag_before=abs(Rx_carriers_before);

% figure(4);
% subplot(2,1,1);
% polar(Rx_phase_before,Rx_mag_before,'bd');
% title('??????????????????????????-??????????')
% subplot(2,1,2);
% polar(Rx_phase, Rx_mag,'bd');%????????????????????????????????
% title('??????????????????????????-??????????')
[M, N]=pol2cart(Rx_phase, Rx_mag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_phase_before, Rx_mag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
%====================16qam????=======================================
Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
Rx_decoded_binary_symbols=QAM16_demodu(Rx_serial_complex_symbols);
%============================================================
baseband_in = Rx_decoded_binary_symbols;
%================??????????==========================================
baseband_in_nonpilot=baseband_in(1:length(bit_stream));
bit_errors=find(baseband_in_nonpilot ~=baseband_out_nonpilot);
receive_stream=baseband_in_nonpilot;
bit_error_count = size(bit_errors, 2);
ber=bit_error_count/baseband_out_length_nonpilot;
BER=ber;