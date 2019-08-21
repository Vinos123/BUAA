function PSNR_fft2=psnrtest_fft(rate_fft)
Pic=imread('/Users/kobezhe/Downloads/lena512.bmp');
%%%%%%%%%离散傅立叶变换%%%%%%%%%%%%%%%%%%%%%%
Pic_fft2_original=fft2(Pic);
Pic_fft2_original_ab=abs(Pic_fft2_original);
%%%%%%%%%%%将系数矩阵元素排序%%%%%%%%%%%
[x y]=size(Pic);
Pic_fft2_cl=reshape(Pic_fft2_original_ab,x*y,1);%将系数矩阵变为列向量
[Pic_fft2_sort index]=sort(Pic_fft2_cl);%得到升序排序的系数矩阵
%%%%%%%%%%计算阈值并将95%的小值置零%%%%%%%%%%%
Thre=Pic_fft2_sort(round(x*y*rate_fft));
Pic_fft2_abzero=Pic_fft2_original.*(Pic_fft2_original_ab < Thre).*0+...
    Pic_fft2_original.*(Pic_fft2_original_ab >= Thre);
Pic_ifft2=ifft2(Pic_fft2_abzero);
Pic2show=uint8(round(Pic_ifft2));
PSNR_fft2=psnr(Pic,Pic2show);
end
