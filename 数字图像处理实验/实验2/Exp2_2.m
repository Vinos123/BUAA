clear all;
clc;
Pic=imread('lena512.bmp');
[x,y]=size(Pic);
N=x;
u=-N/2:(N/2-1);
v=u';
T=1;
a=0.02;
b=0.02;

SNR=20;%���������
SNRR=10^(SNR/10);%���������
H=(T./(pi*(a*u+b*v)).*sin(pi*(a*u+b*v)).*exp(-1i*pi*(a*u+b*v)));
H((a*u+b*v)==0)=T;%�˶�����ģ�ʹ��ݺ���
Pic_fft=fftshift(fft2(Pic));

Pic_af_h=Pic_fft.*H;%��ͼ������˶�����
P_pic=mean(mean(Pic_af_h.*conj(Pic_af_h)));%���㽵�ʺ�Ĺ���
P_test=mean(Pic_af_h.*conj(Pic_af_h));
Pe=P_pic./SNRR;
Noise=Pe.^(1/2)*randn(x,y);%�������������ʺ����Է��ȵ�˥��̫ǿ�������㽵��ǰ�Ĺ��ʣ��������Ҫ�ǳ�����ܻظ�

Pic_af_hn=Pic_af_h+Noise;%���ʺ��ͼ��
Pic_a_h=abs(ifft2(ifftshift(Pic_af_hn)));

Pic2show=uint8(mat2gray(Pic_a_h)*255);


aa=1;
kk=0:0.01:1;
% H_inv=ones(x,y);
PSNR_inv=zeros(1,length(kk));
for k=0:0.01:1

    H_inv=conj(H)./(H.*conj(H)+k);
    Pic_invf=Pic_af_hn.*H_inv;%���˲�����
    Pic_a_inv=abs(ifft2(ifftshift(Pic_invf)));
    Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);
    PSNR_inv(aa)=psnr(Pic2show_inv,Pic);
    aa=aa+1;
end

[PSNR_best,k_best_index]=max(PSNR_inv);
k_best=kk(k_best_index);

H_inv=conj(H)./(H.*conj(H)+k_best);

Pic_invf=Pic_af_hn.*H_inv;%���˲�����
Pic_a_inv=abs(ifft2(ifftshift(Pic_invf)));
Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);

figure(1);
imshow(Pic2show_inv);
% PSNR_inv=psnr(Pic2show_inv,Pic);
PSNR_pic=psnr(Pic2show,Pic);
figure(2);
imshow(Pic2show);

