function varargout = master_file_create(varargin)
% MASTER_FILE_CREATE MATLAB code for master_file_create.fig
%      MASTER_FILE_CREATE, by itself, creates a new MASTER_FILE_CREATE or raises the existing
%      singleton*.
%
%      H = MASTER_FILE_CREATE returns the handle to a new MASTER_FILE_CREATE or the handle to
%      the existing singleton*.
%
%      MASTER_FILE_CREATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASTER_FILE_CREATE.M with the given input arguments.
%
%      MASTER_FILE_CREATE('Property','Value',...) creates a new MASTER_FILE_CREATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before master_file_create_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to master_file_create_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help master_file_create

% Last Modified by GUIDE v2.5 19-Jun-2017 15:53:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @master_file_create_OpeningFcn, ...
                   'gui_OutputFcn',  @master_file_create_OutputFcn, ...
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


% --- Executes just before master_file_create is made visible.
function master_file_create_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to master_file_create (see VARARGIN)

% Choose default command line output for master_file_create
handles.output = hObject;
handles.FileData = [];
handles.FileCounter = 0;
handles.file_list.String = '';
handles.file_list.Value = 1;
handles.listbox1.String{1} = 'File List';
handles.listbox1.String(2) = [];
handles.legacy_mode = varargin{1};

if(handles.legacy_mode)
   handles.button_add_file.String = 'Add legacy record file (.xls,.xlsx)';
else
    handles.button_add_file.String = 'Add record file (.mat)';
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes master_file_create wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = master_file_create_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_add_file.
function button_add_file_Callback(hObject, eventdata, handles)
% hObject    handle to button_add_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.legacy_mode)
    [filename, pathname, filterindex] = uigetfile({'*.xls;*.xlsx'}, 'Pick an Excel file which specifies sessions');
else
     [filename, pathname, filterindex] = uigetfile('*.mat', 'Pick a Mat file which specifies session files');
end

if((filename~=0))
    
    if(handles.legacy_mode)
        [file_date] = get_date();
    else
        file_date = '00000000';
    end
    
    if((~isempty(str2num(file_date)))&(length(file_date)==8))
        handles.FileCounter = handles.FileCounter + 1;
        [~,filename,~] = fileparts(filename);
        handles.FileData(handles.FileCounter).filename = filename;
        handles.FileData(handles.FileCounter).pathname = pathname;
        handles.FileData(handles.FileCounter).file_date = file_date;
        if(handles.legacy_mode)
            handles.listbox1.String{handles.FileCounter} = [file_date '   ' filename];
        else
            handles.listbox1.String{handles.FileCounter} = [filename];
        end
        drawnow
    else
    
        h = warndlg('Incorrect date format! Enter 6 numbers ONLY as: YYYYMMDD');
    end
end

guidata(hObject, handles);


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.legacy_mode)
    [filename, pathname] = uiputfile( ...
           {'*.xlsx;*.xls'}, ...
            'Save as');
else
     [filename, pathname] = uiputfile( ...
           '*.mat', ...
            'Save as');
end

 for i = 1: handles.FileCounter
    
    
    sheet_str1 = ['A' num2str(i)];
    sheet_str2 = ['B' num2str(i)];
    xdata1 = {[handles.FileData(i).pathname handles.FileData(i).filename]};
    xdata2 = {handles.FileData(i).file_date};
    if(handles.legacy_mode)
        xlswrite([pathname filename],xdata1,1,sheet_str1);
        xlswrite([pathname filename],xdata2,1,sheet_str2);
    end
    session_files_list{i} = [handles.FileData(i).pathname handles.FileData(i).filename];
 end
 
 if(~handles.legacy_mode)
     save([pathname filename],'session_files_list');
 end
 
    

    

% --- Executes on button press in button_remove.
function button_remove_Callback(hObject, eventdata, handles)
% hObject    handle to button_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index = handles.listbox1.Value;

if(((handles.FileCounter > 0)&&(~strcmp(handles.listbox1.String{index},'File List'))))
    handles.FileData(index) = [];
    handles.listbox1.String(index) = [];
    handles.FileCounter = handles.FileCounter - 1;
    handles.listbox1.Value = handles.listbox1.Value - 1;
    
    if(handles.listbox1.Value==0)
        handles.listbox1.Value = 1;
    end
    
    if(handles.FileCounter==0)
       handles.listbox1.String{1} = 'File List';
       handles.listbox1.Value = 1;
    end
    
    drawnow
end


guidata(hObject, handles);

% --- Executes on button press in button_close.
function button_close_Callback(hObject, eventdata, handles)
% hObject    handle to button_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);

% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = '';

if(handles.FileCounter>0)
    
    choice = questdlg('Do you wish to MERGE new file with current list OR CLEAR current selection?', ...
	'WARNING!', ...
	'Merge','Clear','Cancel','Cancel');

    if(strcmp(choice,'Cancel'))
        return;
    end
end

if(handles.legacy_mode)
    [filename, pathname] = uigetfile( ...
           {'*.xlsx;*.xls'}, ...
            'Open');
    if(filename==0)
         return
    end
    [num, txt,raw] = xlsread([pathname filename]);
    fields = {'file','date'};
    Master = cell2struct(raw,fields,2);

else
    [filename, pathname] = uigetfile( ...
           '*.mat', ...
            'Open');
     if(filename==0)
         return
     end
     load([pathname filename]);
     Master = cell2struct(session_files_list,{'file'});
end
    
if(strcmp(choice,'Clear'))
    handles.FileCounter = 0;
    handles.FileData = [];
    handles.listbox1.String = '';
    handles.listbox1.Value = 1;
end

for i = 1:numel(Master)

    handles.FileCounter = handles.FileCounter + 1;
    [pathname,filename,~] = fileparts(Master(i).file);
    handles.FileData(handles.FileCounter).filename = filename;
    handles.FileData(handles.FileCounter).pathname = [pathname filesep];
    if(handles.legacy_mode)
        handles.FileData(handles.FileCounter).file_date = num2str(Master(i).date);
        handles.listbox1.String{handles.FileCounter} = [num2str(Master(i).date) '   ' filename];
    else
        handles.FileData(handles.FileCounter).file_date = '';
        handles.listbox1.String{handles.FileCounter} = [filename];
    end
    drawnow
end
    
guidata(hObject, handles);    
