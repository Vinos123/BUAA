function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 17-Oct-2018 01:49:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
edit1 = str2double(get(hObject, 'String'));
handles.symbols_per_carrier = edit1;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit1 = str2double(get(hObject, 'String'));
handles.symbols_per_carrier = edit1;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
edit2 = str2double(get(hObject, 'String'));
handles.PrefixRatio = edit2;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit2 = str2double(get(hObject, 'String'));
handles.PrefixRatio = edit2;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
edit3 = str2double(get(hObject, 'String'));
handles.beta = edit3;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit3 = str2double(get(hObject, 'String'));
handles.beta = edit3;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
edit4 = str2double(get(hObject, 'String'));
handles.SNR = edit4;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit4 = str2double(get(hObject, 'String'));
handles.SNR = edit4;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
edit5 = str2double(get(hObject, 'String'));
handles.L = edit5;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit5 = str2double(get(hObject, 'String'));
handles.L = edit5;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%function [BER]=OFDM_16QAM(L,SNR,PrefixRatio)
% global complex_carrier_matrix;
% global Rx_phase;
% global Rx_mag;
% global Rx_complex_carrier_matrix;
clearvars -except handles hObject;
cla reset ;%删除之前的图像
handles.QPSK=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
symbols_per_carrier=7;
carrier_count=1024;%子载波数
L=handles.L;
SNR=handles.SNR;
PrefixRatio=handles.PrefixRatio / handles.PrefixRatio_;
bits_per_symbol=4;
%=====================图像处理====================
Pic=imread('G:\gui\IMG_7905.JPG');%图片读入为矩阵
[x,y,z]=size(Pic);%读取图片矩阵的大小
% Pic_1=reshape(Pic,x*y*z,1);
%每次发送多少个OFDM符号
C_1=de2bi(Pic);%将十进制矩阵转为二进制
[m,n]=size(C_1);%读取矩阵的大小
bit_stream_before=reshape(C_1,m*n,1);
bit_stream(1:m*n)=bit_stream_before;
num_symbol=symbols_per_carrier*carrier_count*bits_per_symbol;
%=====================传入================
times=ceil(length(bit_stream)/num_symbol);
sum_BER=0;
BER=zeros(1,times);
for ii=1:times-1
    in_bit_stream=bit_stream((1+(ii-1)*num_symbol):ii*num_symbol);
    [BER(ii),receive_stream((1+(ii-1)*num_symbol):ii*num_symbol),...
        Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp,complex_carrier_matrix_temp]=...
        QAM16(L,SNR,PrefixRatio,in_bit_stream,symbols_per_carrier);%传入各个参数
    if ii<2
        Rx_real=Rx_real_temp;
        Rx_imag=Rx_imag_temp;
        Rx_real_before=Rx_real_before_temp;
        Rx_imag_before=Rx_imag_before_temp;
        complex_carrier_matrix=complex_carrier_matrix_temp;%为星座图参量赋初值
    elseif ii<50
        Rx_real=cat(1,Rx_real,Rx_real_temp);
        Rx_imag=cat(1,Rx_imag,Rx_imag_temp);
        Rx_real_before=cat(1,Rx_real_before,Rx_real_before_temp);
        Rx_imag_before=cat(1,Rx_imag_before,Rx_imag_before_temp);
        complex_carrier_matrix=cat(1,complex_carrier_matrix,complex_carrier_matrix_temp);%不同帧得到的矩阵进行拼接；
    end
    sum_BER=sum_BER+BER(ii)*(num_symbol);
end      
ii=times;
last_bit_stream=bit_stream((1+(ii-1)*num_symbol):end);
[BER(ii),receive_stream((1+(ii-1)*num_symbol):((1+(ii-1)*num_symbol)+length(last_bit_stream)-1)),...
    Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp]=...
    QAM16(L,SNR,PrefixRatio,last_bit_stream,symbols_per_carrier);
axes(handles.axes1);
handles.complex_carrier_matrix=complex_carrier_matrix;
plot(complex_carrier_matrix,'*r');%QAM16调制后星座图
% title('16QAM调制后星座图')
axis([-3, 3, -3, 3]);
grid on
%================原始图片============================================
axes(handles.axes2);
imshow('G:\gui\IMG_7905.JPG');
%================还原图片============================================
axes(handles.axes3);
Pic_out_test=reshape(receive_stream,length(bit_stream_before)/8,8);
Pic_out_stream=bi2de(Pic_out_test);
Pic_out=reshape(Pic_out_stream,x,y,z);
Pic_result=uint8(Pic_out);
imwrite(Pic_result,'G:\gui\result.jpg');
imshow('G:\gui\result.jpg');
[M, N]=pol2cart(Rx_real, Rx_imag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_real_before, Rx_imag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
axes(handles.axes4);
handles.before=Rx_complex_carrier_matrix_before;
plot(Rx_complex_carrier_matrix_before,'*r');%XY坐标接收信号的星座图
% title('XY坐标接收信号的星座图-频域均衡前')
axis([-4, 4, -4, 4]);
grid on
axes(handles.axes5);
handles.after=Rx_complex_carrier_matrix;
plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
% title('XY坐标接收信号的星座图-频域均衡后')
axis([-4, 4, -4, 4]);
grid on
sum_BER=sum_BER+BER(ii)*length(last_bit_stream);
BER=sum_BER/length(bit_stream);
set(handles.text16,'string',num2str(BER));
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% handles.QPSK=0;
% carrier_count=1024;%子载波数
% %symbols_per_carrier=handles.symbols_per_carrier;%每次发送多少个OFDM符号
% bits_per_symbol=4;%每符号含比特数,16QAM调制
% IFFT_bin_length=4096;%FFT点数
% PrefixRatio=handles.PrefixRatio / handles.PrefixRatio_;%保护间隔与OFDM数据的比例 1/4
% GI=PrefixRatio*IFFT_bin_length ;%每一个OFDM符号添加的循环前缀长度为1/4*IFFT_bin_length  即保护间隔长度为512
% beta=handles.beta / handles.beta_;%窗函数滚降系数
% GIP=beta*(IFFT_bin_length+GI);%循环后缀的长度80
% SNR=handles.SNR; %信噪比dB
% L=handles.L;%多径信道数量
% W=20e6;%带宽20MHz
% T=1/15000/(IFFT_bin_length+GI);%每一个点数的时间
% %==================================================
% %=====================图像处理====================
% Pic=imread('G:\gui\IMG_7905.JPG');%图片读入为矩阵
% [x,y,z]=size(Pic);%读取图片矩阵的大小
% % Pic_1=reshape(Pic,x*y*z,1);
% 
% symbols_per_carrier=200;%每次发送多少个OFDM符号
% 
% bit_stream=zeros(carrier_count * symbols_per_carrier * bits_per_symbol,1);%初始化比特流向量
% C_1=de2bi(Pic);%将十进制矩阵转为二进制
% [m,n]=size(C_1);%读取矩阵的大小
% bit_stream_before=reshape(C_1,m*n,1);
% bit_stream(1:m*n)=bit_stream_before;
% 
% %==================================================
% %================信号产生===================================
% %所输入的比特数目
% baseband_out_length_nonpilot=carrier_count*symbols_per_carrier*bits_per_symbol;
% %================生成导频=============
% pilot_length=carrier_count*bits_per_symbol;
% baseband_out_pilot=round(rand(1,pilot_length));%输出待调制的二进制比特流，产生随机数0、1,作为导频；
% baseband_out_length = baseband_out_length_nonpilot+pilot_length;
% %================输入图像的二进制比特流======================================
% baseband_out(1:baseband_out_length_nonpilot)=(bit_stream)';
% baseband_out(baseband_out_length_nonpilot+1:baseband_out_length)=baseband_out_pilot;
% baseband_out_nonpilot=(bit_stream)';
% 
% carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% 共轭对称子载波映射  复数数据对应的IFFT点坐标
% conjugate_carriers = IFFT_bin_length - carriers + 2;%共轭对称子载波映射  共轭复数对应的IFFT点坐标
% 
% %==============16QAM调制====================================
% complex_carrier_matrix=qam16(baseband_out);%列向量，将0、1->0-16->-3，-1，1，3->复数（1024*2）
% complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier+1)';%12*1024（子载波符号数*子载波数）矩阵
% % figure(1);
% handles.complex_carrier_matrix=complex_carrier_matrix;
% axes(handles.axes1);
% plot(complex_carrier_matrix,'*r');%16QAM调制后星座图
% % title('16QAM调制后星座图')
% axis([-4, 4, -4, 4]);
% grid on
% %=================IFFT===========================
% IFFT_modulation=zeros(symbols_per_carrier+1,IFFT_bin_length);%添0组成IFFT_bin_length IFFT 运算 (12*2048)
% IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%未添加导频信号 ，子载波映射在此处（0，1024）传正频率部分
% IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%共轭复数映射，（-1024，0）传负频率部分
% %=================================================================
% signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM调制 即二维IFFT变换，得到（12*2048）
% time_wave_matrix =signal_after_IFFT;%时域波形矩阵，行为每载波所含符号数，列IFFT点数，1024个子载波映射在其内，每一行即为一个OFDM符号
% %===========================================================
% %=====================添加循环前缀与后缀====================================
% XX=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%（12*2048+前缀512+后缀80）
% for k=1:symbols_per_carrier+1 %（1；12）
%     for i=1:IFFT_bin_length %（1；2048）
%         XX(k,i+GI)=signal_after_IFFT(k,i); %挪出前缀的位置 xx（k,i+512)=signal(k,i)
%     end
%     for i=1:GI
%         XX(k,i)=signal_after_IFFT(k,i+IFFT_bin_length-GI);%添加循环前缀 xx(k,i)=signal(k,i+2048-512) 后面的部分做前缀
%     end
%     for j=1:GIP %(1:40)
%         XX(k,IFFT_bin_length+GI+j)=signal_after_IFFT(k,j);%添加循环后缀 xx(k,j+2048+512)=signal(k,j) 前面的部分做后缀
%     end
% end
% 
% time_wave_matrix_cp=XX;%添加了循环前缀与后缀的时域信号矩阵,此时一个OFDM符号长度为IFFT_bin_length+GI+GIP=2048+512+80，矩阵（12*2640）
% %==============OFDM符号加窗==========================================
% windowed_time_wave_matrix_cp=zeros(1,IFFT_bin_length+GI+GIP);%（1，2640）
% for i = 1:symbols_per_carrier+1 %（1；12）
% windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%加窗  升余弦窗，矩阵（12*2640）
% end  
% %========================生成发送信号，并串变换==================================================
% %前缀与后缀相叠加
% windowed_Tx_data=zeros(1,((symbols_per_carrier+1)*(IFFT_bin_length+GI)+GIP));%（1*（12*（2048+512）+80））
% windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%第一行放在最前面
% for i = 1:symbols_per_carrier 
%     windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%并串转换，循环后缀与循环前缀相叠加
% end
% %其余行放在后面，后缀在12个symbol之后
% %=======================================================
% %=====================取出导频信号===============================
% windowed_Tx_data_pilot=windowed_Tx_data((end-(IFFT_bin_length+GI+GIP-1)):end);
% %前缀与后缀不叠加
% Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP),1)';%加窗后 循环前缀与后缀不叠加 的串行信号
% %=================================================================
% temp_time1 = (symbols_per_carrier+1)*(IFFT_bin_length+GI+GIP);%加窗后 循环前缀与后缀不叠加 发送总位数 12*2640
% % figure (2)
% % subplot(2,1,1);
% % plot(0:temp_time1-1,Tx_data );%循环前缀与后缀不叠加 发送的信号波形
% % grid on
% % ylabel('Amplitude (volts)')
% % xlabel('Time (samples)')
% % title('循环前后缀不叠加的OFDM Time Signal')
% % temp_time2 =symbols_per_carrier*(IFFT_bin_length+GI)+GIP; %相叠加 12*（2048+512）+80
% % subplot(2,1,2);
% % plot(0:temp_time2-1,windowed_Tx_data);%循环后缀与循环前缀相叠加 发送信号波形
% % grid on
% % ylabel('Amplitude (volts)')
% % xlabel('Time (samples)')
% % title('循环前后缀叠加的OFDM Time Signal')
% %===============加窗的发送信号频谱=================================
% symbols_per_average = ceil((symbols_per_carrier+1)/5);%符号数的1/5，3
% avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%点数，10行数据，10个符号 2640*3
% averages = floor(temp_time1/avg_temp_time); %4
% average_fft(1:avg_temp_time) = 0;%分成4段 （1：2640*3）
% for a = 0:(averages-1)
%     subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%利用循环前缀后缀未叠加的串行加窗信号计算频谱
%     subset_ofdm_f = abs(fft(subset_ofdm));%分段求频谱
%     average_fft = average_fft + (subset_ofdm_f/averages);%总共的数据分为5段，分段进行FFT，平均相加
% end
% average_fft_log = 20*log10(average_fft);
% % figure (3)
% % plot((0:(avg_temp_time-1))/avg_temp_time, average_fft_log)%归一化  0/avg_temp_time  :  (avg_temp_time-1)/avg_temp_time
% % hold on
% % plot(0:1/IFFT_bin_length:1, -35, 'rd')
% % grid on
% % axis([0 0.5 -40 max(average_fft_log)])
% % ylabel('Magnitude (dB)')
% % xlabel('Normalized Frequency (0.5 = fs/2)')
% % title('加窗的发送信号频谱')
% %====================添加噪声=================================
% Tx_signal_power = var(windowed_Tx_data);%发送信号功率
% linear_SNR=10^(SNR/10);%线性信噪比 
% noise_sigma=Tx_signal_power/linear_SNR;%噪声功率
% noise_scale_factor = sqrt(noise_sigma);%标准差sigma
% max_length=floor((L-1)/W/T)+1;
% noise=randn(1,((symbols_per_carrier+1)*(IFFT_bin_length+GI))+GIP+max_length-1)*noise_scale_factor;%产生正态分布噪声序列
% alr=zeros(1,L);
% ali=zeros(1,L);
% delta=zeros(1,max_length);
% windowed_ht_Tx_data=zeros(1,length(windowed_Tx_data)+max_length-1);
% %====================多径高斯信道=============================
% for j = 1:L
%     alr(:)=1/L.*randn(1,L);
%     ali(:)=1/L.*randn(1,L);
%     delta(1,floor((j-1)/W/T)+1)=alr(1,j)+ali(1,j)*i;
% end
% windowed_ht_Tx_data=conv(windowed_Tx_data,delta);
% %============导频通过信道===========================
% windowed_ht_pilot_data=conv(windowed_Tx_data_pilot,delta);
% %
% Rx_data=windowed_ht_Tx_data+noise;%接收到的信号加噪声
% % figure(3)
% % subplot(2,1,1);
% % plot(windowed_Tx_data);
% % subplot(2,1,2);
% % plot(windowed_ht_Tx_data);
% % subplot(2,2,1);
% % plot(noise);
% % subplot(2,2,2);
% % plot(Rx_data);
% %=====================接收信号  串并变换 去除前缀与后缀==========================================
% Rx_data_matrix=zeros(symbols_per_carrier+1,IFFT_bin_length+GI+GIP);%（12*2640）
% for i=1:symbols_per_carrier+1
%     Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%串并变换
% end
% Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%去除循环前缀与循环后缀，得到有用信号矩阵
% %Rx_pilot=Rx_data_matrix(symbols_per_carrier+1:GI+1:IFFT_bin_length+GI);
% %==============================================================
% %                      OFDM解码   16QAM解码
% %=================FFT变换=================================
% Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM解码 即FFT变换
% %=================导频的频域函数============================
% X_p=fft(windowed_Tx_data_pilot,IFFT_bin_length);
% Y_p=fft(windowed_ht_pilot_data,IFFT_bin_length);
% %=================LS信道估计================================
% Delta=Y_p./X_p;
% %=================MMSE频域均衡===============================
% W0=conj(Delta)./((abs(Delta)).^2+1/SNR);
% Y1=W0.*Y0;
% Rx_carriers=Y1(:,carriers);%除去IFFT/FFT变换添加的0，选出映射的子载波，实部的1024个信息，也即子载波携带的有用信息
% Rx_phase =angle(Rx_carriers);%接收信号的相位
% Rx_mag = abs(Rx_carriers);%接收信号的幅度
% 
% % figure(4);
% axes(handles.axes2);
% handles.Rx_phase=Rx_phase;
% handles.Rx_mag=Rx_mag;
% polar(Rx_phase, Rx_mag,'bd');%极坐标坐标下画出接收信号的星座图
% % title('极坐标下的接收信号的星座图')
% %======================================================================
% [M, N]=pol2cart(Rx_phase, Rx_mag); 
% Rx_complex_carrier_matrix = complex(M, N);
% % figure(5);
% axes(handles.axes3);
% handles.Rx_complex_carrier_matrix=Rx_complex_carrier_matrix;
% plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
% % title('XY坐标接收信号的星座图')
% axis([-4, 4, -4, 4]);
% grid on
% %====================16qam解调=======================================
% Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
% Rx_decoded_binary_symbols=demoduqam16(Rx_serial_complex_symbols);
% %============================================================
% baseband_in = Rx_decoded_binary_symbols;
% % figure(6);
% axes(handles.axes4);
% imshow('G:\gui\IMG_7905.JPG');
% axes(handles.axes5);
% %================误码率计算==========================================
% baseband_in_nonpilot=baseband_in(1:baseband_out_length_nonpilot);
% bit_errors=find(baseband_in_nonpilot ~=baseband_out_nonpilot);
% bit_error_count = size(bit_errors, 2);
% ber=bit_error_count/baseband_out_length_nonpilot;
% BER=ber;
% set(handles.text16,'string',num2str(BER));
% guidata(hObject,handles);
% %================还原图片============================================
% bit_stream_out=baseband_in_nonpilot(1:length(bit_stream_before));
% Pic_out_test=reshape(bit_stream_out,length(bit_stream_before)/8,8);
% Pic_out_stream=bi2de(Pic_out_test);
% Pic_out=reshape(Pic_out_stream,x,y,z);
% Pic_result=uint8(Pic_out);
% imwrite(Pic_result,'G:\gui\result.jpg');
% imshow('G:\gui\result.jpg');


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global complex_carrier_matrix;
figure(1);
plot(handles.complex_carrier_matrix,'*r');%调制后星座图
axis([-3, 3, -3, 3]);
if handles.QPSK
    title('QPSK-Constellation');
else
    title('16QAM-Constellation');
end
grid on;



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global Rx_phase;
% global Rx_mag;
figure(4);
imshow('G:\gui\IMG_7905.JPG');
title('Input Picture');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global Rx_complex_carrier_matrix;
figure(3);
imshow('G:\gui\result.jpg');
title('Output Picture');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(3);
subplot(2,1,1);
plot(handles.before,'*r');%XY坐标接收信号的星座图
title('Before')
if handles.QPSK
    axis([-2, 2, -2, 2]);
else
    axis([-4, 4, -4, 4]);
end
grid on
subplot(2,1,2);
plot(handles.after,'*r');%XY坐标接收信号的星座图
title('After')
if handles.QPSK
    axis([-2, 2, -2, 2]);
else
    axis([-4, 4, -4, 4]);
end
grid on


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearvars -except handles hObject;
cla reset;
handles.QPSK=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
symbols_per_carrier=7;
carrier_count=1024;%子载波数
L=handles.L;
SNR=handles.SNR;
PrefixRatio=handles.PrefixRatio / handles.PrefixRatio_;
bits_per_symbol=2;
%=====================图像处理====================
Pic=imread('G:\gui\IMG_7905.JPG');%图片读入为矩阵
[x,y,z]=size(Pic);%读取图片矩阵的大小
% Pic_1=reshape(Pic,x*y*z,1);
%每次发送多少个OFDM符号
C_1=de2bi(Pic);%将十进制矩阵转为二进制
[m,n]=size(C_1);%读取矩阵的大小
bit_stream_before=reshape(C_1,m*n,1);
bit_stream(1:m*n)=bit_stream_before;
num_symbol=symbols_per_carrier*carrier_count*bits_per_symbol;
%=====================传入================
times=ceil(length(bit_stream)/num_symbol);
sum_BER=0;
BER=zeros(1,times);
for ii=1:times-1
    in_bit_stream=bit_stream((1+(ii-1)*num_symbol):ii*num_symbol);
    [BER(ii),receive_stream((1+(ii-1)*num_symbol):ii*num_symbol),...
        Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp,complex_carrier_matrix_temp]=...
        QPSK(L,SNR,PrefixRatio,in_bit_stream,symbols_per_carrier);%传入各个参数
    if ii<2
        Rx_real=Rx_real_temp;
        Rx_imag=Rx_imag_temp;
        Rx_real_before=Rx_real_before_temp;
        Rx_imag_before=Rx_imag_before_temp;
        complex_carrier_matrix=complex_carrier_matrix_temp;%为星座图参量赋初值
    elseif ii<50
        Rx_real=cat(1,Rx_real,Rx_real_temp);
        Rx_imag=cat(1,Rx_imag,Rx_imag_temp);
        Rx_real_before=cat(1,Rx_real_before,Rx_real_before_temp);
        Rx_imag_before=cat(1,Rx_imag_before,Rx_imag_before_temp);
        complex_carrier_matrix=cat(1,complex_carrier_matrix,complex_carrier_matrix_temp);%不同帧得到的矩阵进行拼接；
    end
    sum_BER=sum_BER+BER(ii)*(num_symbol);
end      
ii=times;
last_bit_stream=bit_stream((1+(ii-1)*num_symbol):end);
[BER(ii),receive_stream((1+(ii-1)*num_symbol):((1+(ii-1)*num_symbol)+length(last_bit_stream)-1)),...
    Rx_real_temp,Rx_imag_temp,Rx_real_before_temp,Rx_imag_before_temp]=...
    QPSK(L,SNR,PrefixRatio,last_bit_stream,symbols_per_carrier);
axes(handles.axes1);
handles.complex_carrier_matrix=complex_carrier_matrix;
plot(complex_carrier_matrix,'*r');%QPSK调制后星座图
% title('QPSK调制后星座图')
axis([-3, 3, -3, 3]);
grid on
%================原始图片============================================
axes(handles.axes2);
imshow('G:\gui\IMG_7905.JPG');
%================还原图片============================================
axes(handles.axes3);
Pic_out_test=reshape(receive_stream,length(bit_stream_before)/8,8);
Pic_out_stream=bi2de(Pic_out_test);
Pic_out=reshape(Pic_out_stream,x,y,z);
Pic_result=uint8(Pic_out);
imwrite(Pic_result,'G:\gui\result.jpg');
imshow('G:\gui\result.jpg');
[M, N]=pol2cart(Rx_real, Rx_imag); 
Rx_complex_carrier_matrix = complex(M, N);
[M_b, N_b]=pol2cart(Rx_real_before, Rx_imag_before); 
Rx_complex_carrier_matrix_before = complex(M_b, N_b);
axes(handles.axes4);
handles.before=Rx_complex_carrier_matrix_before;
plot(Rx_complex_carrier_matrix_before,'*r');%XY坐标接收信号的星座图
% title('XY坐标接收信号的星座图-频域均衡前')
axis([-2, 2, -2, 2]);
grid on
axes(handles.axes5);
handles.after=Rx_complex_carrier_matrix;
plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
% title('XY坐标接收信号的星座图-频域均衡后')
axis([-2, 2, -2, 2]);
grid on
sum_BER=sum_BER+BER(ii)*length(last_bit_stream);
BER=sum_BER/length(bit_stream);
set(handles.text16,'string',num2str(BER));
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% carrier_count=1024;%子载波数
% symbols_per_carrier=handles.symbols_per_carrier;%每子载波含符号数
% bits_per_symbol=2;%每符号含比特数,QPSK调制
% IFFT_bin_length=4096;%FFT点数
% PrefixRatio=handles.PrefixRatio / handles.PrefixRatio_;%保护间隔与OFDM数据的比例 1/4
% GI=PrefixRatio*IFFT_bin_length ;%每一个OFDM符号添加的循环前缀长度为1/4*IFFT_bin_length  即保护间隔长度为512
% beta=handles.beta / handles.beta_;%窗函数滚降系数
% GIP=beta*(IFFT_bin_length+GI);%循环后缀的长度80
% SNR=handles.SNR; %信噪比dB
% L=handles.L;%多径信道数量
% W=20e6;%带宽20MHz
% T=1/15000/(IFFT_bin_length+GI);%每一个点数的时间
% %==================================================
% %================信号产生===================================
% baseband_out_length = carrier_count * symbols_per_carrier * bits_per_symbol;%所输入的比特数目
% carriers = (1:carrier_count) + (floor(IFFT_bin_length/4) - floor(carrier_count/2));% 共轭对称子载波映射  复数数据对应的IFFT点坐标
% conjugate_carriers = IFFT_bin_length - carriers + 2;%共轭对称子载波映射  共轭复数对应的IFFT点坐标
% baseband_out=round(rand(1,baseband_out_length));%输出待调制的二进制比特流，产生随机数0、1
% %==============QPSK调制====================================
% complex_carrier_matrix=qpsk(baseband_out);%列向量，将0、1->0-4->-1，1->复数（1024*2）
% complex_carrier_matrix=reshape(complex_carrier_matrix',carrier_count,symbols_per_carrier)';%12*1024（子载波符号数*子载波数）矩阵
% % figure(1);
% handles.complex_carrier_matrix=complex_carrier_matrix;
% axes(handles.axes1);
% plot(complex_carrier_matrix,'*r');%QPSK调制后星座图
% % title('QPSK调制后星座图')
% axis([-3, 3, -3, 3]);
% grid on
% %=================IFFT===========================
% IFFT_modulation=zeros(symbols_per_carrier,IFFT_bin_length);%添0组成IFFT_bin_length IFFT 运算 (12*2048)
% IFFT_modulation(:,carriers ) = complex_carrier_matrix ;%未添加导频信号 ，子载波映射在此处（0，1024）传正频率部分
% IFFT_modulation(:,conjugate_carriers ) = conj(complex_carrier_matrix);%共轭复数映射，（-1024，0）传负频率部分
% %=================================================================
% signal_after_IFFT=ifft(IFFT_modulation,IFFT_bin_length,2);%OFDM调制 即二维IFFT变换，得到（12*2048）
% time_wave_matrix =signal_after_IFFT;%时域波形矩阵，行为每载波所含符号数，列IFFT点数，1024个子载波映射在其内，每一行即为一个OFDM符号
% %===========================================================
% %=====================添加循环前缀与后缀====================================
% XX=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%（12*2048+前缀512+后缀80）
% for k=1:symbols_per_carrier %（1；12）
%     for i=1:IFFT_bin_length %（1；2048）
%         XX(k,i+GI)=signal_after_IFFT(k,i); %挪出前缀的位置 xx（k,i+512)=signal(k,i)
%     end
%     for i=1:GI
%         XX(k,i)=signal_after_IFFT(k,i+IFFT_bin_length-GI);%添加循环前缀 xx(k,i)=signal(k,i+2048-512) 后面的部分做前缀
%     end
%     for j=1:GIP %(1:40)
%         XX(k,IFFT_bin_length+GI+j)=signal_after_IFFT(k,j);%添加循环后缀 xx(k,j+2048+512)=signal(k,j) 前面的部分做后缀
%     end
% end
% 
% time_wave_matrix_cp=XX;%添加了循环前缀与后缀的时域信号矩阵,此时一个OFDM符号长度为IFFT_bin_length+GI+GIP=2048+512+80，矩阵（12*2640）
% %==============OFDM符号加窗==========================================
% windowed_time_wave_matrix_cp=zeros(1,IFFT_bin_length+GI+GIP);%（1，2640）
% for i = 1:symbols_per_carrier %（1；12）
% windowed_time_wave_matrix_cp(i,:) = real(time_wave_matrix_cp(i,:)).*rcoswindow(beta,IFFT_bin_length+GI)';%加窗  升余弦窗，矩阵（12*2640）
% end  
% %========================生成发送信号，并串变换==================================================
% %前缀与后缀相叠加
% windowed_Tx_data=zeros(1,symbols_per_carrier*(IFFT_bin_length+GI)+GIP);%（1*（12*（2048+512）+80））
% windowed_Tx_data(1:IFFT_bin_length+GI+GIP)=windowed_time_wave_matrix_cp(1,:);%第一行放在最前面
% for i = 1:symbols_per_carrier-1 
%     windowed_Tx_data((IFFT_bin_length+GI)*i+1:(IFFT_bin_length+GI)*(i+1)+GIP)=windowed_time_wave_matrix_cp(i+1,:);%并串转换，循环后缀与循环前缀相叠加
% end
% %其余行放在后面，后缀在12个symbol之后
% %=======================================================
% %前缀与后缀不叠加
% Tx_data=reshape(windowed_time_wave_matrix_cp',(symbols_per_carrier)*(IFFT_bin_length+GI+GIP),1)';%加窗后 循环前缀与后缀不叠加 的串行信号
% %=================================================================
% temp_time1 = (symbols_per_carrier)*(IFFT_bin_length+GI+GIP);%加窗后 循环前缀与后缀不叠加 发送总位数 12*2640
% % figure (2)
% % subplot(2,1,1);
% % plot(0:temp_time1-1,Tx_data );%循环前缀与后缀不叠加 发送的信号波形
% % grid on
% % ylabel('Amplitude (volts)')
% % xlabel('Time (samples)')
% % title('循环前后缀不叠加的OFDM Time Signal')
% % temp_time2 =symbols_per_carrier*(IFFT_bin_length+GI)+GIP; %相叠加 12*（2048+512）+80
% % subplot(2,1,2);
% % plot(0:temp_time2-1,windowed_Tx_data);%循环后缀与循环前缀相叠加 发送信号波形
% % grid on
% % ylabel('Amplitude (volts)')
% % xlabel('Time (samples)')
% % title('循环前后缀叠加的OFDM Time Signal')
% %===============加窗的发送信号频谱=================================
% symbols_per_average = ceil(symbols_per_carrier/5);%符号数的1/5，3
% avg_temp_time = (IFFT_bin_length+GI+GIP)*symbols_per_average;%点数，10行数据，10个符号 2640*3
% averages = floor(temp_time1/avg_temp_time); %4
% average_fft(1:avg_temp_time) = 0;%分成4段 （1：2640*3）
% for a = 0:(averages-1)
%  subset_ofdm = Tx_data(((a*avg_temp_time)+1):((a+1)*avg_temp_time));%利用循环前缀后缀未叠加的串行加窗信号计算频谱
%  subset_ofdm_f = abs(fft(subset_ofdm));%分段求频谱
%  average_fft = average_fft + (subset_ofdm_f/averages);%总共的数据分为5段，分段进行FFT，平均相加
% end
% average_fft_log = 20*log10(average_fft);
% % figure (3)
% % subplot(2,1,2)
% % plot((0:(avg_temp_time-1))/avg_temp_time, average_fft_log)%归一化  0/avg_temp_time  :  (avg_temp_time-1)/avg_temp_time
% % hold on
% % plot(0:1/IFFT_bin_length:1, -35, 'rd')
% % grid on
% % axis([0 0.5 -40 max(average_fft_log)])
% % ylabel('Magnitude (dB)')
% % xlabel('Normalized Frequency (0.5 = fs/2)')
% % title('加窗的发送信号频谱')
% %====================添加噪声=================================
% Tx_signal_power = var(windowed_Tx_data);%发送信号功率
% linear_SNR=10^(SNR/10);%线性信噪比 
% noise_sigma=Tx_signal_power/linear_SNR;%噪声功率
% noise_scale_factor = sqrt(noise_sigma);%标准差sigma
% max_length=floor((L-1)/W/T)+1;
% noise=randn(1,((symbols_per_carrier)*(IFFT_bin_length+GI))+GIP+max_length-1)*noise_scale_factor;%产生正态分布噪声序列
% alr=zeros(1,L);
% ali=zeros(1,L);
% delta=zeros(1,max_length);
% windowed_ht_Tx_data=zeros(1,length(windowed_Tx_data)+max_length-1);
% for j = 1:L
%     alr(:)=1/L.*randn(1,L);
%     ali(:)=1/L.*randn(1,L);
%     delta(1,floor((j-1)/W/T)+1)=alr(1,j)+ali(1,j)*i;
% end
% windowed_ht_Tx_data=conv(windowed_Tx_data,delta);
% Rx_data=windowed_ht_Tx_data+noise;%接收到的信号加噪声
% %=====================接收信号  串/并变换 去除前缀与后缀==========================================
% Rx_data_matrix=zeros(symbols_per_carrier,IFFT_bin_length+GI+GIP);%（12*2640）
% for i=1:symbols_per_carrier
%     Rx_data_matrix(i,:)=Rx_data(1,(i-1)*(IFFT_bin_length+GI)+1:i*(IFFT_bin_length+GI)+GIP);%串并变换
% end
% Rx_data_complex_matrix=Rx_data_matrix(:,GI+1:IFFT_bin_length+GI);%去除循环前缀与循环后缀，得到有用信号矩阵
% %==============================================================
% %                      OFDM解码   QPSK解码
% %=================FFT变换=================================
% Y0=fft(Rx_data_complex_matrix,IFFT_bin_length,2);%OFDM解码 即FFT变换
% %=================MMSE频域均衡===============================
% Delta=fft(delta,length(Y0));
% W=conj(Delta)./((abs(Delta)).^2+1/SNR);
% Y1=W.*Y0;
% Rx_carriers=Y1(:,carriers);%除去IFFT/FFT变换添加的0，选出映射的子载波，实部的1024个信息，也即子载波携带的有用信息
% Rx_phase =angle(Rx_carriers);%接收信号的相位
% Rx_mag = abs(Rx_carriers);%接收信号的幅度
% % figure(4);
% axes(handles.axes2);
% handles.Rx_phase=Rx_phase;
% handles.Rx_mag=Rx_mag;
% polar(Rx_phase, Rx_mag,'bd');%极坐标坐标下画出接收信号的星座图
% % title('极坐标下的接收信号的星座图')
% %======================================================================
% [M, N]=pol2cart(Rx_phase, Rx_mag); 
% Rx_complex_carrier_matrix = complex(M, N);
% % figure(5);
% axes(handles.axes3);
% handles.Rx_complex_carrier_matrix=Rx_complex_carrier_matrix;
% plot(Rx_complex_carrier_matrix,'*r');%XY坐标接收信号的星座图
% % title('XY坐标接收信号的星座图')
% axis([-1, 1, -1, 1]);
% grid on
% %====================QPSK解调=======================================
% Rx_serial_complex_symbols=reshape(Rx_complex_carrier_matrix',size(Rx_complex_carrier_matrix, 1)*size(Rx_complex_carrier_matrix,2),1)' ;
% Rx_decoded_binary_symbols=demoduqpsk(Rx_serial_complex_symbols);
% %============================================================
% baseband_in = Rx_decoded_binary_symbols;
% % figure(6);
% % subplot(2,1,1);
% axes(handles.axes4);
% handles.out=baseband_out(1:100);
% stem(baseband_out(1:100));
% % title('输出待调制的二进制比特流')
% % subplot(2,1,2);
% axes(handles.axes5);
% handles.in=baseband_in(1:100);
% stem(baseband_in(1:100));
% % title('接收解调后的二进制比特流')
% %================误码率计算==========================================
% bit_errors=find(baseband_in ~=baseband_out);
% bit_error_count = size(bit_errors, 2);
% ber=bit_error_count/baseband_out_length;
% BER=ber;
% % handles.ber=BER;
% set(handles.text16,'string',num2str(BER));
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
edit8 = str2double(get(hObject, 'String'));
handles.PrefixRatio_ = edit8;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit8 = str2double(get(hObject, 'String'));
handles.PrefixRatio_ = edit8;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
edit9 = str2double(get(hObject, 'String'));
handles.beta_ = edit9;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit9 = str2double(get(hObject, 'String'));
handles.beta_ = edit9;
guidata(hObject,handles);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text16.
function text16_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
