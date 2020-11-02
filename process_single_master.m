function varargout = process_single_master(varargin)
% PROCESS_SINGLE_MASTER MATLAB code for process_single_master.fig
%      PROCESS_SINGLE_MASTER, by itself, creates a new PROCESS_SINGLE_MASTER or raises the existing
%      singleton*.
%
%      H = PROCESS_SINGLE_MASTER returns the handle to a new PROCESS_SINGLE_MASTER or the handle to
%      the existing singleton*.
%
%      PROCESS_SINGLE_MASTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROCESS_SINGLE_MASTER.M with the given input arguments.
%
%      PROCESS_SINGLE_MASTER('Property','Value',...) creates a new PROCESS_SINGLE_MASTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before process_single_master_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to process_single_master_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help process_single_master

% Last Modified by GUIDE v2.5 19-May-2016 14:49:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @process_single_master_OpeningFcn, ...
                   'gui_OutputFcn',  @process_single_master_OutputFcn, ...
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


% --- Executes just before process_single_master is made visible.
function process_single_master_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to process_single_master (see VARARGIN)

% Choose default command line output for process_single_master
handles.output = hObject;
handles.Master_data = varargin{1};
handles.tickLabels = varargin{2};
handles.check_legacy = varargin{3};
handles.check_data_type = varargin{4};
handles.check_latency = varargin{5};
handles.proc_select = varargin{6};

if(handles.Master_data.processed==1)
    handles.button_s_curve.Enable = 'on';
else
    handles.button_s_curve.Enable = 'off';
end

if((handles.check_data_type==0)||(handles.check_latency==1))
    handles.button_s_curve.Enable = 'off';
end


stim_type = numel(handles.Master_data.expt(1).stim_vals);

if((stim_type<=1)&&(handles.check_data_type==1))
     h = warndlg('Warning: Data does not seem to be of recruitment curve type! Please select appopriate analysis type in the data selection and pre-processing options.','Warning!');
     waitfor(h);
    
%     delete(hObject);
%     handles.button_s_curve.Enable = 'off';
elseif((stim_type>1)&&(handles.check_data_type==0))
     h = warndlg('Warning: Data does not seem to be of single stimulation type! Please select appopriate analysis type in the data selection and pre-processing options.','Warning!');
     waitfor(h);   
end


handles.edit_start_time.String = num2str(handles.Master_data.expt(1).start_msec);
handles.edit_stop_time.String = num2str(handles.Master_data.expt(1).end_msec);
handles.popup_channels.Value = handles.Master_data.expt(1).active_channel;
handles.check_baseline_filter.Value = handles.Master_data.expt(1).bl_filter;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes process_single_master wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = process_single_master_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

    varargout{1} = handles.Master_data;
    delete(handles.figure1);
    delete(hObject);


function visualize_raw_emg(fig_handle,data,scale,tickLabels)

num_conds = numel(data.expt);
num_stims = numel(data.expt(1).Pre_Data);

ch_handles = allchild(fig_handle);

mean_plot = 0;

    if(ch_handles(1).Value==1)
        mean_plot = 1;
    end
    

StimVals = {(data.expt(:).stim_vals)};
MaxNStim = max(cellfun(@numel,StimVals));
bad_baseline = [];
bad_baseline_ctr = 1;

for i = 1:num_conds
 num_stims = numel(data.expt(i).Pre_Data);
 k = i;
 for j = num_stims:-1:1
    
         hh(i,j) = subplot(MaxNStim,num_conds,k);
         if(~mean_plot)
            plot(scale.*data.expt(i).Pre_Data{j},'linewidth',1,'clipping','off');
         else
             plot(scale.*mean(data.expt(i).Pre_Data{j},2),'k','linewidth',1,'clipping','off');
         end
         %axis([0 ,70,-2,2]);
         axis off
         
            ylabel(num2str(data.expt(i).stim_vals(j)),'visible','on','FontSize',24,'FontWeight','bold');
         
         k = k + num_conds; 
         
         if(j==1)
            xlabel(tickLabels{i},'visible','on','FontSize',24,'FontWeight','bold');
         end
         
         if(j==1)
            mean_data = mean(abs(data.expt(i).Pre_Data{j}),2);
            if((max(mean_data) - mean(mean_data))/3 > std(mean_data))
                %keyboard
                bad_baseline{bad_baseline_ctr} = tickLabels{i};
                bad_baseline_ctr = bad_baseline_ctr + 1;
            end
         end         
 end 
end
 
% if(bad_baseline_ctr>1)
%    bad_string = strjoin(bad_baseline,',');
%    d_string = ['Sessions: ' bad_string ' do not seem to exhibit near-zero values in the absence of stimulation. Please re-examine recording setup / check for noise.'];
%    warndlg(d_string,'Noisy/Non-zero Baselines!');
% end

% --- Executes on button press in button_visualize.
function button_visualize_Callback(hObject, eventdata, handles)
% hObject    handle to button_visualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 f1 = figure('renderer','opengl'); set(gcf,'color','w');
 set(f1, 'Position', [10 10 1200 750]);
 
 UserData.Data = handles.Master_data;
 UserData.tickLabels = handles.tickLabels;
 hscrollbar=uicontrol('Parent',f1,'style','slider','units','normalized','position',[0 0 .05 1],'callback',@hscroll_Callback,'UserData',UserData);
 hMeanTick = uicontrol('Parent',f1,'style','checkbox','units','normalized','String','Show Mean MEP','FontSize',24,'position',[0.4 0.95 0.25 0.05],'callback',@hMeanTick_Callback,'UserData',UserData);
 
 scale = 1.0;
 visualize_raw_emg(f1,handles.Master_data,1,handles.tickLabels);
 
 
 
function hscroll_Callback(src,evt)

scale = 1 + 4*src.Value;
visualize_raw_emg(src.Parent,src.UserData.Data,scale,src.UserData.tickLabels);

function hMeanTick_Callback(src,evt)

ch_handles = allchild(src.Parent);
ch_handles(2).Value = 0;
scale = 1.0;
visualize_raw_emg(src.Parent,src.UserData.Data,scale,src.UserData.tickLabels);


 
% --- Executes on button press in button_check_data.
function button_check_data_Callback(hObject, eventdata, handles)
% hObject    handle to button_check_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(0,'units','pixels')
sc_res = get(0,'ScreenSize');

fig_handle = figure; set(gcf,'color','w');
set(fig_handle, 'Position', [50 100 sc_res(3)-100 sc_res(4)-200]); % max [0 0 1220 700]  [x,y,xwidth, ywidth]
set(fig_handle,'resize','off');
colormap jet
num_conds = numel(handles.Master_data.expt);
num_stims = numel(handles.Master_data.expt(1).Pre_Data);

for i = 1:num_conds
   
     X = predata2mat(handles.Master_data.expt(i).Pre_Data);
     subplot(1,num_conds,i);
     
     f = imagesc(X');
     set(gca,'YDir','normal')
        zoom off
        pan off
        rotate3d off
       set(gca,'tag',['heatmaps_artifacts',num2str(i)]);
       set(gca,'FontSize',15, 'FontWeight', 'bold');
       set(gca,'UserData',i);
       name_parts = strsplit(handles.Master_data.expt(i).file,{'\','/'},'CollapseDelimiters',true);
       fn = name_parts{end};
       title(['File: ',fn,' (', handles.tickLabels{i}, ')'],'FontSize',16,'Interpreter','none');
       
       if(i==1)
           ylabel('Trial number','FontSize',16,'FontWeight','bold');
           xlabel('Time (ms)','FontSize',16,'FontWeight','bold');
       end
end

rem_trials = [];
rem_expt = [];
setappdata(fig_handle,'rem_trials',rem_trials);
setappdata(fig_handle,'rem_expt',rem_expt);

 datacursormode on
 dcm = datacursormode(fig_handle);
 set(dcm,'updatefcn',{@save_position,fig_handle},'SnapToDataVertex','on');
 %uicontrol('Style','text','Position',[100,10,150,15],'String','Trials to remove: ');
 
 
 confirmBox = uicontrol('Style','pushbutton','Position',[10,500,100,50],'String','Confirm','FontSize',16,'Callback',{@confirm_trial_removal,fig_handle});
 doneBox    = uicontrol('Style','pushbutton','String','Done','FontSize',16,'Position',[10,400,100,50],'Callback',{@remove_trials,handles,fig_handle});
  
% keyboard;


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isappdata(handles.figure1,'master_data'))
   handles.Master_data=getappdata(handles.figure1,'master_data');
end
guidata(hObject, handles);
uiresume();


function [proc_select] = get_proc_selection(handles)

proc_select.channel = handles.popup_channels.Value;
proc_select.bl_filter = handles.check_baseline_filter.Value;
proc_select.start_time = str2num(handles.edit_start_time.String);
proc_select.stop_time = str2num(handles.edit_stop_time.String);


% --- Executes on button press in button_update.
function button_update_Callback(hObject, eventdata, handles)
% hObject    handle to button_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 proc_select = get_proc_selection(handles);
 
 handles.proc_select.channel = proc_select.channel;
 handles.proc_select.bl_filter = proc_select.bl_filter;
 handles.proc_select.start_time = proc_select.start_time;
 handles.proc_select.stop_time = proc_select.stop_time;
 
if(handles.check_legacy)
    handles.Master_data = b_emg_analyze(handles.Master_data,handles.proc_select);
else
    handles.Master_data = nonlegacy_b_emg_analyze(handles.Master_data,handles.proc_select);
end
 guidata(hObject, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

%delete(hObject);
uiresume();


% --- Executes on button press in button_s_curve.
function button_s_curve_Callback(hObject, eventdata, handles)
% hObject    handle to button_s_curve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hfig = figure;
axes_str{1} = handles.Master_data.expt(1).feat_choice;
axes_str{2} = 'Stimulation current (mA)';
str(1) = {'Goodness of Fit:'};
bad_rec_curve_names = {};
bad_ctr = 1;
 co = jet(1024);%get(groot,'defaultAxesColorOrder');
 num_curves = length(handles.Master_data.expt);
 co2 = ([0:num_curves-1] .* round(length(co)/num_curves)) + 1;
 co = co(co2,:);
 
for i = 1:numel(handles.Master_data.expt)
    hf = plot(handles.Master_data.expt(i).params,axes_str,co(i,:));
    plot_cols(i,:) = hf.handle.optimized.handle.Color;
    hold on
    
    SSres = handles.Master_data.expt(i).params.err;
    y = handles.Master_data.expt(i).params.y; 
    SStot = sum((y - mean(y)).^2);
    Rsq(i) = 1 - (SSres/SStot);
    str(i+1) = {['R^2 for' handles.tickLabels{i} ' : ' num2str(Rsq(i),2)]};
    
    %Find saturation here
    
    rx = handles.Master_data.expt(i).stim_vals(end-2:end);  %Get last 3 raw data points
    ry = handles.Master_data.expt(i).Post_Data(end-2:end);
    
    R = corrcoef(rx,ry);
    R = R(1,2);
    s_slope = R .* (std(ry)./std(rx))
    a = mean(ry) - s_slope.*mean(rx);
   
    
%     dy = diff(handles.Master_data.expt(i).rec_curve.y);
%     dx = diff(handles.Master_data.expt(i).rec_curve.x);
%     s_slope = dy./dx;
%     s_slope = s_slope(end-10:end);
%     s_slope = mean(s_slope);
    
    if(s_slope > 0.01)
        bad_rec_curve_names{bad_ctr} = handles.tickLabels{i};
        bad_ctr = bad_ctr + 1;
        plot(rx,a + rx.*s_slope,'MarkerEdgeColor', plot_cols(i,:));
    end
    
end

colormap(plot_cols);
lcolorbar(handles.tickLabels,'FontSize',20,'FontWeight','bold');
title(handles.Master_data.file,'Interpreter','none');
dim = [0.2 0.5 0.3 0.3];
annotation('textbox',dim,'String',str,'FitBoxToText','on','Fontsize',15);

if(bad_ctr > 1)
   bad_string = strjoin(bad_rec_curve_names,',');
   d_string = ['Curve(s): ' bad_string ' do not seem to exhibit complete saturation. Please reconsider range of stimulation intensities used OR try another metric.'];
   warndlg(d_string,'Recruitment saturation not detected!');
end
