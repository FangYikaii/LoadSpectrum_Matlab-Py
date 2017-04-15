function varargout = GUI_DYMATIC2(varargin)
% GUI_DYMATIC2 MATLAB code for GUI_DYMATIC2.fig
%      GUI_DYMATIC2, by itself, creates a new GUI_DYMATIC2 or raises the existing
%      singleton*.
%
%      H = GUI_DYMATIC2 returns the handle to a new GUI_DYMATIC2 or the handle to
%      the existing singleton*.
%
%      GUI_DYMATIC2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DYMATIC2.M with the given input arguments.
%
%      GUI_DYMATIC2('Property','Value',...) creates a new GUI_DYMATIC2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DYMATIC2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DYMATIC2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DYMATIC2

% Last Modified by GUIDE v2.5 09-Aug-2016 15:16:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DYMATIC2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DYMATIC2_OutputFcn, ...
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


% --- Executes just before GUI_DYMATIC2 is made visible.
function GUI_DYMATIC2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DYMATIC2 (see VARARGIN)

% Choose default command line output for GUI_DYMATIC2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DYMATIC2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DYMATIC2_OutputFcn(hObject, eventdata, handles) 
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
eval('GUI_DYMATIC3');

% --- Executes on button press in Btn_up.
function Btn_up_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_DYMATIC1');

% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);
    
function y=curve_turbine(x)
    global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);


% --- Executes on button press in Btn_climb.
function Btn_climb_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_climb (see GCBO)
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
    
    PP{i}=Fd{i}.*vx{i}/3.6;%第i档功率 
    
    Fw{i}=Cd*A*vx{i}.^2/21.15;%第i档行驶空气阻力
    D{i}=(Fd{i}-Fw{i})/G;%动力因数
    
    papo_temp{i}=(D{i}-f_gundong*sqrt(1-D{i}.^2+f_gundong))/(1+f_gundong^2);
    papo_alpha{i}=asin(papo_temp{i});
    papo_alpha{i}=papo_alpha{i}*180/pi;%第i档爬坡度

    sigma_m{i}=m+Iw/R^2+(If*io*ig(i))/R^2;
    at{i}=(Fd{i}-Fw{i}-f_gundong*G)/sigma_m{i};%第i档加速度
    
    [MAX_AT_NUM(i),MAX_AT_ADR(i)]=max(at{i});%最大加速度
    [MAX_papo_NUM(i),MAX_papo_ADR(i)]=max(papo_alpha{i});%最大爬坡度
    [MAX_D_NUM(i),MAX_D_ADR(i)]=max(D{i});%最大动力因数
    [MAX_Fd_NUM(i),MAX_Fd_ADR(i)]=max(Fd{i});%最大阻力
    [MAX_PP_NUM(i),MAX_PP_ADR(i)]=max(PP{i});%最大功率
end
axes(handles.Fig_climb);
plot(vx{1},papo_alpha{1},vx{2},papo_alpha{2},vx{3},papo_alpha{3},vx{4},papo_alpha{4},'LineWidth',4);
legend('一档爬坡度曲线','二挡爬坡度曲线','三挡爬坡度曲线','四挡爬坡度曲线');
title('爬坡度曲线','fontsize',12);
xlabel('速度（m/s）','fontsize',12);
ylabel('爬坡度（°)','fontsize',12);
for i=1:4
    hold on
    text(vx{i}(MAX_papo_ADR(i)),MAX_papo_NUM(i)+3,strcat('\leftarrow     ',num2str(i),'档最大爬坡度'),'fontsize',12);
    hold on
    plot(vx{i}(MAX_papo_ADR(i)),MAX_papo_NUM(i),'o','LineWidth',2,'color','k');
end
str_climb1=num2str(round(MAX_papo_NUM(1),2));
str_climb2=num2str(round(MAX_papo_NUM(2),2));
str_climb3=num2str(round(MAX_papo_NUM(3),2));
str_climb4=num2str(round(MAX_papo_NUM(4),2));
set(handles.Tbx_climb1,'String',str_climb1);
set(handles.Tbx_climb2,'String',str_climb2);
set(handles.Tbx_climb3,'String',str_climb3);
set(handles.Tbx_climb4,'String',str_climb4);

% --- Executes on button press in Btn_acce.
function Btn_acce_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_acce (see GCBO)
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
    
    PP{i}=Fd{i}.*vx{i}/3.6;%第i档功率 
    
    Fw{i}=Cd*A*vx{i}.^2/21.15;%第i档行驶空气阻力
    D{i}=(Fd{i}-Fw{i})/G;%动力因数
    
    papo_temp{i}=(D{i}-f_gundong*sqrt(1-D{i}.^2+f_gundong))/(1+f_gundong^2);
    papo_alpha{i}=asin(papo_temp{i});
    papo_alpha{i}=papo_alpha{i}*180/pi;%第i档爬坡度

    sigma_m{i}=m+Iw/R^2+(If*io*ig(i))/R^2;
    at{i}=(Fd{i}-Fw{i}-f_gundong*G)/sigma_m{i};%第i档加速度
    
    [MAX_AT_NUM(i),MAX_AT_ADR(i)]=max(at{i});%最大加速度
    [MAX_papo_NUM(i),MAX_papo_ADR(i)]=max(papo_alpha{i});%最大爬坡度
    [MAX_D_NUM(i),MAX_D_ADR(i)]=max(D{i});%最大动力因数
    [MAX_Fd_NUM(i),MAX_Fd_ADR(i)]=max(Fd{i});%最大阻力
    [MAX_PP_NUM(i),MAX_PP_ADR(i)]=max(PP{i});%最大功率
end
axes(handles.Fig_acce);
plot(vx{1},at{1},vx{2},at{2},vx{3},at{3},vx{4},at{4},'LineWidth',4);
legend('一档加速度曲线','二挡加速度曲线','三挡加速度曲线','四挡加速度曲线');
title('加速度曲线','fontsize',12);
xlabel('速度（m/s）','fontsize',12);
ylabel('加速度（m/s2)','fontsize',12);
for i=1:4
    hold on
    text(vx{i}(MAX_AT_ADR(i)),MAX_AT_NUM(i),strcat('\leftarrow     ',num2str(i),'档最大加速度'),'fontsize',12);
    hold on
    plot(vx{i}(MAX_AT_ADR(i)),MAX_AT_NUM(i),'o','LineWidth',2,'color','r');
end
str_acce1=num2str(round(MAX_AT_NUM(1),2));
str_acce2=num2str(round(MAX_AT_NUM(2),2));
str_acce3=num2str(round(MAX_AT_NUM(3),2));
str_acce4=num2str(round(MAX_AT_NUM(4),2));
set(handles.Tbx_acce1,'String',str_acce1);
set(handles.Tbx_acce2,'String',str_acce2);
set(handles.Tbx_acce3,'String',str_acce3);
set(handles.Tbx_acce4,'String',str_acce4);

% --- Executes on button press in Btn_dymatic.
function Btn_dymatic_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_dymatic (see GCBO)
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
    
    PP{i}=Fd{i}.*vx{i}/3.6;%第i档功率 
    
    Fw{i}=Cd*A*vx{i}.^2/21.15;%第i档行驶空气阻力
    D{i}=(Fd{i}-Fw{i})/G;%动力因数
    [MAX_D_NUM(i),MAX_D_ADR(i)]=max(D{i});%最大动力因数
end
axes(handles.Fig_dymatic);
plot(vx{1},D{1},vx{2},D{2},vx{3},D{3},vx{4},D{4},'LineWidth',4);
legend('一档动力因数曲线','二挡动力因数曲线','三挡动力因数曲线','四挡动力因数曲线');
title('动力因数曲线','fontsize',12);
xlabel('速度（m/s）','fontsize',12);
ylabel('动力因数','fontsize',12);
for i=1:4
    hold on
    text(vx{i}(MAX_D_ADR(i)),MAX_D_NUM(i),strcat('\leftarrow     ',num2str(i),'档最大动力因数'),'fontsize',12);
    hold on
    plot(vx{i}(MAX_D_ADR(i)),MAX_D_NUM(i),'o','LineWidth',2,'color','y');
end
str_D1=num2str(round(MAX_D_NUM(1),2));
str_D2=num2str(round(MAX_D_NUM(2),2));
str_D3=num2str(round(MAX_D_NUM(3),2));
str_D4=num2str(round(MAX_D_NUM(4),2));
set(handles.Tbx_dymatic1,'String',str_D1);
set(handles.Tbx_dymatic2,'String',str_D2);
set(handles.Tbx_dymatic3,'String',str_D3);
set(handles.Tbx_dymatic4,'String',str_D4);


function Tbx_dymatic4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_dymatic4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_dymatic4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_dymatic4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_dymatic3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_dymatic3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_dymatic3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_dymatic3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_dymatic2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_dymatic2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_dymatic2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_dymatic2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_dymatic1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_dymatic1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_dymatic1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_dymatic1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_dymatic1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_climb4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_climb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_climb4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_climb4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_climb4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_climb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_climb3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_climb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_climb3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_climb3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_climb3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_climb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_climb2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_climb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_climb2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_climb2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_climb2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_climb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_climb1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_climb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_climb1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_climb1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_climb1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_climb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_acce4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_acce4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_acce4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_acce4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_acce4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_acce4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_acce3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_acce3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_acce3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_acce3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_acce3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_acce3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_acce2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_acce2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_acce2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_acce2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_acce2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_acce2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_acce1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_acce1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_acce1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_acce1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_acce1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_acce1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
