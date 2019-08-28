function [complex_qam_data]=modu(bitdata,bits,carrier_count,symbols_per_carrier)
% ==============������������bit_per_symbolѹ��======================
X1=zeros(carrier_count*symbols_per_carrier,8);%��ʼ������ÿһ������λ1�У�ÿ�����8bits
current_digit=1;
for i=1:carrier_count*symbols_per_carrier
    for j=1:bits(ceil(i/symbols_per_carrier))%ÿ�з���һ������λ�Ķ�������
        X1(i,j)=bitdata(current_digit);
        current_digit=current_digit+1;
    end
end
% ==================��ÿ�еĶ�����ת��Ϊʮ���ƣ�׼��mapping======================
d=1;%min distance of symble 
source=zeros(carrier_count*symbols_per_carrier,1);
for i=1:carrier_count*symbols_per_carrier
    for j=1:bits(ceil(i/symbols_per_carrier))
        X1(i,j)=X1(i,j)*(2^(bits(ceil(i/symbols_per_carrier))-j));
    end
    source(i,1)=1+sum(X1(i,:));%convert to the number 1 to bits
end
% =========����mapping�������256�ж�Ӧ256QAM��2�ж�Ӧʵ�鲿��5���Ӧ5�ֵ��Ʒ�ʽ========================
mapping=zeros(256,2,5);
for bit=2:2:8
    for j=1:2^(bit/2)
        for i=1+2^(bit/2)*(j-1):2^(bit/2)*j
            mapping(i,2,bit/2+1)=2*j-2^(bit/2)-1;
            mapping(i,1,bit/2+1)=2*(i-2^(bit/2)*(j-1))-2^(bit/2)-1;
        end
    end
end
% ======================����mapping������ж�Ӧ����ɱ���===================
 for i=1:carrier_count*symbols_per_carrier
     qam_data(i,:)=mapping(source(i),:,bits(ceil(i/symbols_per_carrier))/2+1);%data mapping
 end
 complex_qam_data=complex(qam_data(:,1),qam_data(:,2));
