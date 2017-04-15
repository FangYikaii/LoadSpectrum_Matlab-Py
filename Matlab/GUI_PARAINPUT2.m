function varargout = GUI_PARAINPUT2(varargin)
% GUI_PARAINPUT2 MATLAB code for GUI_PARAINPUT2.fig
%      GUI_PARAINPUT2, by itself, creates a new GUI_PARAINPUT2 or raises the existing
%      singleton*.
%
%      H = GUI_PARAINPUT2 returns the handle to a new GUI_PARAINPUT2 or the handle to
%      the existing singleton*.
%
%      GUI_PARAINPUT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PARAINPUT2.M with the given input arguments.
%
%      GUI_PARAINPUT2('Property','Value',...) creates a new GUI_PARAINPUT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_PARAINPUT2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_PARAINPUT2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_PARAINPUT2

% Last Modified by GUIDE v2.5 08-Aug-2016 20:53:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_PARAINPUT2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_PARAINPUT2_OutputFcn, ...
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


% --- Executes just before GUI_PARAINPUT2 is made visible.
function GUI_PARAINPUT2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_PARAINPUT2 (see VARARGIN)

% Choose default command line output for GUI_PARAINPUT2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_PARAINPUT2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_PARAINPUT2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Btn_engine.
function Btn_fuel_Callback(hObject, eventdata, handles)
% --- Executes on button press in Btn_fuel.
% hObject    handle to Btn_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_fuel_n data_fuel_T data_fuel_Q fun_fuel
x=data_fuel_n;
y=data_fuel_T;
z=data_fuel_Q;
X = [ones(size(x)) x.*x x y.*y y x.*y];  
[b,bint] = regress(z,X);
axes(handles.Fig_Fuel);
scatter3(x,y,z,'filled')  
hold on  
xfit = min(x):0.5:max(x);  
yfit = min(y):0.5:max(y);  
[xFIT,yFIT] = meshgrid(xfit,yfit);  
zFIT = b(1)+ b(2)*xFIT.*xFIT+b(3)*xFIT + b(4)*yFIT.*yFIT + b(5)*yFIT + b(6)*xFIT.*yFIT;
mesh(xFIT,yFIT,zFIT)  
xlabel('发动机转速')  
ylabel('发动机扭矩')  
zlabel('发动机燃油消耗率')  
title('发动机万有特性曲面图')
axes(handles.Fig_fuel_contour);
P=contour(xFIT,yFIT,zFIT,10);%取截面线
title('发动机万有特性等高线图')
xlabel('发动机转速')
ylabel('发动机扭矩)') 
zlabel('发动机燃油消耗率)') 
clabel(P);%把“等位值”沿等位线随机标识
str=strcat('y=(',num2str(b(1)),')+(',num2str(b(2)),')*x^2+(',num2str(b(3)),')*x+(',num2str(b(4)),')*y^2+(',num2str(b(5)),')*y+(',num2str(b(6)),')*x*y');
set(handles.Tbx_fuel,'String',str);
fun_fuel=b;




% --- Executes on button press in Btn_engine.
function Btn_engine_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_engine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_engine_n data_engine_T fun_engine
x1=data_engine_n;
x2=data_engine_T;
%ployfit用于多项式拟合，返回的是多项式系数，从高到低依次存入p
p=polyfit(x1,x2,2);
%xi  （0,1）区间，去n点
xi=linspace(x1(1),x1(length(x1)));
%得到z=p(0)*x^n+p(1)*x^n-1+......+p(n-1)*x+p(n)多项式
z=polyval(p,xi);
axes(handles.Fig_Engine);
plot(x1,x2,'o',xi,z,'k:',x1,x2,'r','LineWidth',2)
grid on
legend('原始数据','多项式');
xlabel('发动机转速')
ylabel('发动机扭矩)') 
title('发动机外特性曲线')
str=strcat('y=(',num2str(p(1)),')*x^2+（',num2str(p(2)),')*x+(',num2str(p(3)),')');
set(handles.Tbx_engine,'String',str);
fun_engine=p;

% --- Executes on button press in Btn_down.
function Btn_down_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_PARAINPUT3');

% --- Executes on button press in Btn_up.
function Btn_up_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_PARAINPUT1');


function Tbx_fuel_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_fuel as text
%        str2double(get(hObject,'String')) returns contents of Tbx_fuel as a double


% --- Executes during object creation, after setting all properties.
function Tbx_fuel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_fuel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_engine_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_engine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_engine as text
%        str2double(get(hObject,'String')) returns contents of Tbx_engine as a double


% --- Executes during object creation, after setting all properties.
function Tbx_engine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_engine (see GCBO)
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
