function [S_decode]=decode_N(N,V,S_code)
%%%%%%%%%%%%%%%%%��������λ��N��������Χ[-V,+V],������ź�S_N%%%%%%%%%%%%%%%%%%%
%Q=linspace(-V,+V,2^N);%���ɷֲ��ƽ;
Delta_V=2*V/2^N;%�����������
S_decode=bi2de(S_code).*Delta_V+(-V)+Delta_V/2;