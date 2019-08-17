function [S_decode]=decode_N(N,V,S_code)
%%%%%%%%%%%%%%%%%输入量化位数N，量化范围[-V,+V],编码后信号S_N%%%%%%%%%%%%%%%%%%%
%Q=linspace(-V,+V,2^N);%生成分层电平;
Delta_V=2*V/2^N;%计算量化间隔
S_decode=bi2de(S_code).*Delta_V+(-V)+Delta_V/2;