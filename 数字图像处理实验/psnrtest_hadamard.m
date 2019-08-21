function psnr_hadamard=psnrtest_hadamard(rate_hadamard)

Pic=imread('/Users/kobezhe/Downloads/lena512.bmp');
[x2 y2]=size(Pic);
H=hadamard(x2);
Pic_dht2=1/(x2)*H*double(Pic)*H';
Pic_dht2_ab=abs(Pic_dht2);
%%%%%%%æÿ’Û‘™Àÿ≈≈–Ú%%%%%%%%%%%%%%%
Pic_dht2_cl=reshape(Pic_dht2_ab,x2*y2,1);
[Pic_dht2_sorted index]=sort(Pic_dht2_cl);
Thre=Pic_dht2_sorted(round(x2*y2*rate_hadamard));
Pic_dht2_zero=Pic_dht2.*(Pic_dht2_ab < Thre).*0+Pic_dht2.*(Pic_dht2_ab >= Thre);
Pic_idht2=1/(y2)*H*Pic_dht2_zero*H';
Pic2show=uint8(round(Pic_idht2));
psnr_hadamard=psnr(Pic2show,Pic);
