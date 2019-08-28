function [complex_qam_data]=modu(bitdata,bits,carrier_count,symbols_per_carrier)
% ==============将二进制流按bit_per_symbol压缩======================
X1=zeros(carrier_count*symbols_per_carrier,8);%初始化矩阵，每一个符号位1行，每行最多8bits
current_digit=1;
for i=1:carrier_count*symbols_per_carrier
    for j=1:bits(ceil(i/symbols_per_carrier))%每行放置一个符号位的二进制码
        X1(i,j)=bitdata(current_digit);
        current_digit=current_digit+1;
    end
end
% ==================将每行的二进制转换为十进制，准备mapping======================
d=1;%min distance of symble 
source=zeros(carrier_count*symbols_per_carrier,1);
for i=1:carrier_count*symbols_per_carrier
    for j=1:bits(ceil(i/symbols_per_carrier))
        X1(i,j)=X1(i,j)*(2^(bits(ceil(i/symbols_per_carrier))-j));
    end
    source(i,1)=1+sum(X1(i,:));%convert to the number 1 to bits
end
% =========创建mapping矩阵，最多256行对应256QAM，2列对应实虚部，5层对应5种调制方式========================
mapping=zeros(256,2,5);
for bit=2:2:8
    for j=1:2^(bit/2)
        for i=1+2^(bit/2)*(j-1):2^(bit/2)*j
            mapping(i,2,bit/2+1)=2*j-2^(bit/2)-1;
            mapping(i,1,bit/2+1)=2*(i-2^(bit/2)*(j-1))-2^(bit/2)-1;
        end
    end
end
% ======================根据mapping矩阵进行对应，完成编码===================
 for i=1:carrier_count*symbols_per_carrier
     qam_data(i,:)=mapping(source(i),:,bits(ceil(i/symbols_per_carrier))/2+1);%data mapping
 end
 complex_qam_data=complex(qam_data(:,1),qam_data(:,2));
