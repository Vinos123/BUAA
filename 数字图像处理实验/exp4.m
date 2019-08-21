function varargout = exp4(varargin)
% EXP4 MATLAB code for exp4.fig
%      EXP4, by itself, creates a new EXP4 or raises the existing
%      singleton*.
%
%      H = EXP4 returns the handle to a new EXP4 or the handle to
%      the existing singleton*.
%
%      EXP4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXP4.M with the given input arguments.
%
%      EXP4('Property','Value',...) creates a new EXP4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exp4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exp4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exp4

% Last Modified by GUIDE v2.5 27-May-2019 22:22:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exp4_OpeningFcn, ...
                   'gui_OutputFcn',  @exp4_OutputFcn, ...
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


% --- Executes just before exp4 is made visible.
function exp4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exp4 (see VARARGIN)

% Choose default command line output for exp4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exp4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exp4_OutputFcn(hObject, eventdata, handles) 
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
Pic=imread('houghorg.bmp');%ԭʼͼ��
Pic_gray=rgb2gray(Pic);

imwrite(Pic_gray,'houghorggray.bmp');%�Ҷ�ͼ��pic1
m=0;
sigma=get(handles.slider1,'value');
set(handles.edit1,'string',num2str(sigma));
Pic_gau=imnoise(Pic_gray,'gaussian',m,sigma);
imwrite(Pic_gau,'houghgau.bmp');%��˹������ͼ��2
axes(handles.axes2);
imshow(Pic_gau);
title('��Ӹ�˹������ͼ��');
density=get(handles.slider2,'value');
set(handles.edit2,'string',num2str(density));
Pic_salt=imnoise(Pic_gray,'salt & pepper',density);
imwrite(Pic_salt,'houghsalt.bmp');%��������ͼ��3
axes(handles.axes3);
imshow(Pic_salt);
title('��ӽ���������ͼ��');
Pic_gau_medfilted=medfilt2(Pic_gau,[9 9]);
Pic_salt_medfilted=medfilt2(Pic_salt,[9 9]);

%%%%%%%������䷽�������ж�ֵ������%%%%%%%%%%%%%
Pic_gau_medfilted_bin=imbinarize(Pic_gau_medfilted,graythresh(Pic_gau_medfilted));%��˹������ֵ������֮���ͼ��6
axes(handles.axes4);
imshow(Pic_gau_medfilted_bin);
title('������ֵ������֮���ͼ��(��˹����)');
Pic_salt_medfilted_bin=imbinarize(Pic_salt_medfilted,graythresh(Pic_salt_medfilted));%���ξ�����ֵ������֮���ͼ��7
axes(handles.axes5);
imshow(Pic_salt_medfilted_bin);
title('������ֵ������֮���ͼ��(��������)');
%%%%%%%%roberts%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_robert=edge(Pic_gau_medfilted_bin,'roberts');
Pic_salt_robert=edge(Pic_salt_medfilted_bin,'roberts');
axes(handles.axes6);
imshow(Pic_gau_robert);
title('Roberts����(��˹����)');
axes(handles.axes8);
imshow(Pic_salt_robert);
title('Roberts����(��������)');
%%%%%%%%%%%%%%%hough�任�ؽ�ͼ��%%%%%%%%%%%%%%%%%
axes(handles.axes9);
imshow(Pic_gau);
hold on;
step_r=1;
step_angle=0.1;
r_min=40;
r_max=100;
threshold=0.5;
para_gau=hough_circle(Pic_gau_robert,step_r,step_angle,r_min,r_max,threshold);
center_gau=[para_gau(:,2),para_gau(:,1)];
Radi_gau=para_gau(:,3);
viscircles(center_gau,Radi_gau);
title('Hough�任�ؽ�ͼ��(��˹����)');
axes(handles.axes10);
imshow(Pic_salt);
hold on
para_salt=hough_circle(Pic_salt_robert,step_r,step_angle,r_min,r_max,threshold);
center_salt=[para_salt(:,2),para_gau(:,1)];
Radi_salt=para_salt(:,3);
viscircles(center_salt,Radi_salt,'Color','g');
title('Hough�任�ؽ�ͼ��(��������)');




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('houghorg.bmp');%ԭʼͼ��
Pic_gray=rgb2gray(Pic);

imwrite(Pic_gray,'houghorggray.bmp');%�Ҷ�ͼ��pic1
m=0;
sigma=get(handles.slider1,'value');
set(handles.edit1,'string',num2str(sigma));
Pic_gau=imnoise(Pic_gray,'gaussian',m,sigma);
imwrite(Pic_gau,'houghgau.bmp');%��˹������ͼ��2
axes(handles.axes2);
imshow(Pic_gau);
title('��Ӹ�˹������ͼ��');
density=get(handles.slider2,'value');
set(handles.edit2,'string',num2str(density));
Pic_salt=imnoise(Pic_gray,'salt & pepper',density);
imwrite(Pic_salt,'houghsalt.bmp');%��������ͼ��3
axes(handles.axes3);
imshow(Pic_salt);
title('��ӽ���������ͼ��');
Pic_gau_medfilted=medfilt2(Pic_gau,[9 9]);
Pic_salt_medfilted=medfilt2(Pic_salt,[9 9]);

%%%%%%%������䷽�������ж�ֵ������%%%%%%%%%%%%%
Pic_gau_medfilted_bin=imbinarize(Pic_gau_medfilted,graythresh(Pic_gau_medfilted));%��˹������ֵ������֮���ͼ��6
axes(handles.axes4);
imshow(Pic_gau_medfilted_bin);
title('������ֵ������֮���ͼ��(��˹����)');
Pic_salt_medfilted_bin=imbinarize(Pic_salt_medfilted,graythresh(Pic_salt_medfilted));%���ξ�����ֵ������֮���ͼ��7
axes(handles.axes5);
imshow(Pic_salt_medfilted_bin);
title('������ֵ������֮���ͼ��(��������)');
%%%%%%%%sobel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_sobel=edge(Pic_gau_medfilted_bin,'sobel');
Pic_salt_sobel=edge(Pic_salt_medfilted_bin,'sobel');
axes(handles.axes6);
imshow(Pic_gau_sobel);
title('Sobel���ӱ�Ե���(��˹����)');
axes(handles.axes8);
imshow(Pic_salt_sobel);
title('Sobel���ӱ�Ե���(��������)');
%%%%%%%%%%%%%%%hough�任�ؽ�ͼ��%%%%%%%%%%%%%%%%%
axes(handles.axes9);
imshow(Pic_gau);
hold on;
step_r=1;
step_angle=0.1;
r_min=40;
r_max=100;
threshold=0.5;
para_gau=hough_circle(Pic_gau_sobel,step_r,step_angle,r_min,r_max,threshold);
center_gau=[para_gau(:,2),para_gau(:,1)];
Radi_gau=para_gau(:,3);
viscircles(center_gau,Radi_gau);
title('Hough�任�ؽ�ͼ��(��˹����)');
axes(handles.axes10);
imshow(Pic_salt);
hold on
para_salt=hough_circle(Pic_salt_sobel,step_r,step_angle,r_min,r_max,threshold);
center_salt=[para_salt(:,2),para_gau(:,1)];
Radi_salt=para_salt(:,3);
viscircles(center_salt,Radi_salt,'Color','g');
title('Hough�任�ؽ�ͼ��(��������)');



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pic=imread('houghorg.bmp');%ԭʼͼ��
Pic_gray=rgb2gray(Pic);

imwrite(Pic_gray,'houghorggray.bmp');%�Ҷ�ͼ��pic1
m=0;
sigma=get(handles.slider1,'value');
set(handles.edit1,'string',num2str(sigma));
Pic_gau=imnoise(Pic_gray,'gaussian',m,sigma);
imwrite(Pic_gau,'houghgau.bmp');%��˹������ͼ��2
axes(handles.axes2);
imshow(Pic_gau);
title('��Ӹ�˹������ͼ��');
density=get(handles.slider2,'value');
set(handles.edit2,'string',num2str(density));
Pic_salt=imnoise(Pic_gray,'salt & pepper',density);
imwrite(Pic_salt,'houghsalt.bmp');%��������ͼ��3
axes(handles.axes3);
imshow(Pic_salt);
title('��ӽ���������ͼ��');
Pic_gau_medfilted=medfilt2(Pic_gau,[9 9]);
Pic_salt_medfilted=medfilt2(Pic_salt,[9 9]);

%%%%%%%������䷽�������ж�ֵ������%%%%%%%%%%%%%
Pic_gau_medfilted_bin=imbinarize(Pic_gau_medfilted,graythresh(Pic_gau_medfilted));%��˹������ֵ������֮���ͼ��6
axes(handles.axes4);
imshow(Pic_gau_medfilted_bin);
title('������ֵ������֮���ͼ��(��˹����)');
Pic_salt_medfilted_bin=imbinarize(Pic_salt_medfilted,graythresh(Pic_salt_medfilted));%���ξ�����ֵ������֮���ͼ��7
axes(handles.axes5);
imshow(Pic_salt_medfilted_bin);
title('������ֵ������֮���ͼ��(��������)');
%%%%%%%%log%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_log=edge(Pic_gau_medfilted_bin,'log');
Pic_salt_log=edge(Pic_salt_medfilted_bin,'log');
axes(handles.axes6);
imshow(Pic_gau_log);
title('LOG���ӱ�Ե���(��˹����)');
axes(handles.axes8);
imshow(Pic_salt_log);
title('LOG���ӱ�Ե���(��������)');
%%%%%%%%%%%%%%%hough�任�ؽ�ͼ��%%%%%%%%%%%%%%%%%
axes(handles.axes9);
imshow(Pic_gau);
hold on;
step_r=1;
step_angle=0.1;
r_min=40;
r_max=100;
threshold=0.5;
para_gau=hough_circle(Pic_gau_log,step_r,step_angle,r_min,r_max,threshold);
center_gau=[para_gau(:,2),para_gau(:,1)];
Radi_gau=para_gau(:,3);
viscircles(center_gau,Radi_gau);
title('Hough�任�ؽ�ͼ��(��˹����)');
axes(handles.axes10);
imshow(Pic_salt);
hold on
para_salt=hough_circle(Pic_salt_log,step_r,step_angle,r_min,r_max,threshold);
center_salt=[para_salt(:,2),para_gau(:,1)];
Radi_salt=para_salt(:,3);
viscircles(center_salt,Radi_salt,'Color','g');
title('Hough�任�ؽ�ͼ��(��������)');



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes10


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
