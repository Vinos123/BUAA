function [S_out]=code_N(N,V,S_in)
%%%%%输入量化位数N,量化区间边界值V,输入信号S_in%%%%%%%
Delta_V=2*V/2^N;
[x y]=size(S_in);
%%%%%%%%%%%%%%对输入信号进行限幅，将大于等于1和小于等于-1的信号幅度限制为0.05%%%%%%%%
S_Sq=S_in.*(S_in < 1 & S_in > -1)+0.9999.*(S_in >=1)+(-0.9999).*(S_in <= -1);
%%%%%%%%%%%%%%计算量化级数，向下取整%%%%%%%%%%%%%%%%%%%%
S_temp=floor((S_Sq-(-V))./Delta_V);
S_vec=reshape(S_temp',x*y,1);%转化为列向量
S_out=de2bi(S_vec);%十进制转二进制


