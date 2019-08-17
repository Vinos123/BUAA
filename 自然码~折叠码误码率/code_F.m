function [S_out]=code_F(N,V,S_in)
%%%%%%%%%%%%%输入量化位数N,量化范围V,输入信号S_in%%%%%%%%%%%
Delta_V=2*V/2^N;
[x y]=size(S_in);
S_Sq=S_in.*(S_in < 1 & S_in > -1)+0.9999.*(S_in >=1)+(-0.9999).*(S_in <= -1);
S_temp=floor((S_Sq-(-V))./Delta_V);
S_vec=reshape(S_temp',x*y,1);
S_out_D=de2bi(S_vec);%自然码编码
S_index=find(~(S_out_D(:,N)));%找到自然码最高位为0的行数
S_out_D(S_index,1:(N-1))=~S_out_D(S_index,1:(N-1));%除最高位以外取反即得到折叠码。
S_out=S_out_D;

