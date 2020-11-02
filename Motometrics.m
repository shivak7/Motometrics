%Mercurial steps:
% 1.) hg add
% 2.) hg tag <version increment>
% 3.) hg commit
% 4.) hg push

function varargout = Motometrics(varargin)
% MOTOMETRICS MATLAB code for Motometrics.fig
%      MOTOMETRICS, by itself, creates a new MOTOMETRICS or raises the existing
%      singleton*.
%
%      H = MOTOMETRICS returns the handle to a new MOTOMETRICS or the handle to
%      the existing singleton*.
%
%      MOTOMETRICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTOMETRICS.M with the given input arguments.
%
%      MOTOMETRICS('Property','Value',...) creates a new MOTOMETRICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Motometrics_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Motometrics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Motometrics

% Last Modified by GUIDE v2.5 30-Mar-2018 10:01:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Motometrics_OpeningFcn, ...
    'gui_OutputFcn',  @Motometrics_OutputFcn, ...
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

function LoadWizardParameters(hObject,handles)
    
wzfn = 'last_settings.mat';
if(exist(wzfn)==2)
    load(wzfn);
elseif(exist('default_settings.mat')==2)
    load('default_settings.mat');
end

handles.edit_start_time.String = params.session_data.sig_start;
handles.edit_stop_time.String = params.session_data.sig_end;
handles.popup_channel.Value = params.session_data.data_channel;
handles.radio_rec.Value = params.session_data.analysis_type;
handles.edit_filter_lower.String = params.session_data.filter_cutoff_lower;
handles.edit_filter_upper.String = params.session_data.filter_cutoff_upper;
handles.check_line_notch.Value = params.session_data.line_notch;
handles.popup_line_level.Value = params.session_data.line_notch_harmonic;
handles.edit_thresh.String = params.data_quant.latency_thresh;
handles.edit_fit_tol.String = params.data_quant.fit_tolerance;
guidata(hObject, handles);


% --- Executes just before Motometrics is made visible.
function Motometrics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Motometrics (see VARARGIN)

% Choose default command line output for Motometrics
%handles.init_labels = {'BL','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
addpath(pwd);
handles.init_labels = {'BL'};

handles.list_term = '-------------------------------------------------------------';
handles.file_list.Enable = 'off';

handles.edit_filter_lower.Enable = 'off';
handles.edit_filter_upper.Enable = 'off';
    
handles.output = hObject;
handles.OverLord_counter = 0; % Number of current combinations
handles.OverLord = [];  %Main variable that tracks various masters (for multiple combinations)
handles.list_tracker = []; %Keep track of number of experiment combinations per Overlord session
handles.OverLord(1).Master = []; % Variable that tracks individual experiments

handles.radio_rms.Value = 1;
handles.check_rectify.Value = 0;

handles.check_10mep.Value = 0;
handles.check_50mep.Value = 1;
handles.check_90mep.Value = 0;
handles.check_custom_mep.Value = 0;

handles.check_slope.Value = 1;
handles.check_50stim.Value = 1;
handles.check_custom_stim.Value = 0;
% Update handles structure

wzfn = 'last_settings.mat';
if(exist(wzfn)==2)
    load(wzfn);
    if(params.check_run_again==1)
        wizard;
    end
else
    wizard;
end

LoadWizardParameters(hObject,handles)

guidata(hObject, handles);

% UIWAIT makes Motometrics wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Motometrics_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [proc_select] = get_proc_selection(handles)

proc_select.channel = handles.popup_channel.Value;
proc_select.bl_filter = handles.check_baseline_filter.Value;
proc_select.start_time = str2num(handles.edit_start_time.String{1});
proc_select.stop_time = str2num(handles.edit_stop_time.String{1});
proc_select.filter_cutoff_lower = str2num(handles.edit_filter_lower.String{1});
proc_select.filter_cutoff_upper = str2num(handles.edit_filter_upper.String{1});
proc_select.line_filter = handles.check_line_notch.Value;
proc_select.line_multiplier = handles.popup_line_level.Value;

% --- Executes on button press in button_load_single.
function button_load_single_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.mat','Load single record','MultiSelect','off');
val_ret = validate_session_path(filename,pathname);
if(filename==0)   %If user canceled selection, leave function.
    return;
end

if(val_ret==0)   %If user canceled selection, leave function.
    return;
end


handles.OverLord_counter = handles.OverLord_counter + 1; %Increment counter by 1
ovl_count = handles.OverLord_counter;
handles.OverLord(ovl_count).mainfile = filename;

disp('Reading file entry.. ')

if(ovl_count == 1) %first loading
    handles.file_list.String = [];
end

if(handles.OverLord_counter>1)
    handles.file_list.String{end+1} = handles.list_term;
end

handles.file_list.String{end+1} = 'Loading... Please wait';
drawnow

handles.OverLord(ovl_count).Master(1).file = [pathname filename];
handles.OverLord(ovl_count).Master(1).date = '';

handles.file_list.Enable = 'on';

list_length = numel(handles.file_list.String) - 1; % -1 to get rid of loading message
handles.list_tracker = [handles.list_tracker numel(handles.OverLord(ovl_count).Master)];

[pathstr,t_fname,ext] = fileparts(handles.OverLord(ovl_count).Master(1).file);
if(isempty(pathstr)==1)
    pathstr = pathname;
end

handles.OverLord(ovl_count).Master(1).file = t_fname;
handles.OverLord(ovl_count).Master(1).path = pathstr;
handles.file_list.String{list_length + 1} = handles.OverLord(ovl_count).Master(1).file;
file_info = load([handles.OverLord(ovl_count).Master(1).path filesep handles.OverLord(ovl_count).Master(1).file]);
exp_files = (unique(file_info.SessionMat(:,1),'stable'));

curr_table_labels = [];
curr_table_labels = 'BL';

for j = 1:numel(exp_files)
    
    SessionFileOrder = [file_info.SessionFiles(:).SessionNumber];
    Fidx = find(SessionFileOrder == exp_files(j));
    
    if(j>1)
        temp_label_str = ['C' num2str(j-1)];
        curr_table_labels = [curr_table_labels ',' temp_label_str];
    end
    [ActPath,file_info.SessionFiles(Fidx).FileName,~] = fileparts(file_info.SessionFiles(Fidx).FileName);
    
    handles.OverLord(ovl_count).Master(1).expt(j).file = [file_info.SessionFiles(Fidx).PathName file_info.SessionFiles(Fidx).FileName]; %Set subfilenames in current Master
    
    handles.OverLord(ovl_count).Master(1).expt(j).subfile = exp_files(j);
    handles.OverLord(ovl_count).Master(1).expt(j).start_msec = 258; %Start time to extract EMG signal
    handles.OverLord(ovl_count).Master(1).expt(j).end_msec = 272;   %End time for extraction of EMG signal
    handles.OverLord(ovl_count).Master(1).expt(j).active_channel = 1;   %recording channel for data
    handles.OverLord(ovl_count).Master(1).expt(j).bl_filter = 0;    % Whether baseline filter should be used
    handles.OverLord(ovl_count).Master(1).expt(j).Fs = 5000;    %Sampling frequency
    
    handles.OverLord(ovl_count).Master(1).processed = 0;
    
    idx = find(file_info.SessionMat(:,1)==exp_files(j));
    handles.OverLord(ovl_count).Master(1).expt(j).stim_vals = file_info.SessionMat(idx,2);
    handles.OverLord(ovl_count).Master(1).expt(j).frame_vals = file_info.SessionMat(idx,3);
    
end

proc_select = get_proc_selection(handles);
handles.OverLord(ovl_count).Master(1) = nonlegacy_b_emg_analyze(handles.OverLord(ovl_count).Master(1),proc_select);

handles.table_label.Data{ovl_count,1} = curr_table_labels;

%handles.file_list.String{end+1} = handles.list_term;
guidata(hObject, handles);


% --- Executes on button press in load_master.
function load_master_Callback(hObject, eventdata, handles)
% hObject    handle to load_master (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.check_legacy.Value==1)
    [filename, pathname] = uigetfile('*.xlsx','Load FileNum_StimIntensity_Frames','MultiSelect','off');
    
else
    [filename, pathname] = uigetfile('*.mat','Load single session file','MultiSelect','off');
    ret = validate_master_path(filename, pathname);
    if(~ret)
        return
    end
    ret = validate_batch_session_paths(filename, pathname);
    %%IMPORTANT! UNCOMMENT LINE ABOVE
    if(~ret)
        return
    end
end

if(filename==0)   %If user cancelled selection, leave function.
    return;
end

handles.OverLord_counter = handles.OverLord_counter + 1; %Increment counter by 1
ovl_count = handles.OverLord_counter;
handles.OverLord(ovl_count).mainfile = filename;

disp('Reading file entry.. ')

if(ovl_count == 1) %first loading
    handles.file_list.String = [];
end

if(handles.OverLord_counter>1)
    handles.file_list.String{end+1} = handles.list_term;
end

handles.file_list.String{end+1} = 'Loading... Please wait';
drawnow
if(handles.check_legacy.Value==1)
    [num, txt,raw] = xlsread([pathname filename]);  %WE WILL DISCARD MASTER PATHNAME AND INSTEAD USE FILENAME WITH pathstr TO FIND TRUE PATH
    fields = {'file','date'};
    handles.OverLord(ovl_count).Master = cell2struct(raw,fields,2);
else
    load([pathname filename]);  % Non-legacy : Files will be stored in session_file_lists
    for i = 1:numel(session_files_list)
        handles.OverLord(ovl_count).Master(i).file = session_files_list{i};
        handles.OverLord(ovl_count).Master(i).date = '';
    end
    
end

handles.file_list.Enable = 'on';

list_length = numel(handles.file_list.String) - 1; % -1 to get rid of loading message
handles.list_tracker = [handles.list_tracker numel(handles.OverLord(ovl_count).Master)];

for i = 1:numel(handles.OverLord(ovl_count).Master)
    
    [pathstr,t_fname,ext] = fileparts(handles.OverLord(ovl_count).Master(i).file);
    if(isempty(pathstr)==1)
        pathstr = pathname;
    end
    
    handles.OverLord(ovl_count).Master(i).file = t_fname;
    handles.OverLord(ovl_count).Master(i).path = pathstr;
    handles.file_list.String{list_length + i} = handles.OverLord(ovl_count).Master(i).file;
    
    if(handles.check_legacy.Value==1)
        file_info = xlsread([handles.OverLord(ovl_count).Master(i).path filesep handles.OverLord(ovl_count).Master(i).file]);
        exp_files = (unique(file_info(:,1),'stable'));
    else
        file_info = load([handles.OverLord(ovl_count).Master(i).path filesep handles.OverLord(ovl_count).Master(i).file]);
        exp_files = (unique(file_info.SessionMat(:,1),'stable'));
    end
    % Default values assumed
    curr_table_labels = 'BL';
    
    for j = 1:numel(exp_files)
        
        SessionFileOrder = [file_info.SessionFiles(:).SessionNumber];
        Fidx = find(SessionFileOrder == exp_files(j));
        
        if(j>1)
            temp_label_str = ['C' num2str(j-1)];
            curr_table_labels = [curr_table_labels ',' temp_label_str];
        end
        
        if(handles.check_legacy.Value==1)
            handles.OverLord(ovl_count).Master(i).expt(j).file = [num2str(handles.OverLord(ovl_count).Master(i).date) '_' sprintf('%03g',exp_files(j))]; %Set subfilenames in current Master
        else
            [ActPath,ExpFileName,~] = fileparts(file_info.SessionFiles(Fidx).FileName);
            handles.OverLord(ovl_count).Master(i).expt(j).file = [file_info.SessionFiles(Fidx).PathName ExpFileName]; %Set subfilenames in current Master
        end
               
        handles.OverLord(ovl_count).Master(i).expt(j).subfile = exp_files(j);
        handles.OverLord(ovl_count).Master(i).expt(j).start_msec = 258; %Start time to extract EMG signal
        handles.OverLord(ovl_count).Master(i).expt(j).end_msec = 272;   %End time for extraction of EMG signal
        handles.OverLord(ovl_count).Master(i).expt(j).active_channel = 1;   %recording channel for data
        handles.OverLord(ovl_count).Master(i).expt(j).bl_filter = 0;    % Whether baseline filter should be used
        handles.OverLord(ovl_count).Master(i).expt(j).Fs = 5000;    %Sampling frequency
        
        handles.OverLord(ovl_count).Master(i).processed = 0;
        
        if(handles.check_legacy.Value==1)
            idx = find(file_info(:,1)==exp_files(j));
            handles.OverLord(ovl_count).Master(i).expt(j).stim_vals = file_info(idx,2);
            handles.OverLord(ovl_count).Master(i).expt(j).frame_vals = file_info(idx,3);
        else
            idx = find(file_info.SessionMat(:,1)==exp_files(j));
            handles.OverLord(ovl_count).Master(i).expt(j).stim_vals = file_info.SessionMat(idx,2);
            handles.OverLord(ovl_count).Master(i).expt(j).frame_vals = file_info.SessionMat(idx,3);
        end
        
    end
    
    proc_select = get_proc_selection(handles);
    
    if(handles.check_legacy.Value==1)
        handles.OverLord(ovl_count).Master(i) = b_emg_analyze(handles.OverLord(ovl_count).Master(i),proc_select);
    else
        handles.OverLord(ovl_count).Master(i) = nonlegacy_b_emg_analyze(handles.OverLord(ovl_count).Master(i),proc_select);
    end
    
end

handles.table_label.Data{ovl_count,1} = curr_table_labels;
handles.check_legacy.Enable = 'off';
%handles.file_list.String{end+1} = handles.list_term;
guidata(hObject, handles);

function [feat_select] = get_feat_selection(handles)

% EMG features
feat_select.rms = handles.radio_rms.Value;
feat_select.peak = handles.radio_peak.Value;
feat_select.latency = handles.radio_latency.Value;
feat_select.latency_thresh = str2num(handles.edit_thresh.String{1});
feat_select.auc = handles.radio_auc.Value;
feat_select.rectify = handles.check_rectify.Value;

%Recruitment curve evaluation features
feat_select.mep10 = handles.check_10mep.Value;
feat_select.mep50 = handles.check_50mep.Value;
feat_select.mep90 = handles.check_90mep.Value;
feat_select.custom_mep = handles.check_custom_mep.Value;
feat_select.custom_mep_value = str2num(handles.edit_custom_mep.String);
feat_select.slope = handles.check_slope.Value;
feat_select.slope_raw = handles.check_slope_raw.Value;
feat_select.stim50 = handles.check_50stim.Value;
feat_select.custom_stim = handles.check_custom_stim.Value;
feat_select.custom_stim_value = str2num(handles.edit_custom_stim.String);
feat_select.gen_rec_curve = handles.radio_rec.Value;
feat_select.fit_tolerance = str2num(handles.edit_fit_tol.String{1});


% --- Executes on button press in process_button.
function process_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
feat_select = get_feat_selection(handles);
for i = 1:handles.OverLord_counter
    for j = 1:numel(handles.OverLord(i).Master)
        handles.OverLord(i).Master(j) = feat_process(handles.OverLord(i).Master(j),feat_select);
        handles.OverLord(i).Master(j).processed = 1;
    end
    
       
    if(feat_select.gen_rec_curve==1)
        if(feat_select.latency == 0)
            [handles.OverLord(i).Master handles.OverLord(i).X handles.OverLord(i).Y] = combine_batch(handles.OverLord(i).Master);
            [handles.OverLord(i).rec_bar handles.OverLord(i).rec_type handles.OverLord(i).rec_cut] = recruit_feat_process(handles.OverLord(i), feat_select);
        end
        
    else
        if(feat_select.latency == 0)
            [handles.OverLord(i).rec_bar] = raw_feat_process(handles.OverLord(i).Master, feat_select);
        else
            errordlg('Latency feature only available in Recruitment curve mode');
        end
        %keyboard
    end
    
end
toc
guidata(hObject, handles);

% --- Executes on selection change in file_list.
function file_list_Callback(hObject, eventdata, handles)
% hObject    handle to file_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns file_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from file_list
get(handles.figure1,'SelectionType');
% If double click
ovl_count = handles.OverLord_counter;

if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.file_list,'Value');
    linear_index = index_selected;    %linear index to file list
    list_counter = 1;
    sub_index  = linear_index - numel(handles.OverLord(list_counter).Master);
    
    while(sub_index>0)
        list_counter = list_counter + 1;
        sub_index  = sub_index - numel(handles.OverLord(list_counter).Master)-1;
    end
    
    selected_overlord = list_counter;
    selected_file_num = numel(handles.OverLord(list_counter).Master) + sub_index;
    
    if(selected_file_num>0)
        tickLabels = split(',',handles.table_label.Data{list_counter});
        handles.OverLord(selected_overlord).Master(selected_file_num).file
        proc_select = get_proc_selection(handles);
        handles.OverLord(selected_overlord).Master(selected_file_num) = process_single_master(handles.OverLord(selected_overlord).Master(selected_file_num),tickLabels,handles.check_legacy.Value,handles.radio_rec.Value, handles.radio_latency.Value, proc_select);
    else
        disp('Invalid file selected');
    end
    
end
guidata(hObject, handles);



function generate_raw_figures(handles)

colormap(jet(1024));
color_index         = colormap;
colors              = size(color_index,1);

fig_dir = 0;
if(handles.check_save_figs.Value)
    fig_dir = uigetdir('','Specify directory in which to save figures.');
end

for i = 1:numel(handles.OverLord)
    
    tickLabels = split(',',handles.table_label.Data{i});
    tickLabels = tickLabels';
    useMap_all          = [];
    num_exp = numel(handles.OverLord(i).Master(1).expt);
    
    for j = 1: num_exp
        useMap          = ((j-1) * round(colors/num_exp)) + 1;
        useMap_all      = [useMap_all;color_index(useMap,:)];
        %tickPositions(j)= (0.83*j*(1/(num_exp +1)) )+ 0.585;
        tickPositions(j)= (0.85*j*(1/(num_exp +1)) )+ 0.575;
    end
    bw_colormap = useMap_all;
    gridstatus  = 0;
    figure; set(gcf,'color','w');

    err_temp = cellfun(@(x) std(x)/sqrt(length(x)), handles.OverLord(i).rec_bar);%std(handles.OverLord(i).rec_bar,0,2)./sqrt(length(handles.OverLord(i).rec_bar));
    barweb(cellfun(@mean, handles.OverLord(i).rec_bar),err_temp,[],[],[],[],[],bw_colormap,gridstatus);
    set(gca,'fontweight','bold','fontsize',16,'LineWidth',2);
    set(gcf,'color','w')
    
    colormap(useMap_all);
    set(gca,'XTick',tickPositions,'Xticklabel',tickLabels);
        
    ylabel('MEP % of no spinal stim');
    if(fig_dir)
        [~,master_name,~] = fileparts(handles.OverLord(i).mainfile);
        file2 = [master_name];
        %print(bf(k),'-dpng',[fig_dir filesep file2 '.png'],'-r300');
        export_fig([fig_dir filesep file2 '.png'],'-r900')
    end
    
end


function generate_latency_figures(handles)
FontSize = 24;

    for i = 1: handles.OverLord_counter
        tickLabels = split(',',handles.table_label.Data{1});
               
        for k = 1:numel(handles.OverLord(i).Master)
            figure('Name',handles.OverLord(i).Master(k).file,'NumberTitle','off')
            num_curves = numel(handles.OverLord(i).Master(k).expt);
            for j = 1:num_curves

                X = handles.OverLord(i).Master(k).expt(j).stim_vals;
                Y = handles.OverLord(i).Master(k).expt(j).Post_Data;

                subplot(1,num_curves,j);
                plot(X,Y,'r.','MarkerSize',20);
                hold on
                plot(X,Y,'--','MarkerSize',20,'LineWidth',2);
                hold off

                set(gca,'fontsize',FontSize,'fontweight','bold','LineWidth',2);
                ylabel('Mean Latency (ms)');
                xlabel('Stim Intensity');
                %title([handles.OverLord(i).Master(k).file ' (' tickLabels{j} ')'], 'Interpreter', 'none');
                title(tickLabels{j}, 'Interpreter', 'none');
                
            end
           
        end
        
    end

% --- Executes on button press in generate_figures.
function generate_figures_Callback(hObject, eventdata, handles)
% hObject    handle to generate_figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.radio_rec.Value~=1)      %If we are doing non-recruitment curve analysis, run generate_raw and skip this function
    generate_raw_figures(handles);
    return
end

if(handles.radio_latency.Value==1)
    generate_latency_figures(handles);
    return;
end

if(handles.OverLord(1).Master(1).processed==0)
    errordlg('Please click "process data files" before generating analysis');
    return;
end

colormap(jet(1024));
color_index         = colormap;
colors              = size(color_index,1);

fig_dir = 0;
if(handles.check_save_figs.Value)
    fig_dir = uigetdir('','Specify directory in which to save figures.');
end
FontSize = 24;

for i = 1:handles.OverLord_counter
    
    useMap_all          = [];
    f1(i)= figure; set(gcf,'color','w');
    num_curves = numel(handles.OverLord(i).Master(1).expt);
    num_exp = numel(handles.OverLord(i).Master);
    
    tickLabels = split(',',handles.table_label.Data{i});
    tickPositions = [];
    
    for j = 1: num_curves
        useMap          = ((j-1) * round(colors/num_curves)) + 1;
        useMap_all      = [useMap_all;color_index(useMap,:)];
        %tickPositions(j)= (j*(1/(num_curves +1)) )+ 0.5;
         tickPositions(j)= (0.85*j*(1/(num_exp +1)) )+ 0.575;
        hold on;
        plot(handles.OverLord(i).X,handles.OverLord(i).Y(j,:),'color',[color_index(useMap,:)],'linewidth',2);
    end
    set(gca,'fontsize',FontSize,'fontweight','bold','LineWidth',2);
    %ylabel(['Baseline MEP % for ' handles.OverLord(i).Master(1).expt(1).feat_choice]);xlabel('Stimulus Intensity (% mA of Baseline)')
    colormap(useMap_all)
    cb = lcolorbar(tickLabels);
    bw_colormap = useMap_all;
    gridstatus  = 0;
    set(cb,'FontSize',FontSize,'FontWeight','Bold','LineWidth',2);
    
    if(fig_dir)
        [~,master_name,~] = fileparts(handles.OverLord(i).mainfile);
        file1 = [master_name '_S_curves'];
        %print(f1(i),'-dpng',[fig_dir filesep file1 '.png'],'-r600');
        %pause
        export_fig([fig_dir filesep file1 '.png'],'-r900', f1(i))
    end
    
    for k = 1:numel(handles.OverLord(i).rec_bar)
        bf(k) = figure; set(gcf,'color','w');
        curr_bar = handles.OverLord(i).rec_bar{k};
        err_temp = std(curr_bar)./sqrt(num_exp);
        
        if(handles.check_relative.Value)
            ref_val = 100;
        else
            ref_val = 0;
        end
        
        if(size(curr_bar,1)==1)
            barweb(real(curr_bar) - ref_val,zeros(1,length(curr_bar)),[],[],[],[],[],bw_colormap,gridstatus);
        else
            barweb(mean(real(curr_bar)) - ref_val,err_temp,[],[],[],[],[],bw_colormap,gridstatus);
        end
        %set(gca,'ylim',[90 (max(curr_bar)+10)]);
        set(gca,'fontweight','bold','fontsize',FontSize,'LineWidth',2);
        set(gcf,'color','w')
        
        if(strcmp(handles.OverLord(i).rec_type{k},'stim'))
            %ylabel('MEP Relative to Baseline Curve(%)');
            %title(['MEP evoked by Stim Intensity at ' num2str(handles.OverLord(i).rec_cut{k}) '% Baseline MEP']);
        elseif (strcmp(handles.OverLord(i).rec_type{k},'mep'))
            %ylabel('Stim Intensity Relative to Baseline Curve(%)')
            %title(['Stim Intensity Required to Evoke' num2str(handles.OverLord(i).rec_cut{k}) '% Baseline MEP'])
        elseif(strcmp(handles.OverLord(i).rec_type{k},'slope'))
            %ylabel('Gain of MEP vs Stim (%)');
            %title('Slope of recruitment curves');
        end
        colormap(useMap_all);
        
        set(gca,'XTick',tickPositions,'Xticklabel',tickLabels);
        
        if(fig_dir)
            [~,master_name,~] = fileparts(handles.OverLord(i).mainfile);
            file2 = [master_name '_' handles.OverLord(i).rec_type{k} num2str(handles.OverLord(i).rec_cut{k})];
            %print(bf(k),'-dpng',[fig_dir filesep file2 '.png'],'-r600');
            pause
            export_fig([fig_dir filesep file2 '.png'],'-r900', bf(k))
        end
    end
    
end
if(fig_dir)
    close(f1(:));
    close(bf(:));
end

% --- Executes on selection change in popup_channel.
function popup_channel_Callback(hObject, eventdata, handles)
% hObject    handle to popup_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_channel


% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% hObject    handle to button_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear handles.OverLord
handles.OverLord = [];
handles.file_list.Enable = 'off';
handles.check_legacy.Enable = 'on';
handles.OverLord_counter = 0; % Number of current combinations
handles.OverLord = [];  %Main variable that tracks various masters (for multiple combinations)
handles.list_tracker = []; %Keep track of number of experiment combinations per Overlord session
handles.OverLord(1).Master = []; % Variable that tracks individual experiments
handles.file_list.String = '';
handles.file_list.Value = 1;
handles.file_list.String{1} = 'File list';

handles.table_label.Data{1,1} = 'BL,A,B';
N = numel(handles.table_label.Data);
if(N>1)
    handles.table_label.Data(2:N) = [];
end

guidata(hObject, handles);


% --- Executes on button press in button_create_MasterFile.
function button_create_MasterFile_Callback(hObject, eventdata, handles)
% hObject    handle to button_create_MasterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

master_file_create(handles.check_legacy.Value);


% --- Executes on button press in check_legacy.
function check_legacy_Callback(hObject, eventdata, handles)
% hObject    handle to check_legacy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_legacy

legacy_mode = get(hObject,'Value');

if(legacy_mode==1)
    handles.button_session_manager.Enable = 'off';
    handles.button_load_single.Enable = 'off';
else
    handles.button_session_manager.Enable = 'on';
    handles.button_load_single.Enable = 'on';
end

guidata(hObject, handles);

% --- Executes on button press in button_session_manager.
function button_session_manager_Callback(hObject, eventdata, handles)
% hObject    handle to button_session_manager (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
record_manager();


% --- Executes on button press in button_save_data.
function button_save_data_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

feat_select = get_feat_selection(handles);
for i = 1:handles.OverLord_counter
    num_curves = numel(handles.OverLord(i).Master(1).expt);
    num_exp = numel(handles.OverLord(i).Master);
    
    if(feat_select.gen_rec_curve==1)
        if(feat_select.latency==0)
            for k = 1:numel(handles.OverLord(i).rec_bar)
                curr_bar = handles.OverLord(i).rec_bar{k};
                err_temp = std(curr_bar)./sqrt(num_exp);


                if(handles.check_relative.Value)
                    ref_val = 100;
                else
                    ref_val = 0;
                end

                if(size(curr_bar,1)==1)
                    Motometric_Analyzed_Data(i).Rec_Metrics(k).bar_data = curr_bar - ref_val;
                else
                    Motometric_Analyzed_Data(i).Rec_Metrics(k).bar_data = mean(real(curr_bar)) - ref_val;
                end

                Motometric_Analyzed_Data(i).Rec_Metrics(k).bar_error = err_temp;
            end
            Motometric_Analyzed_Data(i).MetricType = handles.OverLord(i).rec_type;
            Motometric_Analyzed_Data(i).Metric_CutOff = handles.OverLord(i).rec_cut;
            
            
        else %If Latency metric was saved
            for j = 1:numel(handles.OverLord(i).Master)
                for l = 1:numel(handles.OverLord(i).Master(j).expt)
                    Motometric_Analyzed_Data(i).Master(j).Expt(l).Latency = handles.OverLord(i).Master(j).expt(l).Post_Data;
                end
            end
            Motometric_Analyzed_Data(i).MetricType = 'latency';
        end
    else
        Motometric_Analyzed_Data(i).Rec_Metrics.bar_data = handles.OverLord(i).rec_bar;
        Motometric_Analyzed_Data(i).Rec_Metrics.bar_error = NaN;
    end
    
end

uisave('Motometric_Analyzed_Data');


% --- Executes on button press in check_line_notch.
function check_line_notch_Callback(hObject, eventdata, handles)
% hObject    handle to check_line_notch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_line_notch

if(hObject.Value==1)
    handles.popup_line_level.Enable = 'on';
else
    handles.popup_line_level.Enable = 'off';
end
guidata(hObject, handles);


% --- Executes on button press in button_wizard.
function button_wizard_Callback(hObject, eventdata, handles)
% hObject    handle to button_wizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = wizard;

if(out==1)
    LoadWizardParameters(hObject.Parent.Parent.Parent,handles);
end


% --- Executes on button press in check_baseline_filter.
function check_baseline_filter_Callback(hObject, eventdata, handles)
% hObject    handle to check_baseline_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_baseline_filter
if(hObject.Value==1)
    handles.edit_filter_lower.Enable = 'on';
    handles.edit_filter_upper.Enable = 'on';
else
    handles.edit_filter_lower.Enable = 'off';
    handles.edit_filter_upper.Enable = 'off';
end


% --------------------------------------------------------------------
function tool_new_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tool_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tool_save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tool_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tool_run_data_segmentor_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tool_run_data_segmentor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tool_open_master_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tool_open_master (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tool_open_record_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tool_open_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in button_save_qmeps.
function button_save_qmeps_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_qmeps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i = 1:handles.OverLord_counter
    Motometric_Data(i).File = handles.OverLord(i).mainfile;
    
    for j = 1:numel(handles.OverLord(i).Master)
        Motometric_Data(i).Record(j).File = handles.OverLord(i).Master(j).file;
        
        for k = 1:numel(handles.OverLord(i).Master(j).expt)             
             Motometric_Data(i).Record(j).Expt(k).File = handles.OverLord(i).Master(j).expt(k).file;
             Motometric_Data(i).Record(j).Expt(k).Start_msec = handles.OverLord(i).Master(j).expt(k).start_msec;
             Motometric_Data(i).Record(j).Expt(k).End_msec = handles.OverLord(i).Master(j).expt(k).end_msec;
             Motometric_Data(i).Record(j).Expt(k).Analysis_channel = handles.OverLord(i).Master(j).expt(k).active_channel;
             Motometric_Data(i).Record(j).Expt(k).Filtered = handles.OverLord(i).Master(j).expt(k).bl_filter;
             Motometric_Data(i).Record(j).Expt(k).Sampling_Freq = handles.OverLord(i).Master(j).expt(k).Fs;
             Motometric_Data(i).Record(j).Expt(k).Stim_Range = handles.OverLord(i).Master(j).expt(k).stim_vals;
             Motometric_Data(i).Record(j).Expt(k).Trials_per_stim = handles.OverLord(i).Master(j).expt(k).frame_vals;
             Motometric_Data(i).Record(j).Expt(k).Unprocessed_Segmented_Data = handles.OverLord(i).Master(j).expt(k).Pre_Data;
             Motometric_Data(i).Record(j).Expt(k).Processed_mean_quantified_MEP = handles.OverLord(i).Master(j).expt(k).Post_Data;
             Motometric_Data(i).Record(j).Expt(k).Processed_quantified_MEP = handles.OverLord(i).Master(j).expt(k).Post_Raw;
             Motometric_Data(i).Record(j).Expt(k).MEP_quantification_metric = handles.OverLord(i).Master(j).expt(k).feat_choice;
             Motometric_Data(i).Record(j).Expt(k).Curve_fit.parameters = handles.OverLord(i).Master(j).expt(k).params.p;
             Motometric_Data(i).Record(j).Expt(k).Curve_fit.error = handles.OverLord(i).Master(j).expt(k).params.err;
             Motometric_Data(i).Record(j).Expt(k).Curve_fit.tolerance = handles.OverLord(i).Master(j).expt(k).params.tol;
             Motometric_Data(i).Record(j).Expt(k).Curve_fit.rec_curve_x = handles.OverLord(i).Master(j).expt(k).rec_curve.x;
             Motometric_Data(i).Record(j).Expt(k).Curve_fit.rec_curve_y = handles.OverLord(i).Master(j).expt(k).rec_curve.y;
             
        end
    end
end

uisave('Motometric_Data');
    
    
    
    
    
    
    
    
    
    
    
    