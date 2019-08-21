clear all;
clc;
Pic=imread('lena512.bmp');
%imshow(Pic);
%%%%%%%%%��ɢ����Ҷ�任%%%%%%%%%%%%%%%%%%%%%%
Pic_fft2_original=fft2(Pic);
Pic_fft2_original_ab=abs(Pic_fft2_original);
Pic_fft2=fftshift(fft2(Pic));
Pic_fft2_ab=(abs(Pic_fft2));%��ͼ��Ԫ��ģֵȡ����

%%%%��ͼ���ֵӳ�䵽0��255%%%%%%%%%
Pic_frange_fft2=max(max(Pic_fft2_ab))-min(min(Pic_fft2_ab));%ͼ��仯�ķ�Χ
Pic_fft2_abnorm=(Pic_fft2_ab-min(min(Pic_fft2_ab)))/Pic_frange_fft2*255;
figure(1);
imshow(Pic_fft2_abnorm);%��ʾ��һ��֮���Ƶ��
%%%%%%%%%%%��ϵ������Ԫ������%%%%%%%%%%%
[x y]=size(Pic);
Pic_fft2_cl=reshape(Pic_fft2_ab,x*y,1);%��ϵ�������Ϊ������
[Pic_fft2_sort index]=sort(Pic_fft2_cl);%�õ����������ϵ������
%%%%%%%%%%������ֵ����95%��Сֵ����%%%%%%%%%%%
Thre=Pic_fft2_sort(round(x*y*0.95));
Pic_fft2_abzero=Pic_fft2_original.*(Pic_fft2_original_ab < Thre).*0+...
    Pic_fft2_original.*(Pic_fft2_original_ab >= Thre);
Pic_ifft2=ifft2(Pic_fft2_abzero);
%%%%%%%%%%��ͼ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
Pic2show=uint8(round(Pic_ifft2));
imshow(uint8(round(Pic_ifft2)));
PSNR_fft2=psnr(Pic,Pic2show);