function [demodu_bit_symble]=demodu(Rx_serial_complex_symbols,bits,carrier_count,symbols_per_carrier)
% =======================����������ת��Ϊ�����Ʊ�����===========================
complex_symbols=reshape(Rx_serial_complex_symbols,length(Rx_serial_complex_symbols),1);
% =========����mapping�������256�ж�Ӧ256QAM��2�ж�Ӧʵ�鲿��5���Ӧ5�ֵ��Ʒ�ʽ========================
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
% =====================�ͽ�ԭ�����=============================
for i=1:length(Rx_serial_complex_symbols)
    for j=1:2^bits(ceil(i/symbols_per_carrier))
        metrics(j)=abs(complex_symbols(i,1)-complex_mapping(j,1,bits(ceil(i/symbols_per_carrier))/2+1));
    end
    [min_metric  decode_symble(i)]= min(metrics);  %����ĳ�����������ֵ����decode_symble(i)
    for j=1:256
        metrics(j)=inf;
    end
end
% ===================ʮ����ת������=========================
sum_bits_per_symbol=0;
for i=1:carrier_count
    sum_bits_per_symbol=sum_bits_per_symbol + bits(i);%��bits�ۼӣ�������Ϊÿ������λ��bit��
end
decode_bit_symble=zeros(1,sum_bits_per_symbol * symbols_per_carrier);
current_digit=1;
for i=1:length(Rx_serial_complex_symbols)
    if bits(ceil(i/symbols_per_carrier))==0%����ø����ز�û��Я���źţ�������
        continue
    end
    temp=de2bi((decode_symble(i)-1),bits(ceil(i/symbols_per_carrier)),'left-msb');%��ʮ�����밴ÿ�����ز��ĵ��Ʒ�ʽ����
    for j=1:bits(ceil(i/symbols_per_carrier))
        decode_bit_symble(current_digit)=temp(j);
        current_digit=current_digit+1;%���õ��Ķ�������תΪ�����ź�
    end
end
demodu_bit_symble=decode_bit_symble;