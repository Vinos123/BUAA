function [S_decode]=decode_F(N,V,S_code)
%%%%%%%%%%%%%%%%%%%��������λ��N,������ΧV,������ź�S_code%%%%%%%%%%%%%%%%%%%%
Delta_V=2*V/2^N;
S_index=find(~(S_code(:,N)));%�ҵ���Ȼ�����λΪ0������
S_code(S_index,1:(N-1))=~S_code(S_index,1:(N-1));%�����λ����ȡ���õ���Ӧ����Ȼ��
S_decode=bi2de(S_code).*Delta_V+(-V)+Delta_V/2;%�ָ���ƽ