function varargout = GUI_DYMATIC3(varargin)
% GUI_DYMATIC3 MATLAB code for GUI_DYMATIC3.fig
%      GUI_DYMATIC3, by itself, creates a new GUI_DYMATIC3 or raises the existing
%      singleton*.
%
%      H = GUI_DYMATIC3 returns the handle to a new GUI_DYMATIC3 or the handle to
%      the existing singleton*.
%
%      GUI_DYMATIC3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DYMATIC3.M with the given input arguments.
%
%      GUI_DYMATIC3('Property','Value',...) creates a new GUI_DYMATIC3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DYMATIC3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DYMATIC3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DYMATIC3

% Last Modified by GUIDE v2.5 10-Aug-2016 14:45:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DYMATIC3_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DYMATIC3_OutputFcn, ...
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


% --- Executes just before GUI_DYMATIC3 is made visible.
function GUI_DYMATIC3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DYMATIC3 (see VARARGIN)

% Choose default command line output for GUI_DYMATIC3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DYMATIC3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DYMATIC3_OutputFcn(hObject, eventdata, handles) 
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
eval('GUI_DYMATIC2');

% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Btn_power.
function Btn_power_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global par_ig1 par_ig2 par_ig3 par_ig4 par_io;
global par_turbineD par_carM par_loadM par_A par_fair par_froll par_r par_nengine par_nio par_nig; 
global par_fai par_pmaxP par_pmaxN par_pmaxT par_tmaxN par_tmaxP par_tmaxT par_Iw par_If par_rou;
%%
n_e=[800:10:2400];%发动机转速范围
T_e=curve_engine(n_e);%发动机扭矩
R=par_r;%车轮滚动半径 
io=par_io;%主减速比
ig=[par_ig1 par_ig2 par_ig3 par_ig4];%变速比
N_t=par_nengine*par_nio*par_nig; %效率【发动机 主减 分减】
Cd = par_fair;% 空气阻力系数
A = par_A;% 迎风面积，即汽车行驶方向的投影面积(m^2)
m = par_carM+par_loadM;% 整车质量（kg）
g = 9.8;% 重力加速度（g*m/s^2） 
G = m*g;% 汽车重力G=mg，(N)
f_gundong = par_froll;% 汽车的滚动阻力系数
Iw=par_Iw;%车轮转动惯量
If=par_If;%涡轮转动惯量
for i=1:4
    Fd{i}=T_e.*io*ig(i)*N_t/R;%第i档的驱动力
    
    vx{i}=0.377*R*n_e./io/ig(i);%第i档速度
    
    PP{i}=Fd{i}.*vx{i}/3.6/1000;%第i档功率 
 
    [MAX_PP_NUM(i),MAX_PP_ADR(i)]=max(PP{i});%最大功率
end
axes(handles.Fig_Power1);
plot(vx{1},PP{1},vx{2},PP{2},vx{3},PP{3},vx{4},PP{4},'LineWidth',2);
legend('一档功率平衡曲线','二挡功率平衡曲线','三挡功率平衡曲线','四挡功率平衡曲线');
title('功率平衡图','fontsize',15);
xlabel('速度（km/h)','fontsize',15);
ylabel('功率（KW)','fontsize',15);
for i=1:4
    hold on
    plot(vx{i}(MAX_PP_ADR(i)),MAX_PP_NUM(i),'*','LineWidth',2);
end
str_power=num2str(round(MAX_PP_NUM(4),2));
set(handles.Tbx_power,'String',str_power);
%%
%【功率平衡图】
f0=0.0120;
f1=0.0028;
f4=0.002;
c=1.8;
vv=0:0.1:vx{4}(length(vx{4}));%整个过程速度[F阻力]
vt=vv(1):(vv(length(vv))-vv(1))/160:vv(length(vv));
f=c*(f0+f1*(vt/100)+f4*(vt/100).^4);
for i=1:4
    F_r{i}=G*f+Cd*A*vx{i}.^2/21.15;
end
axes(handles.Fig_Power2);
plot(vx{1},F_r{1},vx{2},F_r{2},vx{3},F_r{3},vx{4},F_r{4},'LineWidth',2);
legend('一档功率平衡曲线','二挡功率平衡曲线','三挡功率平衡曲线','四挡功率平衡曲线');
title('功率平衡图','fontsize',15);
xlabel('速度（km/h)','fontsize',15);
ylabel('阻力（N)','fontsize',15);



function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);
    
function y=curve_turbine(x)
    global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);


function Tbx_power_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_power as text
%        str2double(get(hObject,'String')) returns contents of Tbx_power as a double


% --- Executes during object creation, after setting all properties.
function Tbx_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
