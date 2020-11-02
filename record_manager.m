function varargout = record_manager(varargin)
% RECORD_MANAGER MATLAB code for record_manager.fig
%      RECORD_MANAGER, by itself, creates a new RECORD_MANAGER or raises the existing
%      singleton*.
%
%      H = RECORD_MANAGER returns the handle to a new RECORD_MANAGER or the handle to
%      the existing singleton*.
%
%      RECORD_MANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECORD_MANAGER.M with the given input arguments.
%
%      RECORD_MANAGER('Property','Value',...) creates a new RECORD_MANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before record_manager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to record_manager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help record_manager

% Last Modified by GUIDE v2.5 16-Mar-2017 16:10:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @record_manager_OpeningFcn, ...
                   'gui_OutputFcn',  @record_manager_OutputFcn, ...
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


% --- Executes just before record_manager is made visible.
function record_manager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to record_manager (see VARARGIN)

% Choose default command line output for record_manager
handles.output = hObject;

handles.table_session.Data(2:end,:) = [];
handles.table_session.RowName(2:end) = [];
handles.BeginSession = 0;
handles.CurIndex = 0;
handles.ReadySave = 0;
handles.file_list.String = '';
handles.file_list.Value = 1;
handles.Spacer = '                       ';
handles.Map = [];
handles.list_session_file.String{1} = ['Session Number' handles.Spacer 'File'];
handles.list_session_file.String(2) = [];
% handles.tree_root = uitreenode('root', 'Root', [], false);
% handles.tree = uitree('Root', handles.tree_root);
% set(handles.tree, 'Units', 'normalized', 'position', [0.04 0.07 0.425 0.84]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes record_manager wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = record_manager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output; 


% --- Executes on button press in button_increment_session.
function button_increment_session_Callback(hObject, eventdata, handles)
% hObject    handle to button_increment_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end
if(handles.check_replicate_session.Value==0)
    
    handles.CurIndex = handles.CurIndex + 1;
    handles.Record.SessionNum = num2str(str2num(handles.table_session.Data{handles.CurIndex-1,1}) + 1);
    handles.Record.Stim = (handles.edit_stim_start.String);
    handles.Record.Trials = (handles.edit_trials.String);

    handles.table_session.Data(handles.CurIndex,:) = {handles.Record.SessionNum, handles.Record.Stim, handles.Record.Trials};
    guidata(hObject, handles);

    handles.Map(numel(handles.Map)+1).SessionNumber = str2num(handles.Record.SessionNum);
    handles.Map(numel(handles.Map)).FileName = 'MissingFile';
    handles.Map(numel(handles.Map)).PathName = '';

    handles.list_session_file.String{numel(handles.list_session_file.String) + 1} = [num2str(handles.Map(numel(handles.Map)).SessionNumber) handles.Spacer handles.Spacer handles.Map(numel(handles.Map)).FileName];
else
   
     all_sessions = cellfun(@str2num, handles.table_session.Data(:,1)); %cell2mat(handles.table_session.Data(:,1));
     last_session = all_sessions(end);
     idx = find(all_sessions==last_session);
     handles.CurIndex = handles.CurIndex + 1;

     handles.table_session.Data(handles.CurIndex:handles.CurIndex+length(idx)-1,1) = cellstr(num2str((last_session + 1).*ones(length(idx),1)));
     handles.table_session.Data(handles.CurIndex:handles.CurIndex+length(idx)-1,2:end) = handles.table_session.Data(idx(1):idx(end),2:end);
     handles.CurIndex = handles.CurIndex + length(idx)-1;

     handles.Map(numel(handles.Map)+1).SessionNumber = (last_session + 1);
     handles.Map(numel(handles.Map)).FileName = 'MissingFile';
     handles.Map(numel(handles.Map)).PathName = '';

     handles.list_session_file.String{numel(handles.list_session_file.String) + 1} = [num2str(handles.Map(numel(handles.Map)).SessionNumber) handles.Spacer handles.Spacer handles.Map(numel(handles.Map)).FileName];
end
guidata(hObject, handles);

% --- Executes on button press in button_Begin_Session.
function button_Begin_Session_Callback(hObject, eventdata, handles)
% hObject    handle to button_Begin_Session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.BeginSession ~= 0)
    return          %Do nothing if session has started
else
    handles.BeginSession = 1;
end
%handles.table_session.ColumnEditable = [true true true];
handles.CurIndex = 1;
handles.Record.SessionNum = (handles.edit_session.String);
handles.Record.Stim = (handles.edit_stim_start.String);
handles.Record.Trials = (handles.edit_trials.String);
handles.table_session.Data(handles.CurIndex,:) = {handles.Record.SessionNum, handles.Record.Stim, handles.Record.Trials};

handles.Map(1).SessionNumber = str2num(handles.Record.SessionNum);
handles.Map(1).FileName = 'MissingFile';
handles.Map(1).PathName = '';

handles.list_session_file.String{numel(handles.list_session_file.String) + 1} = [num2str(handles.Map(1).SessionNumber) handles.Spacer handles.Spacer handles.Map(1).FileName];
guidata(hObject, handles);

    

% --- Executes on button press in button_increment_stim.
function button_increment_stim_Callback(hObject, eventdata, handles)
% hObject    handle to button_increment_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.BeginSession == 0)
    button_Begin_Session_Callback(handles.button_Begin_Session, eventdata, handles)
    return          %Do nothing if session has NOT started
end
handles.CurIndex = handles.CurIndex + 1;

handles.Record.SessionNum = handles.table_session.Data{handles.CurIndex-1,1};
handles.Record.Stim = num2str(str2num(handles.table_session.Data{handles.CurIndex-1,2}) + str2num(handles.edit_stim_step.String));
handles.Record.Trials = (handles.edit_trials.String);
handles.table_session.Data(handles.CurIndex,:) = {handles.Record.SessionNum, handles.Record.Stim, handles.Record.Trials};

guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in table_session.
function table_session_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table_session (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if(~isempty(eventdata.Indices))
    handles.CurrentSelection = eventdata.Indices;
end
guidata(hObject, handles);


% --- Executes on button press in button_del_row.
function button_del_row_Callback(hObject, eventdata, handles)
% hObject    handle to button_del_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end

handles = delete_rows(handles);
guidata(hObject, handles); 


% --- Executes on button press in button_del_content.
function button_del_content_Callback(hObject, eventdata, handles)
% hObject    handle to button_del_content (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end
handles.table_session.Data(handles.CurrentSelection(:,1),handles.CurrentSelection(:,2)) = {''};
guidata(hObject, handles);


% --- Executes on button press in button_insert.
function button_insert_Callback(hObject, eventdata, handles)
% hObject    handle to button_insert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end
lower_data = handles.table_session.Data(handles.CurrentSelection(1,1):end,:);
handles.table_session.Data(handles.CurrentSelection(1,1),:)={'','',''};
handles.table_session.Data = [handles.table_session.Data(1:handles.CurrentSelection(1,1),:); lower_data];
guidata(hObject, handles);

% --- Executes on key press with focus on table_session and none of its controls.
function table_session_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to table_session (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end

if(strcmp(eventdata.Key,'backspace'))               
    for i = 1:size(handles.CurrentSelection,1)
        old_data = handles.table_session.Data{handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)};
        if(~isempty(old_data))
            old_data(end) = [];
        end
        new_data= (old_data);
        handles.table_session.Data(handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)) = {(new_data)};
    end
end

if((strcmp(eventdata.Key,'delete'))&& (isempty(eventdata.Modifier))&&(~isempty(handles.CurrentSelection)))
    button_del_content_Callback(handles.button_del_content, eventdata, handles)

elseif((strcmp(eventdata.Key,'delete'))&& (strcmp(eventdata.Modifier,'alt'))&&(~isempty(handles.CurrentSelection)))
   if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
   end
   handles = delete_rows(handles);
elseif((strcmp(eventdata.Key,'insert'))&& (isempty(eventdata.Modifier))&&(~isempty(handles.CurrentSelection)))
   button_insert_Callback(handles.button_insert, eventdata, handles)
    
elseif(~isempty(str2num(eventdata.Key))) 
    for i = 1:size(handles.CurrentSelection,1)
        old_data = handles.table_session.Data{handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)};
        new_data= [(old_data) eventdata.Key];
        handles.table_session.Data(handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)) = {(new_data)};
    end
elseif(strcmp(eventdata.Key,'period'))
    for i = 1:size(handles.CurrentSelection,1)
        old_data = handles.table_session.Data{handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)};
        if(~isempty(strfind((old_data),'.')))
            continue
        end
        new_data= [old_data '.'];
        handles.table_session.Data(handles.CurrentSelection(i,1),handles.CurrentSelection(i,2)) = {(new_data)};
        
    end
end
 guidata(hObject, handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if(strcmp(eventdata.Key,'n') && (isempty(eventdata.Modifier)))
    button_increment_stim_Callback(handles.table_session, eventdata, handles);
elseif(strcmp(eventdata.Key,'n') && (strcmp(eventdata.Modifier,'alt')))
    button_increment_session_Callback(handles.table_session, eventdata, handles)
end


% --- Executes on selection change in list_session_file.
function list_session_file_Callback(hObject, eventdata, handles)
% hObject    handle to list_session_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_session_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_session_file
get(handles.figure1,'SelectionType');
% If double click

if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.list_session_file,'Value');
    
    if(index_selected > 1)
        %[files] = uipickfiles('num',numel(handles.Map),'out','cell','Filter','*.mat','Prompt','Select data files IN SAME ORDER as sessions specified in list');
        [filename, pathname, filterindex] = uigetfile('*.mat', 'Pick an Excel file which specifies matlab data','MultiSelect', 'on');
        if(iscell(filename))
            j = 1;
            %keyboard
            for i = index_selected - 1: index_selected - 1 + min(numel(handles.Map) - index_selected + 1,numel(filename)-1)
                handles.Map(i).FileName = filename{j};
                handles.Map(i).PathName = pathname;
                handles.list_session_file.String{i+1} = [num2str(handles.Map(i).SessionNumber) handles.Spacer handles.Spacer handles.Map(i).FileName];
                j = j + 1;
            end
        elseif(isstr(filename))
                handles.Map(index_selected - 1).FileName = filename;
                handles.Map(index_selected - 1).PathName = pathname;
                handles.list_session_file.String{index_selected} = [num2str(handles.Map(index_selected - 1).SessionNumber) handles.Spacer handles.Spacer handles.Map(index_selected - 1).FileName];
        end
        
    end
    
end
guidata(hObject, handles);


% --- Executes on button press in button_update.
function button_update_Callback(hObject, eventdata, handles)
% hObject    handle to button_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = update_check(handles);
guidata(hObject, handles);




% --- Executes on button press in button_save_all. 
function button_save_all_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = update_check(handles);

if(handles.ReadySave==1)
    
  SessionMat = cell2mat(cellfun(@str2num, handles.table_session.Data,'un',0));
  SessionFiles = handles.Map;
  
  [filename, pathname] = uiputfile( ...
       '*.mat', ...
        'Save Session Group');
   if(filename~=0)
    save([pathname filename],'SessionMat','SessionFiles');
   end
end
handles.ReadySave = 0;
guidata(hObject, handles);

% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
       '*.mat', ...
        'Load Session Group');

if(~filename)
    return
end
load([pathname filename]);

Cmat = cellfun(@num2str,mat2cell(SessionMat, ones(1,size(SessionMat,1)), ones(1,size(SessionMat,2))),'UniformOutput',0);    %Convert from matrix to cell matrix

handles.Map = SessionFiles;
handles.table_session.Data = Cmat;
handles.CurIndex = size(SessionMat,1);
handles.CurrentSelection = [];
handles.BeginSession = 1;

for i = 1:numel(SessionFiles)
    handles.list_session_file.String{i+1} = [num2str(handles.Map(i).SessionNumber) handles.Spacer handles.Spacer handles.Map(i).FileName];
end
guidata(hObject, handles);


% --- Executes on button press in button_convert.
function button_convert_Callback(hObject, eventdata, handles)
% hObject    handle to button_convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile({'*.xls;*.xlsx'}, 'Pick a legacy group session file');
SessionMat = xlsread([pathname filename]);

Cmat = cellfun(@num2str,mat2cell(SessionMat, ones(1,size(SessionMat,1)), ones(1,size(SessionMat,2))),'UniformOutput',0);    %Convert from matrix to cell matrix

handles.table_session.Data = Cmat;
handles.CurIndex = size(SessionMat,1);
handles.BeginSession = 1;
all_sessions = unique(SessionMat(:,1),'stable');

for i = 1:numel(all_sessions)
    handles.Map(i).SessionNumber = all_sessions(i);
    handles.Map(i).FileName = 'MissingFile';
    handles.Map(i).PathName = '';
    
    handles.list_session_file.String{i+1} = [num2str(handles.Map(i).SessionNumber) handles.Spacer handles.Spacer handles.Map(i).FileName];
end

guidata(hObject, handles);




% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Map = [];
handles.table_session.Data = {'','',''};
handles.CurIndex = 0;
handles.CurrentSelection = [];
handles.BeginSession = 0;
handles.ReadySave = 0;
handles.list_session_file.String{1} = ['Session Number' handles.Spacer 'File'];
handles.list_session_file.Value = 1;
if(numel(handles.list_session_file.String)>1)
    handles.list_session_file.String(2:end) = [];
end
guidata(hObject, handles);
