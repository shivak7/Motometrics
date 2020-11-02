function varargout = get_date(varargin)
% GET_DATE MATLAB code for get_date.fig
%      GET_DATE, by itself, creates a new GET_DATE or raises the existing
%      singleton*.
%
%      H = GET_DATE returns the handle to a new GET_DATE or the handle to
%      the existing singleton*.
%
%      GET_DATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GET_DATE.M with the given input arguments.
%
%      GET_DATE('Property','Value',...) creates a new GET_DATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before get_date_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to get_date_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help get_date

% Last Modified by GUIDE v2.5 07-Oct-2016 14:06:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @get_date_OpeningFcn, ...
                   'gui_OutputFcn',  @get_date_OutputFcn, ...
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


% --- Executes just before get_date is made visible.
function get_date_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to get_date (see VARARGIN)

% Choose default command line output for get_date
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uicontrol(handles.edit1);
% UIWAIT makes get_date wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = get_date_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
if(~isempty(handles))
    varargout{1} = handles.edit1.String;
    delete(handles.figure1);
    delete(hObject);
else
    varargout{1}='';
end




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_done.
function button_done_Callback(hObject, eventdata, handles)
% hObject    handle to button_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume();
