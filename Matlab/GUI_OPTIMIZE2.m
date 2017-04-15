function varargout = GUI_OPTIMIZE2(varargin)
% GUI_OPTIMIZE2 MATLAB code for GUI_OPTIMIZE2.fig
%      GUI_OPTIMIZE2, by itself, creates a new GUI_OPTIMIZE2 or raises the existing
%      singleton*.
%
%      H = GUI_OPTIMIZE2 returns the handle to a new GUI_OPTIMIZE2 or the handle to
%      the existing singleton*.
%
%      GUI_OPTIMIZE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OPTIMIZE2.M with the given input arguments.
%
%      GUI_OPTIMIZE2('Property','Value',...) creates a new GUI_OPTIMIZE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OPTIMIZE2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OPTIMIZE2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_OPTIMIZE2

% Last Modified by GUIDE v2.5 31-Oct-2016 20:47:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OPTIMIZE2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OPTIMIZE2_OutputFcn, ...
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


% --- Executes just before GUI_OPTIMIZE2 is made visible.
function GUI_OPTIMIZE2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_OPTIMIZE2 (see VARARGIN)

% Choose default command line output for GUI_OPTIMIZE2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_OPTIMIZE2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OPTIMIZE2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in List_nsga2.
function List_nsga2_Callback(hObject, eventdata, handles)
% hObject    handle to List_nsga2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_nsga2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_nsga2


% --- Executes during object creation, after setting all properties.
function List_nsga2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_nsga2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_complexmethod.
function Btn_complexmethod_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_complexmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.List_nsga2,'string','');
set(handles.List_nsga2,'value',1);
str_pop=get(handles.Tbx_pop,'String');
pop=str2double(str_pop);
str_gen=get(handles.Tbx_gen,'String');
gen=str2double(str_gen);
chromosome=nsga_2(pop,gen); 
axes(handles.Fig_NSGA2);
plot(chromosome(:,6 + 1),chromosome(:,6 + 2),'*');
title('MOP using NSGA-II');
xlabel('f(x_1)');
ylabel('f(x_2)');
str=get(handles.List_nsga2,'string');
val=get(handles.List_nsga2,'value');
for i=1:pop
    str_new=strcat('第',num2str(i),'个解');
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);

    str_new='设计变量：';
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);
    
    str_new=strcat(num2str(chromosome(i,1)),',',num2str(chromosome(i,2)),',',num2str(chromosome(i,3)),',',num2str(chromosome(i,4)),',',num2str(chromosome(i,5)),',',num2str(chromosome(i,6)));
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);
    
    str_new='目标函数：';
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);
    
    str_new=strcat(num2str(chromosome(i,7)),',',num2str(chromosome(i,8)));
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);
    
    str_new='        ';
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_nsga2,'string',str);
    set(handles.List_nsga2,'value',val);
end
    


% --- Executes on button press in Btn_back.
function Btn_back_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_OPTIMIZE1');



function Tbx_pop_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_pop as text
%        str2double(get(hObject,'String')) returns contents of Tbx_pop as a double


% --- Executes during object creation, after setting all properties.
function Tbx_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_gen_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_gen as text
%        str2double(get(hObject,'String')) returns contents of Tbx_gen as a double


% --- Executes during object creation, after setting all properties.
function Tbx_gen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
