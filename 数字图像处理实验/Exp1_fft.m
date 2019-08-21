clear all;
clc;
Pic=imread('lena512.bmp');
%imshow(Pic);
%%%%%%%%%离散傅立叶变换%%%%%%%%%%%%%%%%%%%%%%
Pic_fft2_original=fft2(Pic);
Pic_fft2_original_ab=abs(Pic_fft2_original);
Pic_fft2=fftshift(fft2(Pic));
Pic_fft2_ab=(abs(Pic_fft2));%将图像元素模值取整，

%%%%将图像的值映射到0到255%%%%%%%%%
Pic_frange_fft2=max(max(Pic_fft2_ab))-min(min(Pic_fft2_ab));%图像变化的范围
Pic_fft2_abnorm=(Pic_fft2_ab-min(min(Pic_fft2_ab)))/Pic_frange_fft2*255;
figure(1);
imshow(Pic_fft2_abnorm);%显示归一化之后的频谱
%%%%%%%%%%%将系数矩阵元素排序%%%%%%%%%%%
[x y]=size(Pic);
Pic_fft2_cl=reshape(Pic_fft2_ab,x*y,1);%将系数矩阵变为列向量
[Pic_fft2_sort index]=sort(Pic_fft2_cl);%得到升序排序的系数矩阵
%%%%%%%%%%计算阈值并将95%的小值置零%%%%%%%%%%%
Thre=Pic_fft2_sort(round(x*y*0.95));
Pic_fft2_abzero=Pic_fft2_original.*(Pic_fft2_original_ab < Thre).*0+...
    Pic_fft2_original.*(Pic_fft2_original_ab >= Thre);
Pic_ifft2=ifft2(Pic_fft2_abzero);
%%%%%%%%%%画图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
Pic2show=uint8(round(Pic_ifft2));
imshow(uint8(round(Pic_ifft2)));
PSNR_fft2=psnr(Pic,Pic2show);