function [S_out]=code_F(N,V,S_in)
%%%%%%%%%%%%%��������λ��N,������ΧV,�����ź�S_in%%%%%%%%%%%
Delta_V=2*V/2^N;
[x y]=size(S_in);
S_Sq=S_in.*(S_in < 1 & S_in > -1)+0.9999.*(S_in >=1)+(-0.9999).*(S_in <= -1);
S_temp=floor((S_Sq-(-V))./Delta_V);
S_vec=reshape(S_temp',x*y,1);
S_out_D=de2bi(S_vec);%��Ȼ�����
S_index=find(~(S_out_D(:,N)));%�ҵ���Ȼ�����λΪ0������
S_out_D(S_index,1:(N-1))=~S_out_D(S_index,1:(N-1));%�����λ����ȡ�����õ��۵��롣
S_out=S_out_D;

