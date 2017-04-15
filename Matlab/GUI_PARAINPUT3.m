function varargout = GUI_PARAINPUT3(varargin)
% GUI_PARAINPUT3 MATLAB code for GUI_PARAINPUT3.fig
%      GUI_PARAINPUT3, by itself, creates a new GUI_PARAINPUT3 or raises the existing
%      singleton*.
%
%      H = GUI_PARAINPUT3 returns the handle to a new GUI_PARAINPUT3 or the handle to
%      the existing singleton*.
%
%      GUI_PARAINPUT3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PARAINPUT3.M with the given input arguments.
%
%      GUI_PARAINPUT3('Property','Value',...) creates a new GUI_PARAINPUT3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PARAINPUT3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PARAINPUT3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PARAINPUT3

% Last Modified by GUIDE v2.5 08-Aug-2016 21:15:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PARAINPUT3_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PARAINPUT3_OutputFcn, ...
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


% --- Executes just before GUI_PARAINPUT3 is made visible.
function GUI_PARAINPUT3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PARAINPUT3 (see VARARGIN)

% Choose default command line output for GUI_PARAINPUT3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PARAINPUT3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PARAINPUT3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Btn_down.
function Btn_down_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_MAIN');

% --- Executes on button press in Btn_up.
function Btn_up_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_PARAINPUT2');


function Tbx_curve_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_curve as text
%        str2double(get(hObject,'String')) returns contents of Tbx_curve as a double


% --- Executes during object creation, after setting all properties.
function Tbx_curve_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_turbine.
function Btn_turbine_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_turbine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_turbine_i data_turbine_k data_turbine_n data_turbine_t data_turbine_lamda par_turbineD
lamda_x=data_turbine_lamda;
rou=865;
g=9.8;
D=par_turbineD;
N=800:2400;
axes(handles.Fig_turbine);
for i=1:length(lamda_x)
    Mb{i}=rou*g*lamda_x(i)*D^5*N.^2;
    hold on
    plot(N,Mb{i},'LineWidth',1);
end
title('液力变矩器工作输入特性');
legend('液力变矩器负载曲线');
xlabel('转速（rad/s）');
ylabel('扭矩（N*m)');


% --- Executes on button press in Btn_in.
function Btn_in_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_turbine_i data_turbine_k data_turbine_n data_turbine_t data_turbine_lamda par_turbineD par_n_out par_M_out
lamda_x=data_turbine_lamda;
i_x=data_turbine_i;
K_x=data_turbine_k;
rou=865;
g=9.8;
D=par_turbineD;
N=800:2400;
%发动机外特性曲线
Me=curve_engine(N);
str_M_zhuanxiangbeng=get(handles.Tbx_zxb,'String');
num_M_zhuanxiangbeng=str2double(str_M_zhuanxiangbeng);
str_M_gongzuobeng=get(handles.Tbx_gzb,'String');
num_M_gongzuobeng=str2double(str_M_gongzuobeng);
str_M_biansubeng=get(handles.Tbx_bsb,'String');
num_M_biansubeng=str2double(str_M_biansubeng);
Me1=Me-num_M_zhuanxiangbeng-num_M_gongzuobeng-num_M_biansubeng;
axes(handles.Fig_in);
plot(N,Me,N,Me1,'LineWidth',2);
for i=1:length(lamda_x)
    Mb{i}=rou*g*lamda_x(i)*D^5*N.^2;
    hold on
    plot(N,Mb{i},'LineWidth',1);
end
title('发动机与变矩器共同工作输入特性');
legend('发动机使用外特性曲线','泵轮扭矩曲线','泵轮负载曲线');
xlabel('转速（rad/s）');
ylabel('扭矩（N*m)');
for i=1:length(lamda_x)
    hold on
    plot(N,Mb{i},'LineWidth',2);
    aax{i}=intp(N,Me1,N,Mb{i});
    hold on
    plot(aax{i}(1),aax{i}(2),'*','LineWidth',2,'color','k'); 
    par_n_out(i)=aax{i}(1)*i_x(i);
    par_M_out(i)=aax{i}(2)*K_x(i);
end

function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);

% --- Executes on button press in Btn_out.
function Btn_out_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global par_n_out par_M_out fun_turbine
x1=par_n_out;
x2=par_M_out;
%ployfit用于多项式拟合，返回的是多项式系数，从高到低依次存入p
p=polyfit(x1,x2,1);
%xi  （0,1）区间，去n点
xi=linspace(0,x1(length(x1)));
%得到z=p(0)*x^n+p(1)*x^n-1+......+p(n-1)*x+p(n)多项式
z=polyval(p,xi);
axes(handles.Fig_out);
% plot(x1,x2,'o',xi,z,'k:',x1,x2,'r')
plot(x1,x2,'o','LineWidth',4);
title('变矩器输出特性曲线');
xlabel('转速（rad/s）');
ylabel('扭矩（N*m)');
hold on
plot(xi,z,'k:','LineWidth',2);
hold on
plot(x1,x2,'r','LineWidth',4);
grid on
legend('变矩器输出特性原始数据','变矩器输出特性曲线拟合多项式')
%系数数组转换为符号多项式
str=strcat('y=(',num2str(p(1)),')*x+',num2str(p(2)));
set(handles.Tbx_curve,'String',str);
fun_turbine=p;

function y=curve_turbine(x)
global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);

function Tbx_gzb_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_gzb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_gzb as text
%        str2double(get(hObject,'String')) returns contents of Tbx_gzb as a double


% --- Executes during object creation, after setting all properties.
function Tbx_gzb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_gzb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_zxb_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_zxb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_zxb as text
%        str2double(get(hObject,'String')) returns contents of Tbx_zxb as a double


% --- Executes during object creation, after setting all properties.
function Tbx_zxb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_zxb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_bsb_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_bsb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_bsb as text
%        str2double(get(hObject,'String')) returns contents of Tbx_bsb as a double


% --- Executes during object creation, after setting all properties.
function Tbx_bsb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_bsb (see GCBO)
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
