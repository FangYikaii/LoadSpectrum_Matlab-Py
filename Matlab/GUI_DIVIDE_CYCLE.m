function varargout = GUI_DIVIDE_CYCLE(varargin)
% GUI_DIVIDE_CYCLE MATLAB code for GUI_DIVIDE_CYCLE.fig
%      GUI_DIVIDE_CYCLE, by itself, creates a new GUI_DIVIDE_CYCLE or raises the existing
%      singleton*.
%
%      H = GUI_DIVIDE_CYCLE returns the handle to a new GUI_DIVIDE_CYCLE or the handle to
%      the existing singleton*.
%
%      GUI_DIVIDE_CYCLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DIVIDE_CYCLE.M with the given input arguments.
%
%      GUI_DIVIDE_CYCLE('Property','Value',...) creates a new GUI_DIVIDE_CYCLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_DIVIDE_CYCLE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_DIVIDE_CYCLE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_DIVIDE_CYCLE

% Last Modified by GUIDE v2.5 31-Oct-2016 10:24:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_DIVIDE_CYCLE_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_DIVIDE_CYCLE_OutputFcn, ...
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


% --- Executes just before GUI_DIVIDE_CYCLE is made visible.
function GUI_DIVIDE_CYCLE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_DIVIDE_CYCLE (see VARARGIN)

% Choose default command line output for GUI_DIVIDE_CYCLE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_DIVIDE_CYCLE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_DIVIDE_CYCLE_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in Btn_import_part.
function Btn_import_part_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_import_part (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_import_part
path_import_part = uigetdir;

% --- Executes on button press in Btn_select_part.
function Btn_select_part_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_select_part (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_select_part
path_select_part= uigetdir;

% --- Executes on button press in Btn_do_part.
function Btn_do_part_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_do_part (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_import_part path_select_part
val_part_driver=get(handles.menu_part_driver,'value');
val_part_power=get(handles.menu_part_power,'value');
val_part_object=get(handles.menu_part_object,'value');
DoExtractCycle(path_import_part,path_select_part,val_part_driver,val_part_power,val_part_object);

% --- Executes on button press in Btn_import_cycle.
function Btn_import_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_import_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_import_cycle
path_import_cycle = uigetdir;

% --- Executes on button press in Btn_select_cycle.
function Btn_select_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_select_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_select_cycle
path_select_cycle= uigetdir;

% --- Executes on button press in Btn_do_cycle.
function Btn_do_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_do_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path_import_cycle path_select_cycle
val_cycle_driver=get(handles.menu_cycle_driver,'value');
val_cycle_power=get(handles.menu_cycle_power,'value');
val_cycle_object=get(handles.menu_cycle_object,'value');
DoCycle(path_import_cycle,path_select_cycle,val_cycle_driver,val_cycle_power,val_cycle_object);


% --- Executes on selection change in menu_cycle_object.
function menu_cycle_object_Callback(hObject, eventdata, handles)
% hObject    handle to menu_cycle_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_cycle_object contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_cycle_object


% --- Executes during object creation, after setting all properties.
function menu_cycle_object_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_cycle_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_cycle_driver.
function menu_cycle_driver_Callback(hObject, eventdata, handles)
% hObject    handle to menu_cycle_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_cycle_driver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_cycle_driver


% --- Executes during object creation, after setting all properties.
function menu_cycle_driver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_cycle_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_cycle_power.
function menu_cycle_power_Callback(hObject, eventdata, handles)
% hObject    handle to menu_cycle_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_cycle_power contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_cycle_power


% --- Executes during object creation, after setting all properties.
function menu_cycle_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_cycle_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_part_object.
function menu_part_object_Callback(hObject, eventdata, handles)
% hObject    handle to menu_part_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_part_object contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_part_object


% --- Executes during object creation, after setting all properties.
function menu_part_object_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_part_object (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_part_driver.
function menu_part_driver_Callback(hObject, eventdata, handles)
% hObject    handle to menu_part_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_part_driver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_part_driver


% --- Executes during object creation, after setting all properties.
function menu_part_driver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_part_driver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_part_power.
function menu_part_power_Callback(hObject, eventdata, handles)
% hObject    handle to menu_part_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_part_power contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_part_power


% --- Executes during object creation, after setting all properties.
function menu_part_power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_part_power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Btn_do_part_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Btn_do_part (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
