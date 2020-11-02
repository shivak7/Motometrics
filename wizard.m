function varargout = wizard(varargin)
% WIZARD MATLAB code for wizard.fig
%      WIZARD, by itself, creates a new WIZARD or raises the existing
%      singleton*.
%
%      H = WIZARD returns the handle to a new WIZARD or the handle to
%      the existing singleton*.
%
%      WIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD.M with the given input arguments.
%
%      WIZARD('Property','Value',...) creates a new WIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizard

% Last Modified by GUIDE v2.5 12-Nov-2018 15:54:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizard_OpeningFcn, ...
                   'gui_OutputFcn',  @wizard_OutputFcn, ...
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


% --- Executes just before wizard is made visible.
function wizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizard (see VARARGIN)

% Choose default command line output for wizard
handles.output = hObject;

handles.panel_data_session_params.Visible = 'off';
handles.panel_data_quant_params.Visible = 'off';
handles.pre_string_instruction = sprintf('');
handles.text_instruction.FontSize = 14;

global RunState;
RunState = 0;

handles.State = 0;
State0(hObject, handles);       % Default start is State0

if(exist('last_settings.mat')==2)
    LoadWizardSettings(hObject, handles, 'last_settings.mat')
else
    LoadWizardSettings(hObject, handles, 'default_settings.mat')
end

if(handles.checkbox_line_filter.Value==1)
    handles.popupmenu_harmonics_multiplier.Enable = 'on';
else
    handles.popupmenu_harmonics_multiplier.Enable = 'off';
end
%guidata(hObject,wizard_params);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wizard wait for user response (see UIRESUME)
 uiwait(handles.Wizard);


% --- Outputs from this function are returned to the command line.
function varargout = wizard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

global RunState;
varargout{1} = RunState;

% --- Executes on button press in radio_cortical_stim_only.
function radio_cortical_stim_only_Callback(hObject, eventdata, handles)
% hObject    handle to radio_cortical_stim_only (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_cortical_stim_only


% --- Executes on selection change in popupmenu_data_channel.
function popupmenu_data_channel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_data_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_data_channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_data_channel

function edit_sig_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sig_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sig_start as text
%        str2double(get(hObject,'String')) returns contents of edit_sig_start as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


function edit_sig_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sig_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sig_end as text
%        str2double(get(hObject,'String')) returns contents of edit_sig_end as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


function edit_filter_lower_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filter_lower_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filter_lower_cutoff as text
%        str2double(get(hObject,'String')) returns contents of edit_filter_lower_cutoff as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


function edit_filter_upper_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filter_upper_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filter_upper_cutoff as text
%        str2double(get(hObject,'String')) returns contents of edit_filter_upper_cutoff as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


% --- Executes on button press in checkbox_line_filter.
function checkbox_line_filter_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_line_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(hObject.Value==1)
    handles.popupmenu_harmonics_multiplier.Enable = 'on';
else
    handles.popupmenu_harmonics_multiplier.Enable = 'off';
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_line_filter



function edit_fit_tol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fit_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fit_tol as text
%        str2double(get(hObject,'String')) returns contents of edit_fit_tol as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


function edit_latency_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_latency_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_latency_thresh as text
%        str2double(get(hObject,'String')) returns contents of edit_latency_thresh as a double
str = hObject.String{1};
str = regexp(str,'[+-]?\d+\.?\d*', 'match');
hObject.String{1} = str{1};
guidata(hObject, handles);


% --- Executes on button press in button_back.
function button_back_Callback(hObject, eventdata, handles)
% hObject    handle to button_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateState(handles.State,-1,hObject, handles);

% --- Executes on button press in button_next.
function button_next_Callback(hObject, eventdata, handles)
% hObject    handle to button_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.State <=4)
    UpdateState(handles.State,1,hObject, handles);
else
    global RunState;
    RunState = 1;
    SaveWizardSettings(hObject, handles, 'last_settings.mat')
    %SaveWizardSettings(hObject, handles, 'default_settings.mat')
    uiresume
    delete(handles.Wizard);
end

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume
delete(handles.Wizard);

function SaveWizardSettings(hObject, handles, filename)

params.session_data.stim_type = handles.radio_cortical_stim_only.Value;
params.session_data.data_channel = handles.popupmenu_data_channel.Value;
params.session_data.sig_start = handles.edit_sig_start.String;
params.session_data.sig_end = handles.edit_sig_end.String;
params.session_data.analysis_type = handles.radio_rec_curve.Value;
params.session_data.filter_cutoff_lower = handles.edit_filter_lower_cutoff.String;
params.session_data.filter_cutoff_upper = handles.edit_filter_upper_cutoff.String;
params.session_data.line_notch = handles.checkbox_line_filter.Value;
params.session_data.line_notch_harmonic = handles.popupmenu_harmonics_multiplier.Value;

params.data_quant.fit_tolerance = handles.edit_fit_tol.String;
params.data_quant.latency_thresh = handles.edit_latency_thresh.String;

params.check_run_again = handles.check_run_again.Value;

save(filename,'params');



function LoadWizardSettings(hObject, handles, filename)

load(filename);

handles.radio_cortical_stim_only.Value = params.session_data.stim_type;
handles.popupmenu_data_channel.Value = params.session_data.data_channel;
handles.edit_sig_start.String = params.session_data.sig_start;
handles.edit_sig_end.String = params.session_data.sig_end;
handles.radio_rec_curve.Value = params.session_data.analysis_type;
handles.edit_filter_lower_cutoff.String = params.session_data.filter_cutoff_lower;
handles.edit_filter_upper_cutoff.String = params.session_data.filter_cutoff_upper;
handles.checkbox_line_filter.Value = params.session_data.line_notch;
handles.popupmenu_harmonics_multiplier.Value = params.session_data.line_notch_harmonic;

handles.edit_fit_tol.String = params.data_quant.fit_tolerance;
handles.edit_latency_thresh.String = params.data_quant.latency_thresh;

handles.check_run_again.Value = params.check_run_again;

clear params
guidata(hObject, handles);


function UpdateState(state,step, hObject, handles)

new_state = state + step;
if(new_state<0)
    handles.State = 0;
    new_state = 0;
else
    handles.State = new_state;
end

switch(new_state)
    
    case 0
        State0(hObject, handles); return;
    case 1
        State1(hObject, handles); return;
    case 2
        State2(hObject, handles); return;
    case 3
        State3(hObject, handles); return;
    case 4
        State4(hObject, handles); return;
    case 5
        State5(hObject, handles); return;
        
end

function State0(hObject, handles)

handles.button_back.Enable = 'off';
handles.button_default.Visible = 'off';
handles.button_verify.Visible = 'off';
handles.text_instruction.String = sprintf('%sWelcome to the Motometrics Parameter Wizard.\nThis Wizard will help you select the appropriate parameters for your MEP/Recruitment curve analysis.',handles.pre_string_instruction);
handles.panel_data_quant_params.Visible = 'off';
handles.panel_data_session_params.Visible = 'off';
guidata(hObject, handles);

function State1(hObject, handles)

handles.button_back.Enable = 'on';
handles.button_default.Visible = 'on';
handles.button_verify.Visible = 'off';
handles.text_instruction.String = sprintf('%sIs the data for traditional cortical MEPs OR are there secondary continous stimulations apart from the cortex(For example, to spinal cord or peripheral nerves/muscles)?',handles.pre_string_instruction);
handles.panel_data_quant_params.Visible = 'off';
handles.panel_data_session_params.Visible = 'on';
handles.panel_sig_select.Visible = 'off';
handles.panel_filter_settings.Visible = 'off';
guidata(hObject, handles);


function State2(hObject, handles)

handles.button_default.Visible = 'on';
handles.button_verify.Visible = 'off';
handles.button_back.Enable = 'on';
handles.text_instruction.String = sprintf('%sSelect data channel for MEP extraction.\nAlso provide start and stop times for window in each signal frame.\nFinally, specify if this analysis is for recruitment curves or for direct comparison of quantified MEPs (Single stim values)',handles.pre_string_instruction);
handles.panel_data_quant_params.Visible = 'off';
handles.panel_data_session_params.Visible = 'on';
handles.panel_sig_select.Visible = 'on';
handles.panel_filter_settings.Visible = 'off';
guidata(hObject, handles);

function State3(hObject, handles)

handles.button_default.Visible = 'on';
handles.button_verify.Visible = 'on';
handles.button_back.Enable = 'on';
handles.text_instruction.String = sprintf('%sEnter Lower and Upper cutoff frequency for anti-drift bandpass filter (default: 5-600Hz).\n\nSelect notch filter to remove line noise if needed.\nEnter up to how many line harmonics to remove.',handles.pre_string_instruction);
handles.panel_data_quant_params.Visible = 'off';
handles.panel_data_session_params.Visible = 'on';
handles.panel_sig_select.Visible = 'on';
handles.panel_filter_settings.Visible = 'on';

guidata(hObject, handles);

function State4(hObject, handles)

handles.button_default.Visible = 'on';
handles.button_verify.Visible = 'off';
handles.button_back.Enable = 'on';
handles.text_instruction.String = sprintf('%sEnter curve fitting tolerance (0-1). Lower gives closer fit but may include more outliers.\n\nAlso select latency detection threshold. Default set at 5%% of signal peak.',handles.pre_string_instruction);
handles.panel_data_session_params.Visible = 'off';

temp_position = handles.panel_data_session_params.Position;

handles.panel_data_quant_params.Position(1) = temp_position(1);
%handles.panel_data_quant_params.Position(2) = temp_position(4) - temp_position(2);
%handles.panel_data_quant_params.Position(4) = temp_position(4);
handles.panel_data_quant_params.Visible = 'on';

guidata(hObject, handles);

function State5(hObject, handles)

handles.button_default.Visible = 'off';
handles.button_verify.Visible = 'off';
handles.button_back.Enable = 'on';
handles.text_instruction.String = sprintf('%sMotometrics Parameters have now been configured by the wizard.',handles.pre_string_instruction);

handles.panel_data_session_params.Visible = 'off';
handles.panel_data_quant_params.Visible = 'off';
handles.button_cancel.Visible = 'off';
handles.button_back.Visible = 'off';
handles.button_next.String = 'Done';
guidata(hObject, handles);

% --- Executes when user attempts to close Wizard.
function Wizard_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Wizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume
delete(hObject);


% --- Executes on button press in button_default.
function button_default_Callback(hObject, eventdata, handles)
% hObject    handle to button_default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadWizardSettings(hObject, handles, 'default_settings.mat')


% --- Executes on button press in button_load_sample.
function button_load_sample_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.mat', 'Pick a MotoMetrics recruitment session file');
X = load([pathname filename]);
f = fieldnames(X);
X = getfield(X,f{1});
ch = handles.popupmenu_data_channel.Value;
sig = X.values(:,ch,end);
handles.TestSignal = sig;
handles.TestSignalFs = 1./X.interval;
guidata(hObject, handles);


% --- Executes on button press in button_verify.
function button_verify_Callback(hObject, eventdata, handles)
% hObject    handle to button_verify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles, 'TestSignal'))
    
    sig = handles.TestSignal;
    Fs = handles.TestSignalFs;
    low_cf = str2num(handles.edit_filter_lower_cutoff.String{1});
    up_cf = str2num(handles.edit_filter_upper_cutoff.String{1});
    mep_start = str2num(handles.edit_sig_start.String{1});
    mep_end = str2num(handles.edit_sig_end.String{1});
    
    Wp = [low_cf up_cf]/(Fs/2);
    Ws = [0.2*low_cf 2*up_cf]/(Fs/2);
    Rp = 4; Rs = 30;
    [n, Wn] = buttord(Wp, Ws, Rp, Rs);
    [b,a] = butter(n, Wn);
        
    sig_f = filtfilt(b,a,sig);
    
    if(handles.checkbox_line_filter.Value > 0)
       
        for line_iter = 1:handles.popupmenu_harmonics_multiplier.Value
            
            line_freq = 60 * line_iter;
            
           d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',line_freq - 1,'HalfPowerFrequency2',line_freq + 1, ...
               'DesignMethod','butter','SampleRate',Fs);
           
           sig_f = filtfilt(d,sig_f);
            
        end
        
    end
    
    sig_f = sig_f(mep_start*Fs/1000:mep_end*Fs/1000);
  
    if(~isfield(handles, 'TestFig'))||(~ishandle(handles.TestFig))
        handles.TestFig = figure;       
    end
    
    figure(handles.TestFig);
    T = mep_start:1./(Fs/1000):mep_end;
    plot(T,sig_f);
    xlabel('ms');
    title('Figure for verifying parameter settings');
end
guidata(hObject, handles);