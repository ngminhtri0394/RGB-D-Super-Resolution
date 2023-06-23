function varargout = GUI_pcl(varargin)
% GUI_PCL MATLAB code for GUI_pcl.fig
%      GUI_PCL, by itself, creates a new GUI_PCL or raises the existing
%      singleton*.
%
%      H = GUI_PCL returns the handle to a new GUI_PCL or the handle to
%      the existing singleton*.
%
%      GUI_PCL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PCL.M with the given input arguments.
%
%      GUI_PCL('Property','Value',...) creates a new GUI_PCL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_pcl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_pcl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_pcl

% Last Modified by GUIDE v2.5 08-Jul-2016 05:16:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_pcl_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_pcl_OutputFcn, ...
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


% --- Executes just before GUI_pcl is made visible.
function GUI_pcl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_pcl (see VARARGIN)

% Choose default command line output for GUI_pcl
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_pcl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_pcl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_rgb.
function pb_rgb_Callback(hObject, eventdata, handles)
% hObject    handle to pb_rgb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
{  '*.tif','Image TIF format (*.tif)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Choose images', ...
   'MultiSelect', 'off');
set(handles.text_rgb,'String',filename)
handles.rgbfile = filename;
handles.rgbfull = fullfile(pathname, filename);
guidata(hObject,handles)

% --- Executes on button press in pb_depth.
function pb_depth_Callback(hObject, eventdata, handles)
% hObject    handle to pb_depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile( ...
{  '*.tif','Image TIF format (*.tif)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Choose images', ...
   'MultiSelect', 'off');
set(handles.text_depth,'String',filename)
handles.depthfile = filename;
handles.depthfull = fullfile(pathname, filename);
guidata(hObject,handles)


function edit_focal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_focal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_focal as text
%        str2double(get(hObject,'String')) returns contents of edit_focal as a double


% --- Executes during object creation, after setting all properties.
function edit_focal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_focal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_df_Callback(hObject, eventdata, handles)
% hObject    handle to edit_df (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_df as text
%        str2double(get(hObject,'String')) returns contents of edit_df as a double


% --- Executes during object creation, after setting all properties.
function edit_df_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_df (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_create.
function pb_create_Callback(hObject, eventdata, handles)
% hObject    handle to pb_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
focal = get(handles.edit_focal,'String');
if size(focal,2) == 0
    h = msgbox('Please enter focal length','Error');
    return
end
focal = str2num(focal);
df = get(handles.edit_df,'String');
if size(df,2) == 0
    h = msgbox('Please enter depth factor','Error');
    return
end
df = str2num(df);
ws = get(handles.edit_ws,'String');
if size(ws,2) == 0
    h = msgbox('Please enter window size','Error');
    return
end
ws = str2num(ws);
al = get(handles.edit_al,'String');
if size(al,2) == 0
    h = msgbox('Please enter alpha','Error');
    return
end
al = str2num(al);
rgbfile = handles.rgbfull;
if size(rgbfile,2) == 0
    h = msgbox('Please enter rgb data','Error');
    return
end
depthfile = handles.depthfull;
if size(depthfile,2) == 0
    h = msgbox('Please enter depth data','Error');
    return
end
scale = get(handles.pum_sf, 'Value');
if scale == 3
    scale = 4;
end

GUI_pcl_data(rgbfile,depthfile,focal,df,scale,ws,al);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pum_sf.
function pum_sf_Callback(hObject, eventdata, handles)
% hObject    handle to pum_sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pum_sf contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pum_sf


% --- Executes during object creation, after setting all properties.
function pum_sf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pum_sf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ws_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ws as text
%        str2double(get(hObject,'String')) returns contents of edit_ws as a double


% --- Executes during object creation, after setting all properties.
function edit_ws_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_al_Callback(hObject, eventdata, handles)
% hObject    handle to edit_al (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_al as text
%        str2double(get(hObject,'String')) returns contents of edit_al as a double


% --- Executes during object creation, after setting all properties.
function edit_al_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_al (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
