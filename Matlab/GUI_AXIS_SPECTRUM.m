function varargout = GUI_AXIS_SPECTRUM(varargin)
% GUI_AXIS_SPECTRUM MATLAB code for GUI_AXIS_SPECTRUM.fig
%      GUI_AXIS_SPECTRUM, by itself, creates a new GUI_AXIS_SPECTRUM or raises the existing
%      singleton*.
%
%      H = GUI_AXIS_SPECTRUM returns the handle to a new GUI_AXIS_SPECTRUM or the handle to
%      the existing singleton*.
%
%      GUI_AXIS_SPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_AXIS_SPECTRUM.M with the given input arguments.
%
%      GUI_AXIS_SPECTRUM('Property','Value',...) creates a new GUI_AXIS_SPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_AXIS_SPECTRUM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_AXIS_SPECTRUM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_AXIS_SPECTRUM

% Last Modified by GUIDE v2.5 30-Oct-2016 21:53:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_AXIS_SPECTRUM_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_AXIS_SPECTRUM_OutputFcn, ...
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


% --- Executes just before GUI_AXIS_SPECTRUM is made visible.
function GUI_AXIS_SPECTRUM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_AXIS_SPECTRUM (see VARARGIN)

% Choose default command line output for GUI_AXIS_SPECTRUM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_AXIS_SPECTRUM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_AXIS_SPECTRUM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Btn_import_xz.
function Btn_import_xz_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_import_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
[filename,pathname,filterindex] = uigetfile({'*.csv';'*.csv';'*.*'},'导入csv文件');
if filterindex
    filename=strcat(pathname,filename);
    inputdata=csvread(filename); 
    data{1}=inputdata(:,1)';
    load('Hd_2.mat')
    data{1}=filter(Hd_2,data{1});
    data{1}=Waveletthresholdx(data{1},11,'db9','minimaxi','newthr');
end


% --- Executes on button press in Btn_output_xz_mean.
function Btn_output_xz_mean_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_output_xz_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mx  
[filename, pathname, filterindex] = uiputfile( ...
{'*.xlsx', 'Excel文件';...
},...
 'Save as');
name=strcat(pathname,filename);
data=mx{1};
xlswrite(name,data);

% --- Executes on button press in Btn_next.
function Btn_next_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_MATRIX_INTEGRATE');


% --- Executes on button press in Btn_import_cj.
function Btn_import_cj_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_import_cj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data
[filename,pathname,filterindex] = uigetfile({'*.csv';'*.csv';'*.*'},'导入csv文件');
if filterindex
    filename=strcat(pathname,filename);
    inputdata=csvread(filename); 
    data{2}=inputdata(:,1)';
    load('Hd_2.mat')
    data{1}=filter(Hd_2,data{2});
    data{2}=Waveletthresholdx(data{2},11,'db9','minimaxi','newthr');
end

% --- Executes on button press in Btn_output_cj_ampl.
function Btn_output_cj_ampl_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_output_cj_ampl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ax  
[filename, pathname, filterindex] = uiputfile( ...
{'*.xlsx', 'Excel文件';...
},...
 'Save as');
name=strcat(pathname,filename);
data=ax{2};
xlswrite(name,data);

% --- Executes on button press in Btn_rain.
function Btn_rain_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_rain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data ax mx matrix_m
for i = 1:2
    [ampl_x{i},ampl_y{i},mean_x{i},mean_y{i},matrix_m{i},matrix_x{i},matrix_y{i}]=rainflowx(data{i});
end
axes(handles.Fig_ampl_xz)
bar(ampl_y{1},ampl_x{1},1);
grid on
axis tight
xlabel('幅值(N*m)')
ylabel('频次')
axes(handles.Fig_mean_xz)
bar(mean_y{1},mean_x{1},1);
grid on
axis tight
xlabel('均值(N*m)')
ylabel('频次')
axes(handles.Fig_matrix_xz)
bar3(matrix_y{1},matrix_m{1},1);
grid on
axis tight
xlabel('幅值(N*m)')
ylabel('均值(N*m)')
zlabel('频次')
axes(handles.Fig_ampl_cj)
bar(ampl_y{2},ampl_x{2},1);
grid on
axis tight
xlabel('幅值(N*m)')
ylabel('频次')
axes(handles.Fig_mean_cj)
bar(mean_y{2},mean_x{2},1);
grid on
axis tight
xlabel('均值(N*m)')
ylabel('频次')
axes(handles.Fig_matrix_cj)
bar3(matrix_y{2},matrix_m{2},1);
grid on
axis tight
xlabel('幅值(N*m)')
ylabel('均值(N*m)')
zlabel('频次')
mean_y{1}=mean_y{1}';
mx{1}=[];
for i=1:length(mean_y{1})
    y=[];
    for j = 1:int32(mean_x{1}(i))
        y=[y,mean_y{1}(i)];
    end
    mx{1}=[mx{1},y];
end
mx{1}=mx{1}';

ax{1}=[];
for i=1:length(ampl_y{1})
    y1=[];
    for j = 1:int32(ampl_x{1}(i))
        y1=[y1,ampl_y{1}(i)];
    end
    ax{1}=[ax{1},y1];
end
ax{1}=ax{1}';

mean_y{2}=mean_y{2}';
mx{2}=[];
for i=1:length(mean_y{2})
    y=[];
    for j = 1:int32(mean_x{2}(i))
        y=[y,mean_y{2}(i)];
    end
    mx{2}=[mx{2},y];
end
mx{2}=mx{2}';

ax{2}=[];
for i=1:length(ampl_y{2})
    y1=[];
    for j = 1:int32(ampl_x{2}(i))
        y1=[y1,ampl_y{2}(i)];
    end
    ax{2}=[ax{2},y1];
end
ax{2}=ax{2}';


% --- Executes on button press in Btn_output_cj_mean.
function Btn_output_cj_mean_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_output_cj_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mx  
[filename, pathname, filterindex] = uiputfile( ...
{'*.xlsx', 'Excel文件';...
},...
 'Save as');
name=strcat(pathname,filename);
data=mx{2};
xlswrite(name,data);

% --- Executes on button press in Btn_output_xz_ampl.
function Btn_output_xz_ampl_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_output_xz_ampl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ax  
[filename, pathname, filterindex] = uiputfile( ...
{'*.xlsx', 'Excel文件';...
},...
 'Save as');
name=strcat(pathname,filename);
data=ax{1};
xlswrite(name,data);


% --- Executes on button press in Btn_back.
function Btn_back_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'visible','off');
eval('GUI_MAIN');


% --- Executes on button press in Btn_clear.
function Btn_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data ax mx matrix_m
data=[];
ax=[];
mx=[];
matrix_m=[];
axes(handles.Fig_mean_xz) ;
cla reset
axes(handles.Fig_mean_cj) ;
cla reset
axes(handles.Fig_matrix_cj) ;
cla reset
axes(handles.Fig_matrix_xz) ;
cla reset
axes(handles.Fig_ampl_cj) ;
cla reset
axes(handles.Fig_ampl_xz) ;
cla reset
