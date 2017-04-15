function varargout = GUI_PARAINPUT1(varargin)
% GUI_PARAINPUT1 MATLAB code for GUI_PARAINPUT1.fig
%      GUI_PARAINPUT1, by itself, creates a new GUI_PARAINPUT1 or raises the existing
%      singleton*.
%
%      H = GUI_PARAINPUT1 returns the handle to a new GUI_PARAINPUT1 or the handle to
%      the existing singleton*.
%
%      GUI_PARAINPUT1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PARAINPUT1.M with the given input arguments.
%
%      GUI_PARAINPUT1('Property','Value',...) creates a new GUI_PARAINPUT1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PARAINPUT1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PARAINPUT1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PARAINPUT1

% Last Modified by GUIDE v2.5 31-Oct-2016 11:25:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PARAINPUT1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PARAINPUT1_OutputFcn, ...
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


% --- Executes just before GUI_PARAINPUT1 is made visible.
function GUI_PARAINPUT1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PARAINPUT1 (see VARARGIN)

% Choose default command line output for GUI_PARAINPUT1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PARAINPUT1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PARAINPUT1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Btn_5.
function Btn_5_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_MAIN');

% --- Executes on button press in Btn_4.
function Btn_4_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_PARAINPUT2');
global par_turbineD par_carM par_loadM par_A par_fair par_froll par_r par_nengine par_nio par_nig; 
global par_fai par_pmaxP par_pmaxN par_pmaxT par_tmaxN par_tmaxP par_tmaxT par_Iw par_If par_rou;
global par_ig1 par_ig2 par_ig3 par_ig4 par_io;
str_carM=get(handles.Tbx_weight,'String');
par_carM=str2double(str_carM);
str_loadM=get(handles.Tbx_Load,'String');
par_loadM=str2double(str_loadM);
str_A=get(handles.Tbx_Area,'String');
par_A=str2double(str_A);
str_fair=get(handles.Tbx_fair,'String');
par_fair=str2double(str_fair);
str_froll=get(handles.Tbx_froll,'String');
par_froll=str2double(str_froll);
str_r=get(handles.Tbx_R,'String');
par_r=str2double(str_r);
str_nengine=get(handles.Tbx_Nengine,'String');
par_nengine=str2double(str_nengine);
str_nio=get(handles.Tbx_Nio,'String');
par_nio=str2double(str_nio);
str_nig=get(handles.Tbx_Nig,'String');
par_nig=str2double(str_nig);
str_fai=get(handles.Tbx_fai,'String');
par_fai=str2double(str_fai);
str_pmaxP=get(handles.Tbx_MaxPp,'String');
par_pmaxP=str2double(str_pmaxP);
str_pmaxN=get(handles.Tbx_MaxPv,'String');
par_pmaxN=str2double(str_pmaxN);
str_pmaxT=get(handles.Tbx_MaxPt,'String');
par_pmaxT=str2double(str_pmaxT);
str_tmaxT=get(handles.Tbx_MaxTt,'String');
par_tmaxT=str2double(str_tmaxT);
str_tmaxN=get(handles.Tbx_MaxTv,'String');
par_tmaxN=str2double(str_tmaxN);
str_tmaxP=get(handles.Tbx_MaxTp,'String');
par_tmaxP=str2double(str_tmaxP);
str_If=get(handles.Tbx_If,'String');
par_If=str2double(str_If);
str_Iw=get(handles.Tbx_Iw,'String');
par_Iw=str2double(str_Iw);
str_rou=get(handles.Tbx_rou,'String');
par_rou=str2double(str_rou);
str_turbineD=get(handles.Tbx_turbineD,'String');
par_turbineD=str2double(str_turbineD);

str_ig1=get(handles.Tbx_ig1,'String');
par_ig1=str2double(str_ig1);
str_ig2=get(handles.Tbx_ig2,'String');
par_ig2=str2double(str_ig2);
str_ig3=get(handles.Tbx_ig3,'String');
par_ig3=str2double(str_ig3);
str_ig4=get(handles.Tbx_ig4,'String');
par_ig4=str2double(str_ig4);
str_io=get(handles.Tbx_io,'String');
par_io=str2double(str_io);


function Tbx_Nio_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Nio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Nio as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Nio as a double


function Tbx_io_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Nio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Nio as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Nio as a double

% --- Executes during object creation, after setting all properties.
function Tbx_Nio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Nio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Tbx_io_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Nio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Tbx_ig1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_ig1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_ig1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_ig1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_ig1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_ig1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_ig2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_ig2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_ig2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_ig2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_ig2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_ig2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_ig3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_ig3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_ig3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_ig3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_ig3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_ig3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_ig4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_ig4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_ig4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_ig4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_ig4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_ig4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_weight_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_weight as text
%        str2double(get(hObject,'String')) returns contents of Tbx_weight as a double


% --- Executes during object creation, after setting all properties.
function Tbx_weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Load_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Load as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Load as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Area_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Area as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Area as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_fair_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_fair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_fair as text
%        str2double(get(hObject,'String')) returns contents of Tbx_fair as a double


% --- Executes during object creation, after setting all properties.
function Tbx_fair_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_fair (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_froll_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_froll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_froll as text
%        str2double(get(hObject,'String')) returns contents of Tbx_froll as a double


% --- Executes during object creation, after setting all properties.
function Tbx_froll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_froll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_R_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_R as text
%        str2double(get(hObject,'String')) returns contents of Tbx_R as a double


% --- Executes during object creation, after setting all properties.
function Tbx_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxPp_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxPp as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxPp as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxPp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxPv_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxPv as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxPv as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxPv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxPt_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxPt as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxPt as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxPt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxPt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Nengine_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Nengine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Nengine as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Nengine as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Nengine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Nengine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Nig_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Nig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Nig as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Nig as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Nig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Nig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxTt_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxTt as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxTt as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxTt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxTv_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxTv as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxTv as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxTv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxTp_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxTp as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxTp as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxTp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxTp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Iw_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Iw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Iw as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Iw as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Iw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Iw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_If_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_If (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_If as text
%        str2double(get(hObject,'String')) returns contents of Tbx_If as a double


% --- Executes during object creation, after setting all properties.
function Tbx_If_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_If (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_rou_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_rou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_rou as text
%        str2double(get(hObject,'String')) returns contents of Tbx_rou as a double


% --- Executes during object creation, after setting all properties.
function Tbx_rou_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_rou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_fai_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_fai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_fai as text
%        str2double(get(hObject,'String')) returns contents of Tbx_fai as a double


% --- Executes during object creation, after setting all properties.
function Tbx_fai_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_fai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_fuel.
function Btn_fuel_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_fuel_n data_fuel_T data_fuel_Q flag_conn EngineName conn
if flag_conn==true
    sqlquery=strcat('SELECT Me,n,ge FROM enginecurve WHERE EngineName=''',EngineName,'''AND EngineGroupx=1;');
    cursor = exec(conn,sqlquery);         
    cursor = fetch(cursor);    
    %% 保存数据
    data = cursor.data;
    inputdata=cell2mat(data);
    data_fuel_n=inputdata(:,2);
    data_fuel_T=inputdata(:,1);
    data_fuel_Q=inputdata(:,3);
else
    [filename,pathname,filterindex] = uigetfile({'*.xlsx';'*.xls';'*.*'},'导入Excl文件');
    if filterindex
        filename=strcat(pathname,filename);
        inputdata=xlsread(filename); 
        data_fuel_n=inputdata(:,1);
        data_fuel_T=inputdata(:,2);
        data_fuel_Q=inputdata(:,3);
    end
end


% --- Executes on button press in Btn_2.
function Btn_2_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_engine_n data_engine_T flag_conn EngineName conn
if flag_conn==true
    sqlquery=strcat('SELECT Me,n FROM enginecurve WHERE EngineName=''',EngineName,'''AND EngineGroupx=1;');
    cursor = exec(conn,sqlquery);         
    cursor = fetch(cursor);    
    %% 保存数据
    data = cursor.data;
    inputdata=cell2mat(data);
    data_engine_n=inputdata(:,2);
    data_engine_T=inputdata(:,1);
else
    [filename,pathname,filterindex] = uigetfile({'*.xlsx';'*.xls';'*.*'},'导入Excl文件');
    if filterindex
        filename=strcat(pathname,filename);
        inputdata=xlsread(filename); 
        data_engine_n=inputdata(:,1);
        data_engine_T=inputdata(:,2);
    end
end

% --- Executes on button press in Btn_3.
function Btn_3_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_turbine_i data_turbine_k data_turbine_n data_turbine_t data_turbine_lamda flag_conn TurbineName conn
if flag_conn==true
    sqlquery=strcat('SELECT K,i,nt,Mt,lamda FROM turbinecurve WHERE TurbineName=''',TurbineName,'''AND TurbineGroupx=1;');
    cursor = exec(conn,sqlquery);         
    cursor = fetch(cursor);    
    %% 保存数据
    data = cursor.data;
    inputdata=cell2mat(data);
    data_turbine_i=inputdata(:,2);
    data_turbine_k=inputdata(:,1);
    data_turbine_n=inputdata(:,3);
    data_turbine_t=inputdata(:,4);
    data_turbine_lamda=inputdata(:,5);
else
    [filename,pathname,filterindex] = uigetfile({'*.xlsx';'*.xls';'*.*'},'导入Excl文件');
    if filterindex
        filename=strcat(pathname,filename);
        inputdata=xlsread(filename); 
        data_turbine_i=inputdata(:,1);
        data_turbine_k=inputdata(:,2);
        data_turbine_n=inputdata(:,3);
        data_turbine_t=inputdata(:,4);
        data_turbine_lamda=inputdata(:,5);
    end
end



function Tbx_turbineD_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_turbineD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_turbineD as text
%        str2double(get(hObject,'String')) returns contents of Tbx_turbineD as a double


% --- Executes during object creation, after setting all properties.
function Tbx_turbineD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_turbineD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Tbx_dbname_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_dbname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_dbname as text
%        str2double(get(hObject,'String')) returns contents of Tbx_dbname as a double


% --- Executes during object creation, after setting all properties.
function Tbx_dbname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_dbname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_username_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_username as text
%        str2double(get(hObject,'String')) returns contents of Tbx_username as a double


% --- Executes during object creation, after setting all properties.
function Tbx_username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_host_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_host (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_host as text
%        str2double(get(hObject,'String')) returns contents of Tbx_host as a double


% --- Executes during object creation, after setting all properties.
function Tbx_host_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_host (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_password_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_password as text
%        str2double(get(hObject,'String')) returns contents of Tbx_password as a double


% --- Executes during object creation, after setting all properties.
function Tbx_password_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Brn_conn.
function Brn_conn_Callback(hObject, eventdata, handles)
% hObject    handle to Brn_conn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag_conn EngineName TurbineName conn
dbname = get(handles.Tbx_dbname,'string');          
username =  get(handles.Tbx_username,'string');        
password =  get(handles.Tbx_password,'string');        
host =  get(handles.Tbx_host,'string');  
carname = get(handles.Tbx_car,'string');
conn = database(dbname,username,password,'Vendor','MySQL','Server',host);  %建立连接
sqlquery_1 = strcat('select CarframeName,TurbineName,EngineName,GearName from carinfo where CarName =''',carname,''';');
cursor = exec(conn,sqlquery_1);                                 
cursor = fetch(cursor);      
data = cursor.data;
TurbineName=data{2};
CarframeName=data{1};
EngineName=data{3};
GearName=data{4};
%液力变矩器
sqlquery_2 = strcat('select TurbineD,ITurbine from turbineinfo where TurbineName =''',TurbineName,''';');
cursor = exec(conn,sqlquery_2);                                 
cursor = fetch(cursor);      
data = cursor.data;
TurbineD=num2str(data{1}/1000);
ITurbine=data{2};
%车架
sqlquery_3 = strcat('select DriveAxleSpeedRatio,Roll,WeightEmpty,WeightFull,AirArea,nDriveAxleSpeedRatio,Iwheel from carframeinfo where CarframeName =''',CarframeName,''';');
cursor = exec(conn,sqlquery_3);                                 
cursor = fetch(cursor);      
data = cursor.data;
DriveAxleSpeedRatio=data{1};
Roll=data{2};
WeightEmpty=data{3};
WeightFull=data{4};
AirArea=data{5};
nDriveAxleSpeedRatio=data{6};
Iwheel=data{7};

%齿轮箱
sqlquery_4 = strcat('select F1,F2,F3,F4,nGear from gearinfo where GearName =''',GearName,''';');
cursor = exec(conn,sqlquery_4);                                 
cursor = fetch(cursor);      
data = cursor.data;
F1=data{1};
F2=data{2};
F3=data{3};
F4=data{4};
nGear=data{5};

%发动机
sqlquery_5 = strcat('select MaxTorque,MaxTorqueSpeed,MaxTorquePower,MaxPower,MaxPowerSpeed,MaxPowerTorque,nEngine from engineinfo where EngineName =''',EngineName,''';');
cursor = exec(conn,sqlquery_5);                                 
cursor = fetch(cursor);      
data = cursor.data;
MaxTorque=data{1};
MaxTorqueSpeed=data{2};
MaxTorquePower=data{3};
MaxPower=data{4};
MaxPowerSpeed=data{5};
MaxPowerTorque=data{6};
nEngine=data{7};
set(handles.Tbx_weight,'String',WeightEmpty);
set(handles.Tbx_Load,'String',WeightFull);
set(handles.Tbx_R,'String',Roll);
set(handles.Tbx_turbineD,'String',TurbineD);
set(handles.Tbx_ig1,'String',F1);
set(handles.Tbx_ig2,'String',F2);
set(handles.Tbx_ig3,'String',F3);
set(handles.Tbx_ig4,'String',F4);
set(handles.Tbx_io,'String',DriveAxleSpeedRatio);
set(handles.Tbx_Area,'String',AirArea);
set(handles.Tbx_Nig,'String',nGear);
set(handles.Tbx_Nio,'String',nDriveAxleSpeedRatio);
set(handles.Tbx_Iw,'String',Iwheel);
set(handles.Tbx_If,'String',ITurbine);
set(handles.Tbx_Nengine,'String',nEngine);
set(handles.Tbx_Nengine,'String')
set(handles.Tbx_MaxPp,'String',MaxPower);
set(handles.Tbx_MaxPv,'String',MaxPowerSpeed);
set(handles.Tbx_MaxPt,'String',MaxPowerTorque);
set(handles.Tbx_MaxTt,'String',MaxTorque);
set(handles.Tbx_MaxTv,'String',MaxTorqueSpeed);
set(handles.Tbx_MaxTp,'String',MaxTorquePower);
flag_conn=true;

function Tbx_car_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_car (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_car as text
%        str2double(get(hObject,'String')) returns contents of Tbx_car as a double


% --- Executes during object creation, after setting all properties.
function Tbx_car_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_car (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
