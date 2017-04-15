function varargout = GUI_DYMATIC1(varargin)
% GUI_DYMATIC1 MATLAB code for GUI_DYMATIC1.fig
%      GUI_DYMATIC1, by itself, creates a new GUI_DYMATIC1 or raises the existing
%      singleton*.
%
%      H = GUI_DYMATIC1 returns the handle to a new GUI_DYMATIC1 or the handle to
%      the existing singleton*.
%
%      GUI_DYMATIC1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DYMATIC1.M with the given input arguments.
%
%      GUI_DYMATIC1('Property','Value',...) creates a new GUI_DYMATIC1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DYMATIC1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DYMATIC1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DYMATIC1

% Last Modified by GUIDE v2.5 09-Aug-2016 14:30:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DYMATIC1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DYMATIC1_OutputFcn, ...
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


% --- Executes just before GUI_DYMATIC1 is made visible.
function GUI_DYMATIC1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DYMATIC1 (see VARARGIN)

% Choose default command line output for GUI_DYMATIC1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DYMATIC1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DYMATIC1_OutputFcn(hObject, eventdata, handles) 
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
eval('GUI_DYMATIC2');

% --- Executes on button press in Btn_up.
function Btn_up_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_MAIN');

% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Btn_in.
function Btn_in_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_in (see GCBO)
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
axes(handles.Fig_Forcein);
plot(vx{1},Fd{1},vx{2},Fd{2},vx{3},Fd{3},vx{4},Fd{4},'LineWidth',4);
legend('一档驱动特性曲线','二挡驱动特性曲线','三挡驱动特性曲线','四挡驱动特性曲线');
title('驱动特性/行驶阻力曲线','fontsize',15);
xlabel('速度（m/s）','fontsize',15);
ylabel('驱动力（N)','fontsize',15);
for i=1:4
    hold on
    text(vx{i}(MAX_Fd_ADR(i)),MAX_Fd_NUM(i)+3000,strcat('\leftarrow     ',num2str(i),'档最大驱动力'),'fontsize',12);
    hold on
    plot(vx{i}(MAX_Fd_ADR(i)),MAX_Fd_NUM(i),'o','LineWidth',2,'color','k');
end
str_fmax1=num2str(round(MAX_Fd_NUM(1),2));
str_fmax2=num2str(round(MAX_Fd_NUM(2),2));
str_fmax3=num2str(round(MAX_Fd_NUM(3),2));
str_fmax4=num2str(round(MAX_Fd_NUM(4),2));
set(handles.Tbx_Fmax1,'String',str_fmax1);
set(handles.Tbx_Fmax2,'String',str_fmax2);
set(handles.Tbx_Fmax3,'String',str_fmax3);
set(handles.Tbx_Fmax4,'String',str_fmax4);

function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);
    
function y=curve_turbine(x)
    global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);

% --- Executes on button press in Btn_out.
function Btn_out_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global par_ig1 par_ig2 par_ig3 par_ig4 par_io;
global par_turbineD par_carM par_loadM par_A par_fair par_froll par_r par_nengine par_nio par_nig; 
global par_fai par_pmaxP par_pmaxN par_pmaxT par_tmaxN par_tmaxP par_tmaxT par_Iw par_If par_rou;
%%
n_t=[0:10:2400];%泵轮转速范围
T_t=curve_turbine(n_t);%泵轮扭矩
R=par_r;%车轮滚动半径 
io=par_io;%主减速比
ig=[par_ig1 par_ig2 par_ig3 par_ig4];%变速比
N_t=par_nengine*par_nio*par_nig; %效率【发动机 主减 分减】
%%
%最高车速
% 求交点
for i=1:4
    Ft{i}=T_t.*io*ig(i)*N_t/R;%第i档的驱动力
    vt{i}=0.377*R*n_t./io/ig(i);
end
axes(handles.Fig_Forceout);
plot(vt{1},Ft{1},vt{2},Ft{2},vt{3},Ft{3},vt{4},Ft{4},'LineWidth',4)
for i=1:4
    [MAX_vt_NUM(i),MAX_vt_ADR(i)]=max(vt{i}); 
    hold on
    plot(vt{i}(MAX_vt_ADR(i)),MAX_vt_NUM(i),'*','LineWidth',2,'color','k');
end
for i=1:3
    aax{i}=intp(vt{i},Ft{i},vt{i+1},Ft{i+1});
    hold on
	plot(aax{i}(1),aax{i}(2),'o','LineWidth',2,'color','r');
    hold on
    text(aax{i}(1),aax{i}(2)+3000,strcat('\leftarrow     ',num2str(i),'档换挡速度'),'fontsize',12);
end
legend('一档驱动力输出曲线','二挡驱动力输出曲线','三挡驱动力输出曲线','四挡驱动力输出曲线');
title('驱动特性曲线','fontsize',15);
xlabel('速度（m/s）','fontsize',15);
ylabel('输出驱动力(N)','fontsize',15);
str_vmax1=num2str(round(MAX_vt_NUM(1),2));
str_vmax2=num2str(round(MAX_vt_NUM(2),2));
str_vmax3=num2str(round(MAX_vt_NUM(3),2));
str_vmax4=num2str(round(MAX_vt_NUM(4),2));
set(handles.Tbx_Vmax1,'String',str_vmax1);
set(handles.Tbx_Vmax2,'String',str_vmax2);
set(handles.Tbx_Vmax3,'String',str_vmax3);
set(handles.Tbx_Vmax4,'String',str_vmax4);
str_vchange1=num2str(round(aax{1}(1),2));
str_vchange2=num2str(round(aax{2}(1),2));
str_vchange3=num2str(round(aax{3}(1),2));
set(handles.Tbx_Vchange1,'String',str_vchange1);
set(handles.Tbx_Vchange2,'String',str_vchange2);
set(handles.Tbx_Vchange3,'String',str_vchange3);


function Tbx_Vchange1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vchange1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vchange1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vchange1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vchange2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vchange2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vchange2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vchange2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vchange3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vchange3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vchange3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vchange3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vchange4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vchange4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vchange4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vchange4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vchange4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vmax1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vmax1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vmax1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vmax1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vmax2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vmax2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vmax2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vmax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vmax3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vmax3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vmax3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vmax3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Vmax4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Vmax4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Vmax4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Vmax4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Vmax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Fmax1_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Fmax1 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Fmax1 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Fmax1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Fmax2_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Fmax2 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Fmax2 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Fmax2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Fmax3_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Fmax3 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Fmax3 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Fmax3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_Fmax4_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Fmax4 as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Fmax4 as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Fmax4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Fmax4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
