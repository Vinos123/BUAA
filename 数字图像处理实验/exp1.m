function varargout = exp1(varargin)
% EXP1 MATLAB code for exp1.fig
%      EXP1, by itself, creates a new EXP1 or raises the existing
%      singleton*.
%
%      H = EXP1 returns the handle to a new EXP1 or the handle to
%      the existing singleton*.
%
%      EXP1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXP1.M with the given input arguments.
%
%      EXP1('Property','Value',...) creates a new EXP1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp1

% Last Modified by GUIDE v2.5 03-May-2019 14:21:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp1_OpeningFcn, ...
                   'gui_OutputFcn',  @exp1_OutputFcn, ...
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


% --- Executes just before exp1 is made visible.
function exp1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp1 (see VARARGIN)

% Choose default command line output for exp1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exp1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exp1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('lena512.bmp');
%imshow(Pic);
%%%%%%%%%��ɢ����Ҷ�任%%%%%%%%%%%%%%%%%%%%%%
Pic_fft2_original=fft2(Pic);
Pic_fft2_original_ab=abs(Pic_fft2_original);
Pic_fft2=fftshift(fft2(Pic));
Pic_fft2_ab=(abs(Pic_fft2));%��ͼ��Ԫ��ģֵȡ����

%%%%��ͼ���ֵӳ�䵽0��255%%%%%%%%%
Pic_frange_fft2=max(max(Pic_fft2_ab))-min(min(Pic_fft2_ab));%ͼ��仯�ķ�Χ
Pic_fft2_abnorm=(Pic_fft2_ab-min(min(Pic_fft2_ab)))/Pic_frange_fft2*255;

%%%%%%%%%%%��ϵ������Ԫ������%%%%%%%%%%%
[x y]=size(Pic);
Pic_fft2_cl=reshape(Pic_fft2_ab,x*y,1);%��ϵ�������Ϊ������
[Pic_fft2_sort index]=sort(Pic_fft2_cl);%�õ����������ϵ������
% index2zero=index(1:round(x*y*0.95));
% index2keep=index((round(x*y*0.95)+1):x*y);
%%%%%%%%%%������ֵ����95%��Сֵ����%%%%%%%%%%%
Thre=Pic_fft2_sort(round(x*y*0.95));
Pic_fft2_abzero=Pic_fft2_original.*(Pic_fft2_original_ab < Thre).*0+...
    Pic_fft2_original.*(Pic_fft2_original_ab >= Thre);
Pic_ifft2=ifft2(Pic_fft2_abzero);
Pic2show=uint8(round(Pic_ifft2));
axes(handles.axes3);
imshow(Pic_fft2_abnorm);%��ʾ��һ��֮���Ƶ��
title('��ά��ɢ����Ҷ�任Ƶ��')
axes(handles.axes4);
imshow(Pic2show);
title('��ԭͼ��');
PSNR_fft2=psnr(Pic,Pic2show);
set(handles.edit3,'string',num2str(PSNR_fft2));
handles.Pic1=Pic_fft2_abnorm;
handles.Pic2=Pic2show;
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('lena512.bmp');
%%%%%%%%%��ɢ���ұ任%%%%%%%%%%%%%%%%%%%%%%%
Pic_dct2=dct2(Pic);
Pic_dct2_ab=abs(Pic_dct2);
%%%%%%%%%��ͼ��Ԫ�ص�ȡֵ��Χӳ�䵽0��255
Pic_frange_dct2=max(max(Pic_dct2_ab))-min(min(Pic_dct2_ab));
Pic_dct2_abnorm=(Pic_dct2_ab-min(min(Pic_dct2_ab)))/Pic_frange_dct2*255;

%%%%%%%%��ϵ������Ԫ������%%%%%%%%%%%%%%
[x1 y1]=size(Pic);
Pic_dct2_cl=reshape(Pic_dct2_ab,x1*y1,1);
[Pic_dct2_sorted index]=sort(Pic_dct2_cl);
%%%%%%%%����ֵ����95%Сֵ����%%%%%%%%%%%
Thre=Pic_dct2_sorted(round(x1*y1*0.95));
Pic_dct2_zero=Pic_dct2.*( Pic_dct2_ab < Thre).*0+Pic_dct2.*(Pic_dct2_ab>=Thre);
Pic_idct2=idct2(Pic_dct2_zero);
Pic2show=uint8(round(Pic_idct2));
axes(handles.axes3);
imshow(Pic_dct2_abnorm);
title('��ɢ���ұ任Ƶ��');
axes(handles.axes4);
imshow(Pic2show);
title('��ԭͼ��');
psnr_dct2=psnr(Pic2show,Pic);
set(handles.edit3,'string',num2str(psnr_dct2));
handles.Pic1=Pic_dct2_abnorm;
handles.Pic2=Pic2show;
guidata(hObject,handles);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('lena512.bmp');
[x2 y2]=size(Pic);
H=hadamard(x2);
Pic_dht2=1/(x2)*H*double(Pic)*H';
% imshow(Pic_dht2);
Pic_dht2_ab=abs(Pic_dht2);
%%%%%%%%%ӳ�䵽0��255%%%%%%%%%%%%
Pic_frange_dht=max(max(Pic_dht2_ab)-min(min(Pic_dht2_ab)));
Pic_abnorm=(Pic_dht2_ab-min(min(Pic_dht2_ab)))/Pic_frange_dht*255;

%%%%%%%����Ԫ������%%%%%%%%%%%%%%%
Pic_dht2_cl=reshape(Pic_dht2_ab,x2*y2,1);
[Pic_dht2_sorted index]=sort(Pic_dht2_cl);
Thre=Pic_dht2_sorted(round(x2*y2*0.95));
Pic_dht2_zero=Pic_dht2.*(Pic_dht2_ab < Thre).*0+Pic_dht2.*(Pic_dht2_ab >= Thre);
Pic_idht2=1/(y2)*H*Pic_dht2_zero*H';
Pic2show=uint8(round(Pic_idht2));
axes(handles.axes3);
imshow(Pic_abnorm);
title('��ɢ������任Ƶ��');
axes(handles.axes4);
imshow(Pic2show);
title('��ԭͼ��');
psnr_hadamard=psnr(Pic2show,Pic);
set(handles.edit3,'string',num2str(psnr_hadamard));
handles.Pic1=Pic_abnorm;
handles.Pic2=Pic2show;
guidata(hObject,handles);

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
Pic_trans=handles.Pic1;
imshow(Pic_trans);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
Pic2show=handles.Pic2;
imshow(Pic2show);
