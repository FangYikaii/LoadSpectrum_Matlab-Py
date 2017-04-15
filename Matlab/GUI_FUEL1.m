function varargout = GUI_FUEL1(varargin)
% GUI_FUEL1 MATLAB code for GUI_FUEL1.fig
%      GUI_FUEL1, by itself, creates a new GUI_FUEL1 or raises the existing
%      singleton*.
%
%      H = GUI_FUEL1 returns the handle to a new GUI_FUEL1 or the handle to
%      the existing singleton*.
%
%      GUI_FUEL1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FUEL1.M with the given input arguments.
%
%      GUI_FUEL1('Property','Value',...) creates a new GUI_FUEL1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_FUEL1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_FUEL1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_FUEL1

% Last Modified by GUIDE v2.5 13-Aug-2016 18:08:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_FUEL1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_FUEL1_OutputFcn, ...
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


% --- Executes just before GUI_FUEL1 is made visible.
function GUI_FUEL1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_FUEL1 (see VARARGIN)

% Choose default command line output for GUI_FUEL1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_FUEL1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_FUEL1_OutputFcn(hObject, eventdata, handles) 
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
eval('GUI_MAIN');

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_next.
function Btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_FUEL2');

function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);
    
function y=curve_turbine(x)
    global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);

function y=curve_fuel(x,y)
    global fun_fuel;
    y=fun_fuel(1)+fun_fuel(2)*x.^2+fun_fuel(3)*x+fun_fuel(4)*y.^2+fun_fuel(5)*y+fun_fuel(6)*x*y;
    
% --- Executes on button press in Btn_fuel.
function Btn_fuel_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global par_ig1 par_ig2 par_ig3 par_ig4 par_io;
global par_turbineD par_carM par_loadM par_A par_fair par_froll par_r par_nengine par_nio par_nig; 
global par_fai par_pmaxP par_pmaxN par_pmaxT par_tmaxN par_tmaxP par_tmaxT par_Iw par_If par_rou;
n_t=[0:10:2400];%泵轮转速范围
T_t=curve_engine(n_t);%泵轮扭矩
R=par_r;%车轮滚动半径 
io=par_io;%主减速比
ig=[par_ig1 par_ig2 par_ig3 par_ig4];%变速比
N_t=par_nengine*par_nio*par_nig; %效率【发动机 主减 分减】
g=9.8;
%%
%最高车速
% 求交点
for i=1:4 
    vt{i}=0.377*R*n_t./io/ig(i);
    maxvt(i)=max(vt{i});
end
for i=1:4
    for j=1:50
        v{i}(j)=maxvt(i)/50*j;
        n{i}(j)=v{i}(j)*io*ig(i)/0.37/R;
        P{i}(j)=1/0.95*(par_carM*g*par_froll*v{i}(j)/3600+par_fair*par_A*v{i}(j).^3/76140);
        b=curve_fuel(n{i}(j),curve_turbine(n{i}(j)));
        Q{i}(j)=P{i}(j)*b/v{i}(j)/1.02/par_rou/9.8;
    end
   [MIN_Q_NUM(i),MIN_Q_ADR(i)]=min(Q{i});%最低燃油消耗量
end
axes(handles.Fig_fuel);
plot(v{1},Q{1},v{2},Q{2},v{3},Q{3},v{4},Q{4},'LineWidth',4);
legend('一档油耗曲线','二挡油耗曲线','三挡油耗曲线','四挡油耗曲线');
title('油耗曲线','fontsize',12);
xlabel('速度（m/s）','fontsize',12);
ylabel('油耗（L)','fontsize',12);
data=[v{1}',Q{1}',v{2}',Q{2}',v{3}',Q{3}',v{4}',Q{4}'];
set(handles.Tab_1,'data',data);
for i=1:4
    hold on
    plot(v{i}(MIN_Q_ADR(i)),MIN_Q_NUM(i),'o','LineWidth',8,'color','k');
end
str_V1=num2str(v{i}(MIN_Q_ADR(1)));
str_V2=num2str(v{i}(MIN_Q_ADR(2)));
str_V3=num2str(v{i}(MIN_Q_ADR(3)));
str_V4=num2str(v{i}(MIN_Q_ADR(4)));
str_Q1=num2str(MIN_Q_NUM(1));
str_Q2=num2str(MIN_Q_NUM(2));
str_Q3=num2str(MIN_Q_NUM(3));
str_Q4=num2str(MIN_Q_NUM(4));
set(handles.Tbx_v1,'string',str_V1);
set(handles.Tbx_v2,'string',str_V2);
set(handles.Tbx_v3,'string',str_V3);
set(handles.Tbx_v4,'string',str_V4);
set(handles.Tbx_f1,'string',str_Q1);
set(handles.Tbx_f2,'string',str_Q2);
set(handles.Tbx_f3,'string',str_Q3);
set(handles.Tbx_f4,'string',str_Q4);


% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Tbx_v2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_v2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_v2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_v2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_v1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_v1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_v1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_v1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_f2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_f2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_f2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_f2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_f2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_f2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_f1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_f1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_f1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_f1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_v4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_v4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_v4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_v4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_v4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_v4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_v3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_v3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_v3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_v3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_v3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_v3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_f4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_f4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_f4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_f4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_f4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_f4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_f3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_f3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_f3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_f3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_f3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_f3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
