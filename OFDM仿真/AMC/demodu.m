function [demodu_bit_symble]=demodu(Rx_serial_complex_symbols,bits,carrier_count,symbols_per_carrier)
% =======================将串行数据转换为二进制比特流===========================
complex_symbols=reshape(Rx_serial_complex_symbols,length(Rx_serial_complex_symbols),1);
% =========创建mapping矩阵，最多256行对应256QAM，2列对应实虚部，5层对应5种调制方式========================
d=1;
mapping=zeros(256,2,5);
for bit=2:2:8
    for j=1:2^(bit/2)
        for i=1+2^(bit/2)*(j-1):2^(bit/2)*j
            mapping(i,2,bit/2+1)=2*j-2^(bit/2)-1;
            mapping(i,1,bit/2+1)=2*(i-2^(bit/2)*(j-1))-2^(bit/2)-1;
        end
    end
end
complex_mapping=complex(mapping(:,1,:),mapping(:,2,:));
% =====================就近原则解码=============================
for i=1:length(Rx_serial_complex_symbols)
    for j=1:2^bits(ceil(i/symbols_per_carrier))
        metrics(j)=abs(complex_symbols(i,1)-complex_mapping(j,1,bits(ceil(i/symbols_per_carrier))/2+1));
    end
    [min_metric  decode_symble(i)]= min(metrics);  %将离某星座点最近的值赋给decode_symble(i)
    for j=1:256
        metrics(j)=inf;
    end
end
% ===================十进制转二进制=========================
sum_bits_per_symbol=0;
for i=1:carrier_count
    sum_bits_per_symbol=sum_bits_per_symbol + bits(i);%将bits累加，得数即为每个符号位的bit数
end
decode_bit_symble=zeros(1,sum_bits_per_symbol * symbols_per_carrier);
current_digit=1;
for i=1:length(Rx_serial_complex_symbols)
    if bits(ceil(i/symbols_per_carrier))==0%如果该个子载波没有携带信号，则跳过
        continue
    end
    temp=de2bi((decode_symble(i)-1),bits(ceil(i/symbols_per_carrier)),'left-msb');%将十进制码按每个子载波的调制方式解码
    for j=1:bits(ceil(i/symbols_per_carrier))
        decode_bit_symble(current_digit)=temp(j);
        current_digit=current_digit+1;%将得到的二进制码转为串行信号
    end
end
demodu_bit_symble=decode_bit_symble;