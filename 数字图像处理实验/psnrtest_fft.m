function PSNR_fft2=psnrtest_fft(rate_fft)
Pic=imread('/Users/kobezhe/Downloads/lena512.bmp');
%%%%%%%%%��ɢ����Ҷ�任%%%%%%%%%%%%%%%%%%%%%%
Pic_fft2_original=fft2(Pic);
Pic_fft2_original_ab=abs(Pic_fft2_original);
%%%%%%%%%%%��ϵ������Ԫ������%%%%%%%%%%%
[x y]=size(Pic);
Pic_fft2_cl=reshape(Pic_fft2_original_ab,x*y,1);%��ϵ�������Ϊ������
[Pic_fft2_sort index]=sort(Pic_fft2_cl);%�õ����������ϵ������
%%%%%%%%%%������ֵ����95%��Сֵ����%%%%%%%%%%%
Thre=Pic_fft2_sort(round(x*y*rate_fft));
Pic_fft2_abzero=Pic_fft2_original.*(Pic_fft2_original_ab < Thre).*0+...
    Pic_fft2_original.*(Pic_fft2_original_ab >= Thre);
Pic_ifft2=ifft2(Pic_fft2_abzero);
Pic2show=uint8(round(Pic_ifft2));
PSNR_fft2=psnr(Pic,Pic2show);
end
