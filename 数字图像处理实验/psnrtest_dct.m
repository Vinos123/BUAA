function psnr_dct2=psnrtest_dct(rate_dct)
Pic=imread('/Users/kobezhe/Downloads/lena512.bmp');
%%%%%%%%%��ɢ���ұ任%%%%%%%%%%%%%%%%%%%%%%%
Pic_dct2=dct2(Pic);
Pic_dct2_ab=abs(Pic_dct2);
%%%%%%%%��ϵ������Ԫ������%%%%%%%%%%%%%%
[x1 y1]=size(Pic);
Pic_dct2_cl=reshape(Pic_dct2_ab,x1*y1,1);
[Pic_dct2_sorted index]=sort(Pic_dct2_cl);
%%%%%%%%����ֵ����95%Сֵ����%%%%%%%%%%%
Thre=Pic_dct2_sorted(round(x1*y1*rate_dct));
Pic_dct2_zero=Pic_dct2.*( Pic_dct2_ab < Thre).*0+Pic_dct2.*(Pic_dct2_ab>=Thre);
Pic_idct2=idct2(Pic_dct2_zero);
Pic2show=uint8(round(Pic_idct2));
psnr_dct2=psnr(Pic2show,Pic);
