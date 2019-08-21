function varargout = exp2(varargin)
% EXP2 MATLAB code for exp2.fig
%      EXP2, by itself, creates a new EXP2 or raises the existing
%      singleton*.
%
%      H = EXP2 returns the handle to a new EXP2 or the handle to
%      the existing singleton*.
%
%      EXP2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXP2.M with the given input arguments.
%
%      EXP2('Property','Value',...) creates a new EXP2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp2

% Last Modified by GUIDE v2.5 13-May-2019 21:09:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp2_OpeningFcn, ...
                   'gui_OutputFcn',  @exp2_OutputFcn, ...
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


% --- Executes just before exp2 is made visible.
function exp2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp2 (see VARARGIN)

% Choose default command line output for exp2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
B=imread('lena512.bmp');
axes(handles.axes1);
imshow(B);
title('原始Lena图像')

% UIWAIT makes exp2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exp2_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('lena512.bmp');
[x,y]=size(Pic);
N=x;
u=-N/2:(N/2-1);
v=u';
T=(str2double(get(handles.edit1,'string')));
a=(str2double(get(handles.edit2,'string')));
b=(str2double(get(handles.edit3,'string')));

SNR=200;%噪声信噪比
SNRR=10^(SNR/10);%线性信噪比
H=(T./(pi*(a*u+b*v)).*sin(pi*(a*u+b*v)).*exp(-1i*pi*(a*u+b*v)));
H((a*u+b*v)==0)=T;%运动降质模型传递函数
Pic_fft=fftshift(fft2(Pic));

Pic_af_h=Pic_fft.*H;%对图像进行运动降质
P_pic=mean(mean(Pic_af_h.*conj(Pic_af_h)));%计算降质后的功率
P_test=mean(Pic_af_h.*conj(Pic_af_h));
Pe=P_pic./SNRR;
Noise=0;%Pe.^(1/2)*randn(x,y);%生成噪声？降质函数对幅度的衰落太强，若计算降质前的功率，则信噪比要非常大才能回复

Pic_af_hn=Pic_af_h+Noise;%降质后的图像
Pic_a_h=real(ifft2(ifftshift(Pic_af_hn)));

Pic2show=uint8(mat2gray(Pic_a_h)*255);

kk=1;
rr=0.1:0.01:1;
H_inv=ones(x,y);
PSNR_inv=zeros(1,length(rr));
for r=0.1:0.01:1
    x_inv=round(x*r);
    y_inv=round(y*r);
    x_range=round((x-x_inv)/2+1):round(x+x_inv)/2;
    y_range=round((y-y_inv)/2+1):round(y+y_inv)/2;
    H_inv(x_range,y_range)=H(x_range,y_range);
    Pic_invf=Pic_af_hn./H_inv;%逆滤波处理
    Pic_a_inv=abs(ifft2(Pic_invf));
    Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);
    PSNR_inv(kk)=psnr(Pic2show_inv,Pic);
    kk=kk+1;
end
[PSNR_best,r_best_index]=max(PSNR_inv);
r_best=rr(r_best_index);

x_inv=round(x*r_best);
y_inv=round(y*r_best);

x_range=round((x-x_inv)/2+1):round(x+x_inv)/2;
y_range=round((y-y_inv)/2+1):round(y+y_inv)/2;
H_inv(x_range,y_range)=H(x_range,y_range);

Pic_invf=Pic_af_hn./H_inv;%逆滤波处理
Pic_a_inv=real(ifft2(ifftshift(Pic_invf)));
Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);

axes(handles.axes2);
imshow(Pic2show);
title('降质Lena图像');
axes(handles.axes3);
imshow(Pic2show_inv);
title('逆滤波恢复Lena图像')
PSNR_pic=psnr(Pic2show,Pic);
set(handles.text6,'Visible','on');
set(handles.edit5,'Visible','on');
set(handles.edit5,'string',num2str(PSNR_best));

set(handles.edit9,'Visible','on');
set(handles.edit9,'string','r');
set(handles.edit6,'Visible','on');
set(handles.edit6,'string',num2str(r_best));




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('lena512.bmp');
[x,y]=size(Pic);
N=x;
u=-N/2:(N/2-1);
v=u';
T=(str2double(get(handles.edit1,'string')));
a=(str2double(get(handles.edit2,'string')));
b=(str2double(get(handles.edit3,'string')));

set(handles.text5,'Visible','on');
set(handles.edit4,'Visible','on');
SNR=(str2double(get(handles.edit4,'string')));%噪声信噪比
SNRR=10^(SNR/10);%线性信噪比
H=(T./(pi*(a*u+b*v)).*sin(pi*(a*u+b*v)).*exp(-1i*pi*(a*u+b*v)));
H((a*u+b*v)==0)=T;%运动降质模型传递函数
Pic_fft=fftshift(fft2(Pic));

Pic_af_h=Pic_fft.*H;%对图像进行运动降质
P_pic=mean(mean(Pic_af_h.*conj(Pic_af_h)));%计算降质后的功率
P_test=mean(Pic_af_h.*conj(Pic_af_h));
Pe=P_pic./SNRR;
Noise=Pe.^(1/2)*randn(x,y);%生成噪声？降质函数对幅度的衰落太强，若计算降质前的功率，则信噪比要非常大才能回复

Pic_af_hn=Pic_af_h+Noise;%降质后的图像
Pic_a_h=abs(ifft2(ifftshift(Pic_af_hn)));

Pic2show=uint8(mat2gray(Pic_a_h)*255);


aa=1;
kk=0:0.01:1;
% H_inv=ones(x,y);
PSNR_inv=zeros(1,length(kk));
for k=0:0.01:1

    H_inv=conj(H)./(H.*conj(H)+k);
    Pic_invf=Pic_af_hn.*H_inv;%逆滤波处理
    Pic_a_inv=abs(ifft2(ifftshift(Pic_invf)));
    Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);
    PSNR_inv(aa)=psnr(Pic2show_inv,Pic);
    aa=aa+1;
end

[PSNR_best,k_best_index]=max(PSNR_inv);
k_best=kk(k_best_index);

H_inv=conj(H)./(H.*conj(H)+k_best);

Pic_invf=Pic_af_hn.*H_inv;%逆滤波处理
Pic_a_inv=abs(ifft2(ifftshift(Pic_invf)));
Pic2show_inv=uint8(mat2gray(Pic_a_inv)*255);


axes(handles.axes2);
imshow(Pic2show);
title('降质Lena图像');
axes(handles.axes3);
imshow(Pic2show_inv);
title('weina滤波恢复Lena图像')
PSNR_pic=psnr(Pic2show,Pic);

set(handles.text6,'Visible','on');
set(handles.edit5,'Visible','on');
set(handles.edit5,'string',num2str(PSNR_best));

set(handles.edit9,'Visible','on');
set(handles.edit9,'string','k');
set(handles.edit6,'Visible','on');
set(handles.edit6,'string',num2str(k_best));





function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
