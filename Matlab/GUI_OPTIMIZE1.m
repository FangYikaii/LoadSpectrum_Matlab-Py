function varargout = GUI_OPTIMIZE1(varargin)
% GUI_OPTIMIZE1 MATLAB code for GUI_OPTIMIZE1.fig
%      GUI_OPTIMIZE1, by itself, creates a new GUI_OPTIMIZE1 or raises the existing
%      singleton*.
%
%      H = GUI_OPTIMIZE1 returns the handle to a new GUI_OPTIMIZE1 or the handle to
%      the existing singleton*.
%
%      GUI_OPTIMIZE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OPTIMIZE1.M with the given input arguments.
%
%      GUI_OPTIMIZE1('Property','Value',...) creates a new GUI_OPTIMIZE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OPTIMIZE1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OPTIMIZE1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_OPTIMIZE1

% Last Modified by GUIDE v2.5 22-Aug-2016 14:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OPTIMIZE1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OPTIMIZE1_OutputFcn, ...
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


% --- Executes just before GUI_OPTIMIZE1 is made visible.
function GUI_OPTIMIZE1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_OPTIMIZE1 (see VARARGIN)

% Choose default command line output for GUI_OPTIMIZE1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_OPTIMIZE1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OPTIMIZE1_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in Btn_select.
function Btn_select_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val_index=get(handles.List_index,'value');
switch val_index
    case 1
        set(gcf,'visible','off');
        eval('GUI_OPTIMIZE2');
    case 2  
        set(gcf,'visible','off');
        eval('GUI_OPTIMIZE3');
end

% --- Executes on selection change in List_index.
function List_index_Callback(hObject, eventdata, handles)
% hObject    handle to List_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_index contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_index
val=get(handles.List_index,'value');
switch val 
    case 2
        str='      步骤：-->初始化粒子位置（一般都是随机生成均匀分布）-->计算适应度值（一般是目标函数值-优化的对象）-->初始化历史最优pbest为其本身和找出全局最优gbest-->根据位置和速度公式进行位置和速度的更新-->重新计算适应度-->根据适应度更新历史最优pbest和全局最优gbest-->收敛或者达到最大迭代次数则退出算法';
        set(handles.Txt_show,'String',str);
    case 1
        str='      步骤：①提出了快速非支配排序算法，一方面降低了计算的复杂度，另一方面它将父代种群跟子代种群进行合并，使得下一代的种群从双倍的空间中进行选取，从而保留了最为优秀的所有个体；②引进精英策略，保证某些优良的种群个体在进化过程中不会被丢弃，从而提高了优化结果的精度；③采用拥挤度和拥挤度比较算子，不但克服了NSGA中需要人为指定共享参数的缺陷，而且将其作为种群中个体间的比较标准，使得准Pareto域中的个体能均匀地扩展到整个Pareto域，保证了种群的多样性。';
        set(handles.Txt_show,'String',str);
end


% --- Executes during object creation, after setting all properties.
function List_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function y=curve_engine(x)
global fun_engine;
    y=fun_engine(1)*x.^2+fun_engine(2)*x+fun_engine(3);
    
function y=curve_turbine(x)
    global fun_turbine;
    y=fun_turbine(1)*x+fun_turbine(2);

% --- Executes on button press in Btn_show.
function Btn_show_Callback(hObject, eventdata, handles)
str='      定义驱动功率损失率为理想驱动力曲线覆盖面积减去四档变速器驱动力覆盖面积,若四档变速器驱动力和理想传动系的驱动力所围区域面积越小，其驱动功率损失率越小，越接近理想传动状态。';
set(handles.Txt_fun1,'String',str);
str='       车辆行驶过程的耗油量反应了车辆的油耗情况。';
set(handles.Txt_fun3,'String',str);
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
f_gundong=par_froll;
Cd=par_fair;
A=par_A;
m=par_carM+par_loadM;
G=m*9.8;
% n_ttt0=par_tmaxN;%最大转矩点对应转速
n_ttt0=par_tmaxN;%最大转矩点对应转速
v0=n_ttt0*R*0.377/io/ig(1);%最大转矩点对应的速度[一档]
n1=[n_ttt0:10:2400];
T_t1=curve_turbine(n1);
%%
axes(handles.Fig);
%最高车速
% 求交点
for i=1:4
    if i==1
        Ft{i}=T_t1.*io*ig(i)*N_t/R;%第i档的驱动力
        vt{i}=0.377*R*n1./io/ig(i);
    else
        Ft{i}=T_t.*io*ig(i)*N_t/R;%第i档的驱动力
        vt{i}=0.377*R*n_t./io/ig(i);
    end
end
vv=0:0.1:vt{4}(length(vt{4}));%整个过程速度[F阻力]
F_resistance=G*f_gundong+Cd*A*vv.^2/21.15;%工作阻力曲线
aax{4}=intp(vt{4},Ft{4},vv,F_resistance);
for i=1:3
    aax{i}=intp(vt{i},Ft{i},vt{i+1},Ft{i+1});
end
% 求交点
% plotvt{1}=vt{1}(1):0.01:aax{1}(1);
plotvt{1}=0:0.01:aax{1}(1);
plotvt{2}=aax{1}(1):0.01:aax{2}(1);
plotvt{3}=aax{2}(1):0.01:aax{3}(1);
plotvt{4}=aax{3}(1):0.01:aax{4}(1); 
for i=1:4   
    plotnt{i}= plotvt{i}*ig(i)*io/R/0.377;
    plotT_t{i}=curve_turbine(plotnt{i});
    plotFt{i}=plotT_t{i}.*io*ig(i)*N_t/R;%第i档的驱动力
end
%理想作用力曲线
vva=0.377*par_pmaxN*par_pmaxT*N_t/plotFt{1}(1);
v_0_x=0:0.05:vva;
for i=1:length(v_0_x)
    v_0_y(i)=plotFt{1}(1);
end
vv1=vva:0.1:vt{4}(length(vt{4}));%整个过程速度【F理想驱动力】
Fmax=0.377*par_pmaxN*par_pmaxT*N_t./vv1;%最大功率作用力【2240最大功率对应转速，716最大功率对应转矩】【最大功率768】
vv_new=[v_0_x,vv1];
Fmax_new=[v_0_y,Fmax];
plot(plotvt{1},plotFt{1},plotvt{2},plotFt{2},plotvt{3},plotFt{3},plotvt{4},plotFt{4},vv_new,Fmax_new,vv,F_resistance,'LineWidth',4)
for i=1:4
    hold on
    plot(aax{i}(1),aax{i}(2),'*','LineWidth',7,'color','k');
    hold on
    text(aax{i}(1),aax{i}(2)+3000,strcat('\leftarrow  ',num2str(i),'档:',num2str(aax{i}(1))),'fontsize',12);
end
legend('一档驱动特性曲线','二挡驱动特性曲线','三挡驱动特性曲线','四挡驱动特性曲线','等功率发动机驱动特性曲线','行驶阻力曲线');
title('驱动特性/行驶阻力曲线','fontsize',12);
xlabel('速度（m/s）','fontsize',12);
ylabel('驱动力（N)','fontsize',12);
for i=1:4
    hold on
    plot([aax{i}(1),aax{i}(1)],[aax{i}(2),0],'--','LineWidth',2.5,'color','k');
end
% hold on
% plot([v0,v0],[Fmax(1),0],'--','LineWidth',2.5,'color','k');
hold on
plot(v0,Fmax(1),'*','LineWidth',7,'color','k');
hold on
text(v0,Fmax(1),strcat('\leftarrow  ',num2str(i),'理想传动系车轮不滑转时最小速度为：',num2str(v0)),'fontsize',12);
