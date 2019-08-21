function [demodu_bit_symble]=QAM16_demodu(Rx_serial_complex_symbols)
%���õ��Ĵ���16QAM���ݽ���ɶ����Ʊ�����
complex_symbols=reshape(Rx_serial_complex_symbols,length(Rx_serial_complex_symbols),1);
d=1;
mapping=[-3*d 3*d;
	   -d  3*d;
        d  3*d;
	  3*d  3*d;
	 -3*d  d;
	   -d  d;
	    d  d;
	  3*d  d;
 	 -3*d  -d; 
	   -d  -d; 
	    d  -d;
      3*d  -d;
	 -3*d  -3*d;
	   -d  -3*d;
	    d  -3*d;
	  3*d  -3*d];
  complex_mapping=complex(mapping(:,1),mapping(:,2));
  for i=1:length(Rx_serial_complex_symbols)
      for j=1:16
          metrics(j)=abs(complex_symbols(i,1)-complex_mapping(j,1));
      end
      [min_metric  decode_symble(i)]= min(metrics) ;  %����ĳ�����������ֵ����decode_symble(i)
  end
  
  decode_bit_symble=de2bi((decode_symble-1)','left-msb');
  demodu_bit_symble=reshape(decode_bit_symble',1,length(Rx_serial_complex_symbols)*4);