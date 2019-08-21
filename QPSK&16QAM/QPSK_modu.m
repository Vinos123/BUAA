function [complex_qam_data]=QPSK_modu(bitdata)
%modulation of QPSK,modulate bitdata to QPSK complex signal
X1=reshape(bitdata,2,length(bitdata)/2)';
d=1;%min distance of symble 
for i=1:length(bitdata)/2
    for j=1:2
        X1(i,j)=X1(i,j)*(2^(2-j));
    end
        source(i,1)=1+sum(X1(i,:));%convert to the number 1 to 4
end
mapping=[
	   -d  d;
	    d  d; 
	   -d  -d; 
	    d  -d;];
 for i=1:length(bitdata)/2
     qam_data(i,:)=mapping(source(i),:);%data mapping
 end
 complex_qam_data=complex(qam_data(:,1),qam_data(:,2));
