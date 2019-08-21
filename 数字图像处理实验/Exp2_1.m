clear all;
clc;
Pic=imread('lena512.bmp');
[x,y]=size(Pic);
N=x;
u=-N/2:(N/2-1);
v=u';
T=5;
a=1;
b=1;
SNR=200;%���������
SNRR=10^(SNR/10);%���������
H=(T./(pi*(a*u+b*v)).*sin(pi*(a*u+b*v)).*exp(-1i*pi*(a*u+b*v)));
H((a*u+b*v)==0)=T;%�˶�����ģ�ʹ��ݺ���
Pic_fft=fftshift(fft2(Pic));

Pic_af_h=Pic_fft.*H;%��ͼ������˶�����
P_pic=mean(mean(Pic_af_h.*conj(Pic_af_h)));%���㽵�ʺ�Ĺ���
P_test=mean(Pic_af_h.*conj(Pic_af_h));
Pe=P_pic./SNRR;
Noise=0;%Pe.^(1/2)*randn(x,y);%�������������ʺ����Է��ȵ�˥��̫ǿ�������㽵��ǰ�Ĺ��ʣ��������Ҫ�ǳ�����ܻظ�

Pic_af_hn=Pic_af_h+Noise;%���ʺ��ͼ��
Pic_a_h=real(ifft2(ifftshift(Pic_af_hn)));

Pic2show=uint8(mat2gray(Pic_a_h)*255);


kk=1;
rr=0.1:0.01:1;
H_inv=ones(x,y);
PSNR_inv=zeros(1,length(rr));
for r=0.1:0.01:1
    x_inv=round(x*r);
    y_inv=round(y*r);
    x_range=round((x-x_inv)/2+1):round(x+x_inv)/2;
    y_range=round((y-y_inv)/2+1):round(y+y_inv)/2;
    H_inv(x_range,y_range)=H(x_range,y_range);
    Pic_invf=Pic_af_hn./H_inv;%���˲�����
    Pic_a_inv=abs(ifft2(Pic_invf));
    Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);
    PSNR_inv(kk)=psnr(Pic2show_inv,Pic);
    kk=kk+1;
end
[PSNR_best,r_best_index]=max(PSNR_inv);
r_best=rr(r_best_index);

x_inv=round(x*r_best);
y_inv=round(y*r_best);
x_range=round((x-x_inv)/2+1):round(x+x_inv)/2;

y_range=round((y-y_inv)/2+1):round(y+y_inv)/2;
H_inv(x_range,y_range)=H(x_range,y_range);

Pic_invf=Pic_af_hn./H_inv;%���˲�����
Pic_a_inv=real(ifft2(ifftshift(Pic_invf)));
Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);

figure(1);
imshow(Pic2show_inv);
PSNR_pic=psnr(Pic2show,Pic);
figure(2);
imshow(Pic2show);

