%% function to analyse the emg data coming in for multiple trials 


function [Master_data] = b_emg_analyze(Master_data,proc_select) 

for i = 1:numel(Master_data.expt)
       
    Vname = load([Master_data.path filesep Master_data.expt(i).file '.mat']);  % This code section just extracts the data, sampling rate, frame info
    fy                     = orderfields(Vname);
    names                  = fieldnames(fy);
    if numel(names)==1
       fz                  = getfield(fy,cell2mat(names(1,:)));
    else
       fz                  = getfield(fy,cell2mat(names(2,:)));
    end
    orig_fs                = 1./(fz.interval);
    orig_frames            = fz.frames;
    Master_data.expt(i).Fs = orig_fs;
    Master_data.expt(i).start_msec = proc_select.start_time;
    Master_data.expt(i).end_msec = proc_select.stop_time;
    Master_data.expt(i).active_channel = proc_select.channel;
    Master_data.expt(i).bl_filter = proc_select.bl_filter;
    Master_data.expt(i).emg             = squeeze(fz.values(:,proc_select.channel,:));
    
   
    if(proc_select.bl_filter > 0)       %Anti Baseline drift filter
        Wp = [proc_select.filter_cutoff_lower proc_select.filter_cutoff_upper]/(orig_fs/2);
        Ws = [0.2*proc_select.filter_cutoff_lower 2*proc_select.filter_cutoff_upper]/(orig_fs/2);
        Rp = 4; Rs = 30;
        [n, Wn] = buttord(Wp, Ws, Rp, Rs);
        [b,a] = butter(n, Wn);
        %[b,a] = butter(5,[proc_select.filter_cutoff_lower/(orig_fs/2), proc_select.filter_cutoff_upper/(orig_fs/2)]);    %5th order 5hz - 500Hz bandpass filter
        Master_data.expt(i).emg = filtfilt(b,a,Master_data.expt(i).emg);
    end
    
    if(proc_select.line_filter > 0)
       
        for line_iter = 1:proc_select.line_multiplier
            
            line_freq = 60 * line_iter;
            
           d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',line_freq - 1,'HalfPowerFrequency2',line_freq + 1, ...
               'DesignMethod','butter','SampleRate',orig_fs);
           
           Master_data.expt(i).emg = filtfilt(d,Master_data.expt(i).emg);
            
        end
        
    end
  
    frame_end_range = cumsum(Master_data.expt(i).frame_vals);   %Create indices to select the correct number of data frames per stim value
    frame_start_range = [1; 1+frame_end_range];
    frame_start_range(end) = [];
    
    data_start_range = Master_data.expt(i).start_msec * (Master_data.expt(i).Fs/1000); % Create indices to extract emg data within the specified time intervals
    data_end_range = Master_data.expt(i).end_msec * (Master_data.expt(i).Fs/1000);

    for j = 1:length(Master_data.expt(i).stim_vals) %Perform frame and data extraction into distinct data sets based on 
        Master_data.expt(i).Pre_Data{j} =  Master_data.expt(i).emg(data_start_range:data_end_range, frame_start_range(j):frame_end_range(j));
    end
    
    Master_data.expt(i).emg = [];   % Clear to save space, not needed for future analysis.
end