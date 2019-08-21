clear all;
clc;
Pic=imread('lena512.bmp');
[x2 y2]=size(Pic);
H=hadamard(x2);
Pic_dht2=1/(x2)*H*double(Pic)*H';
Pic_dht2_ab=abs(Pic_dht2);
%%%%%%%%%”≥…‰µΩ0µΩ255%%%%%%%%%%%%
Pic_frange_dht=max(max(Pic_dht2_ab)-min(min(Pic_dht2_ab)));
Pic_abnorm=(Pic_dht2_ab-min(min(Pic_dht2_ab)))/Pic_frange_dht*255;
figure(1)
imshow(Pic_abnorm);
%%%%%%%æÿ’Û‘™Àÿ≈≈–Ú%%%%%%%%%%%%%%%
Pic_dht2_cl=reshape(Pic_dht2_ab,x2*y2,1);
[Pic_dht2_sorted index]=sort(Pic_dht2_cl);
Thre=Pic_dht2_sorted(round(x2*y2*0.95));
Pic_dht2_zero=Pic_dht2.*(Pic_dht2_ab < Thre).*0+Pic_dht2.*(Pic_dht2_ab >= Thre);
Pic_idht2=1/(y2)*H*Pic_dht2_zero*H';
Pic2show=uint8(round(Pic_idht2));
figure(2)
imshow(Pic2show);
psnr_hadamard=psnr(Pic2show,Pic);