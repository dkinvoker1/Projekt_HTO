function varargout = VIS_IR_GUI(varargin)
% VIS_IR_GUI MATLAB code for VIS_IR_GUI.fig
%      VIS_IR_GUI, by itself, creates a new VIS_IR_GUI or raises the existing
%      singleton*.
%
%      H = VIS_IR_GUI returns the handle to a new VIS_IR_GUI or the handle to
%      the existing singleton*.
%
%      VIS_IR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIS_IR_GUI.M with the given input arguments.
%
%      VIS_IR_GUI('Property','Value',...) creates a new VIS_IR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VIS_IR_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VIS_IR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VIS_IR_GUI

% Last Modified by GUIDE v2.5 07-May-2018 03:26:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VIS_IR_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @VIS_IR_GUI_OutputFcn, ...
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


% --- Executes just before VIS_IR_GUI is made visible.
function VIS_IR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VIS_IR_GUI (see VARARGIN)

% Choose default command line output for VIS_IR_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VIS_IR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VIS_IR_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global VIS IR mode
% mode='vis->ir'; %szybsze
mode='ir->vis';

set(handles.btnTyl,'Visible','off');
set(handles.btnPrzod,'Visible','off');
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axes3,'Visible','off');
set(handles.text2,'String', 'Wczytaj obrazy VIS oraz IR');

% --- Executes on button press in btnSeriaVIS.
function btnSeriaVIS_Callback(hObject, eventdata, handles)
% hObject    handle to btnSeriaVIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VIS 
selpath = uigetdir(path);
s = strcat(selpath,'\*.jpg');
VIS = dir (s);
VIS=struct2cell(VIS);
VIS=VIS(1,:);
s=s(1:end-5);
VIS= strcat(s,VIS);

axes(handles.axes1);
IM_VIS{1} = imread(VIS{1})
imshow(IM_VIS{1});
set(handles.text2,'String', 'Wczytano seriê VIS');

% --- Executes on button press in btnSeriaIR.
function btnSeriaIR_Callback(hObject, eventdata, handles)
% hObject    handle to btnSeriaIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IR
selpath = uigetdir(path);
s = strcat(selpath,'\*.png');
IR = dir (s);
IR=struct2cell(IR);
IR=IR(1,:);
s=s(1:end-5);
IR= strcat(s,IR);

axes(handles.axes2);
IM_IR{1} = imread(IR{1});
imshow(IM_IR{1});
set(handles.text2,'String', 'Wczytano seriê IR');

% --- Executes on button press in btnPunkty.
% function btnPunkty_Callback(hObject, eventdata, handles)
% % hObject    handle to btnPunkty (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global VIS IR t_concord
% set(handles.btnPunkty,'Visible','off');
% 
% [movingPoints,fixedPoints] =cpselect(IR{1},VIS{1},'Wait',true);
% save('Points.mat','movingPoints','fixedPoints')
% 
% t_concord = fitgeotrans(movingPoints,fixedPoints,'projective'); %projective to liczba punktów
% set(handles.text2,'String', 'Zapisano nowe punkty');

% --- Executes on button press in btnWczytaj.
function btnWczytaj_Callback(hObject, eventdata, handles)
% hObject    handle to btnWczytaj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_concord
load('SetPoints.mat')
t_concord = fitgeotrans(movingPoints,fixedPoints,'projective'); %projective to liczba punktów
set(handles.text2,'String', 'Wczytano poprzednie punkty zapisane w pliku Points.mat');

% --- Executes on button press in btnFuzja.
function btnFuzja_Callback(hObject, eventdata, handles)
% hObject    handle to btnFuzja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VIS IR mode t_concord IM_VIS IM_IR i max fused
max=size(VIS,2);
% max=1;
h = waitbar(0,'Proszê czekaæ');
for i=1:max
% for i=1:2
    if mode=='vis->ir'
        IM_IR{i} = imread(IR{i});
        IM_VIS{i} = imread(VIS{i});
        IM_VIS{i} = imresize(IM_VIS{i},[240 320]);
    else if mode=='ir->vis'
        IM_VIS{i} = imread(VIS{i});
        IM_IR{i} = imread(IR{i});
        IM_IR{i} = imresize(IM_IR{i},[3264 4896]);
        end
    end
    
    Rfixed = imref2d(size(IM_VIS{i}));
    registered = imwarp(IM_IR{i},t_concord,'OutputView',Rfixed);
    
    fused{i} = imfuse(IM_VIS{i},registered,'blend');
    waitbar(i/max,h)
end
axes(handles.axes3);
imshow(fused{1})

close(h)
set(handles.btnTyl,'Visible','on');
set(handles.btnPrzod,'Visible','on');
set(handles.text2,'String', 'Dostosowano serie');


% --- Executes on button press in btnTyl.
function btnTyl_Callback(hObject, eventdata, handles)
% hObject    handle to btnTyl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_VIS IM_IR t_concord i fused
% set(handles.axes1,'Visible','off');
% set(handles.text2,'String', 'Wykonywanie fuzji...');
if (i-1<=0)
    i = 1;
else
    i = i-1;
end

axes(handles.axes1);
imshow(IM_VIS{i});
axes(handles.axes2);
imshow(IM_IR{i});

% Rfixed = imref2d(size(IM_VIS{i}));
% fused = imwarp(IM_IR{i},t_concord,'OutputView',Rfixed);
% obj = imshowpair(IM_VIS{i},fused,'blend')
axes(handles.axes3);
imshow(fused{i})
% axes(handles.axes2);
% imshow(obj);
set(handles.text2,'String', 'Wynik fuzji');

% --- Executes on button press in btnPrzod.
function btnPrzod_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrzod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IM_VIS IM_IR t_concord i max fused
% set(handles.axes1,'Visible','off');
% set(handles.text2,'String', 'Wykonywanie fuzji...');
if (i+1>=max)
    i = max;
else
    i = i+1;
end

axes(handles.axes1);
imshow(IM_VIS{i});
axes(handles.axes2);
imshow(IM_IR{i});

% Rfixed = imref2d(size(IM_VIS{i}));
% fused = imwarp(IM_IR{i},t_concord,'OutputView',Rfixed);
% obj = imshowpair(IM_VIS{i},fused,'blend')
axes(handles.axes3);
imshow(fused{i})
% axes(handles.axes2);
% imshow(obj);
set(handles.text2,'String', 'Wynik fuzji');
