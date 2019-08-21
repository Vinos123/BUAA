clear all;
k=0;
i=0.2:0.01:1;
psnr_temp_fft=zeros(1,length(i));
psnr_temp_dct=zeros(1,length(i));
psnr_temp_hadamard=zeros(1,length(i));
for m=0.20:0.01:1
    k=k+1;
    psnr_temp_fft(k)=psnrtest_fft(m);
    psnr_temp_dct(k)=psnrtest_dct(m);
    psnr_temp_hadamard(k)=psnrtest_hadamard(m);
end
figure(1)
plot(i,psnr_temp_fft);
hold on
plot(i,psnr_temp_dct);
hold on
plot(i,psnr_temp_hadamard);
hold on
xlabel('rate');
ylabel('psnr');
legend('fft','dct','hadamard')
title('psnr~rate');
grid on
