clear all;
clc;
Pic=imread('lena512.bmp');
%%%%%%%%%离散余弦变换%%%%%%%%%%%%%%%%%%%%%%%
Pic_dct2=dct2(Pic);
Pic_dct2_ab=abs(Pic_dct2);
%%%%%%%%%将图像元素的取值范围映射到0到255
Pic_frange_dct2=max(max(Pic_dct2_ab))-min(min(Pic_dct2_ab));
Pic_dct2_abnorm=(Pic_dct2_ab-min(min(Pic_dct2_ab)))/Pic_frange_dct2*255;
figure(1)
imshow(Pic_dct2_abnorm);
%%%%%%%%将系数矩阵元素排序%%%%%%%%%%%%%%
[x1 y1]=size(Pic);
Pic_dct2_cl=reshape(Pic_dct2_ab,x1*y1,1);
[Pic_dct2_sorted index]=sort(Pic_dct2_cl);
%%%%%%%%求阈值，将95%小值置零%%%%%%%%%%%
Thre=Pic_dct2_sorted(round(x1*y1*0.95));
Pic_dct2_zero=Pic_dct2.*( Pic_dct2_ab < Thre).*0+Pic_dct2.*(Pic_dct2_ab>=Thre);
Pic_idct2=idct2(Pic_dct2_zero);
figure(2)
Pic2show=uint8(round(Pic_idct2));
imshow(Pic2show);
psnr_dct2=psnr(Pic2show,Pic);
