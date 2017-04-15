function varargout = GUI_MATRIX_INTEGRATE(varargin)
% GUI_MATRIX_INTEGRATE MATLAB code for GUI_MATRIX_INTEGRATE.fig
%      GUI_MATRIX_INTEGRATE, by itself, creates a new GUI_MATRIX_INTEGRATE or raises the existing
%      singleton*.
%
%      H = GUI_MATRIX_INTEGRATE returns the handle to a new GUI_MATRIX_INTEGRATE or the handle to
%      the existing singleton*.
%
%      GUI_MATRIX_INTEGRATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MATRIX_INTEGRATE.M with the given input arguments.
%
%      GUI_MATRIX_INTEGRATE('Property','Value',...) creates a new GUI_MATRIX_INTEGRATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_MATRIX_INTEGRATE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_MATRIX_INTEGRATE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_MATRIX_INTEGRATE

% Last Modified by GUIDE v2.5 30-Oct-2016 21:28:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MATRIX_INTEGRATE_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MATRIX_INTEGRATE_OutputFcn, ...
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


% --- Executes just before GUI_MATRIX_INTEGRATE is made visible.
function GUI_MATRIX_INTEGRATE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_MATRIX_INTEGRATE (see VARARGIN)

% Choose default command line output for GUI_MATRIX_INTEGRATE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_MATRIX_INTEGRATE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_MATRIX_INTEGRATE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Btn_back.
function Btn_back_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_AXIS_SPECTRUM');


function Tbx_std_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_std_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_std_xz as text
%        str2double(get(hObject,'String')) returns contents of Tbx_std_xz as a double


% --- Executes during object creation, after setting all properties.
function Tbx_std_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_std_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_std_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_std_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_std_cj as text
%        str2double(get(hObject,'String')) returns contents of Tbx_std_cj as a double


% --- Executes during object creation, after setting all properties.
function Tbx_std_cj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_std_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_mean_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_mean_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_mean_xz as text
%        str2double(get(hObject,'String')) returns contents of Tbx_mean_xz as a double


% --- Executes during object creation, after setting all properties.
function Tbx_mean_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_mean_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_mean_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_mean_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_mean_cj as text
%        str2double(get(hObject,'String')) returns contents of Tbx_mean_cj as a double


% --- Executes during object creation, after setting all properties.
function Tbx_mean_cj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_mean_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_wz_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_wz_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_wz_xz as text
%        str2double(get(hObject,'String')) returns contents of Tbx_wz_xz as a double


% --- Executes during object creation, after setting all properties.
function Tbx_wz_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_wz_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_wz_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_wz_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_wz_cj as text
%        str2double(get(hObject,'String')) returns contents of Tbx_wz_cj as a double


% --- Executes during object creation, after setting all properties.
function Tbx_wz_cj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_wz_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_cd_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_cd_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_cd_xz as text
%        str2double(get(hObject,'String')) returns contents of Tbx_cd_xz as a double


% --- Executes during object creation, after setting all properties.
function Tbx_cd_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_cd_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_cd_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_cd_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_cd_cj as text
%        str2double(get(hObject,'String')) returns contents of Tbx_cd_cj as a double


% --- Executes during object creation, after setting all properties.
function Tbx_cd_cj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_cd_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_xz_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_xz_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_xz_xz as text
%        str2double(get(hObject,'String')) returns contents of Tbx_xz_xz as a double


% --- Executes during object creation, after setting all properties.
function Tbx_xz_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_xz_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_xz_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_xz_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_xz_cj as text
%        str2double(get(hObject,'String')) returns contents of Tbx_xz_cj as a double


% --- Executes during object creation, after setting all properties.
function Tbx_xz_cj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_xz_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_compute.
function Btn_compute_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global matrix_m
str_mean_cj=get(handles.Tbx_mean_cj,'String');
par_mean_cj=str2double(str_mean_cj);
str_mean_xz=get(handles.Tbx_mean_xz,'String');
par_mean_xz=str2double(str_mean_xz);
str_std_cj=get(handles.Tbx_std_cj,'String');
par_std_cj=str2double(str_std_cj);
str_std_xz=get(handles.Tbx_std_xz,'String');
par_std_xz=str2double(str_std_xz);
str_xz_cj=get(handles.Tbx_xz_cj,'String');
par_xz_cj=str2double(str_xz_cj);
str_xz_xz=get(handles.Tbx_xz_xz,'String');
par_xz_xz=str2double(str_xz_xz);
str_cd_cj=get(handles.Tbx_cd_cj,'String');
par_cd_cj=str2double(str_cd_cj);
str_cd_xz=get(handles.Tbx_cd_cj,'String');
par_cd_xz=str2double(str_cd_xz);
str_wz_cj=get(handles.Tbx_wz_cj,'String');
par_wz_cj=str2double(str_wz_cj);
str_wz_xz=get(handles.Tbx_wz_cj,'String');
par_wz_xz=str2double(str_wz_xz);
mean=[par_mean_xz,par_mean_cj];
std=[par_std_xz,par_std_cj];
xz=[par_xz_xz,par_xz_cj];
cd=[par_cd_xz,par_cd_cj];
wz=[par_wz_xz,par_wz_cj];
matrix1=matrix_m{1};
matrix2=matrix_m{2};
[MAX_MEAN,MAX_AMPL,datax,ENDMEAN,ENDAMPL]=MATRIX_INTEGRATE(matrix1,matrix2,mean,std,xz,cd,wz);
% 2d xz
data_2d_xz=zeros(9,9);
for i=1:8
    data_2d_xz(1,i+1)=MAX_AMPL{1}(i);
end
for i=1:8
    data_2d_xz(1+i,1)=MAX_MEAN{1}(i);
end
for i=1:8
    for j=1:8
        data_2d_xz(1+i,1+j)=datax{1}(i,j);
    end
end
set(handles.Tbl_2dxz,'data',data_2d_xz);

% 2d cj
data_2d_cj=zeros(9,9);
for i=1:8
    data_2d_cj(1,i+1)=MAX_AMPL{2}(i);
end
for i=1:8
    data_2d_cj(1+i,1)=MAX_MEAN{2}(i);
end
for i=1:8
    for j=1:8
        data_2d_cj(1+i,1+j)=datax{2}(i,j);
    end
end
set(handles.Tbl_2dcj,'data',data_2d_cj);

% 1d xz
data_1d_xz=zeros(2,9);
for i=1:8
    data_1d_xz(1,i+1)=MAX_AMPL{1}(i);
end
data_1d_xz(2,1)=ENDMEAN{1};
for i=1:8
    data_1d_xz(2,1+i)=cell2mat(ENDAMPL{1}(i));
end
set(handles.Tbl_1dxz,'data',data_1d_xz);

% 1d cj
data_1d_cj=zeros(2,9);
for i=1:8
    data_1d_cj(1,i+1)=MAX_AMPL{2}(i);
end
data_1d_cj(2,1)=ENDMEAN{2};
for i=1:8
    data_1d_cj(2,1+i)=cell2mat(ENDAMPL{2}(i));
end
set(handles.Tbl_1dcj,'data',data_1d_cj);


% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Tbx_mean_cj,'String','');
set(handles.Tbx_mean_xz,'String','');
set(handles.Tbx_std_cj,'String','');
set(handles.Tbx_std_xz,'String','');
set(handles.Tbx_xz_cj,'String','');
set(handles.Tbx_xz_xz,'String','');
set(handles.Tbx_cd_cj,'String','');
set(handles.Tbx_cd_xz,'String','');
set(handles.Tbx_wz_cj,'String','');
set(handles.Tbx_wz_xz,'String','');
data_2d_xz=zeros(9,9);
set(handles.Tbl_2dxz,'data',data_2d_xz);
data_2d_cj=zeros(9,9);
set(handles.Tbl_2dcj,'data',data_2d_cj);
data_1d_xz=zeros(2,9);
set(handles.Tbl_1dxz,'data',data_1d_xz);
data_1d_cj=zeros(2,9);
set(handles.Tbl_1dcj,'data',data_1d_cj);
