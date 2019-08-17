function [S_decode]=decode_F(N,V,S_code)
%%%%%%%%%%%%%%%%%%%输入量化位数N,量化范围V,编码后信号S_code%%%%%%%%%%%%%%%%%%%%
Delta_V=2*V/2^N;
S_index=find(~(S_code(:,N)));%找到自然码最高位为0的行数
S_code(S_index,1:(N-1))=~S_code(S_index,1:(N-1));%除最高位以外取反得到对应的自然码
S_decode=bi2de(S_code).*Delta_V+(-V)+Delta_V/2;%恢复电平