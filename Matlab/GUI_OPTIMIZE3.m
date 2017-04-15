function varargout = GUI_OPTIMIZE3(varargin)
% GUI_OPTIMIZE3 MATLAB code for GUI_OPTIMIZE3.fig
%      GUI_OPTIMIZE3, by itself, creates a new GUI_OPTIMIZE3 or raises the existing
%      singleton*.
%
%      H = GUI_OPTIMIZE3 returns the handle to a new GUI_OPTIMIZE3 or the handle to
%      the existing singleton*.
%
%      GUI_OPTIMIZE3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OPTIMIZE3.M with the given input arguments.
%
%      GUI_OPTIMIZE3('Property','Value',...) creates a new GUI_OPTIMIZE3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OPTIMIZE3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OPTIMIZE3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_OPTIMIZE3

% Last Modified by GUIDE v2.5 31-Oct-2016 21:42:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OPTIMIZE3_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OPTIMIZE3_OutputFcn, ...
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


% --- Executes just before GUI_OPTIMIZE3 is made visible.
function GUI_OPTIMIZE3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_OPTIMIZE3 (see VARARGIN)

% Choose default command line output for GUI_OPTIMIZE3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_OPTIMIZE3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OPTIMIZE3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in List_PSO.
function List_PSO_Callback(hObject, eventdata, handles)
% hObject    handle to List_PSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_PSO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_PSO


% --- Executes during object creation, after setting all properties.
function List_PSO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_PSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_PSO.
function Btn_PSO_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_PSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.List_MOPSO,'string','');
set(handles.List_MOPSO,'value',1);
str_pop=get(handles.Tbx_pop,'String');
nPop=str2double(str_pop);
str_rep=get(handles.Tbx_Rep,'String');
nRep=str2double(str_rep);
str_maxit=get(handles.Tbx_MaxIt,'String');
MaxIt=str2double(str_maxit);
[costs,rep_costs]=mopso(nPop,nRep,MaxIt);
axes(handles.Fig_MOPSO);
plot(rep_costs(1,:),rep_costs(2,:),'rx','linewidth',10);
legend('Main Population','Repository');
str=get(handles.List_MOPSO,'string');
val=get(handles.List_MOPSO,'value');
for i=1:nPop
    str_new=strcat('第',num2str(i),'个最优解');
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_MOPSO,'string',str);
    set(handles.List_MOPSO,'value',val);
    
    str_new='目标函数：';
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_MOPSO,'string',str);
    set(handles.List_MOPSO,'value',val);
    
    str_new=strcat(num2str(rep_costs(1,i)),',',num2str(rep_costs(2,i)));
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_MOPSO,'string',str);
    set(handles.List_MOPSO,'value',val);
    
    str_new='        ';
    str_new=cellstr(str_new);
    str=[str;str_new];  
    set(handles.List_MOPSO,'string',str);
    set(handles.List_MOPSO,'value',val);
end




% --- Executes on button press in Btn_back.
function Btn_back_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_OPTIMIZE1');



% --- Executes on selection change in List_MOPSO.
function List_MOPSO_Callback(hObject, eventdata, handles)
% hObject    handle to List_MOPSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_MOPSO contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_MOPSO


% --- Executes during object creation, after setting all properties.
function List_MOPSO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_MOPSO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function Tbx_Rep_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_Rep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_Rep as text
%        str2double(get(hObject,'String')) returns contents of Tbx_Rep as a double


% --- Executes during object creation, after setting all properties.
function Tbx_Rep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_Rep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tbx_MaxIt_Callback(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxIt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tbx_MaxIt as text
%        str2double(get(hObject,'String')) returns contents of Tbx_MaxIt as a double


% --- Executes during object creation, after setting all properties.
function Tbx_MaxIt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tbx_MaxIt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
