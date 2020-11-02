function preformat_ADinstruments_Datafile(in_data,datastart, dataend, sample_rate,selected_channels , window_size, offset, stim_trial_table, trial_times, out_file)

%   in_data - recorded data
%   datastart, dataend - start and end points for segmenting to each data channel
%   sample_rate - sampling rate
%   selected_channels - vector of numbers specifying which channels to extract
%   window_size - In seconds, specifies size of signal to extract for each trial
%   offset - In seconds, specifies how much before trigger to begin signal window
%   stim_trial_table - Table of trials starting from lowest to highest intensities for re-ordering randomized trials
%   trial_times - In datapoints (not seconds) Indicates when the trials start for each trigger.
%   out_file - Name of output session file that will generate a recruitment curve

for i = 1:length(datastart)
    D(:,i) = in_data(datastart(i):dataend(i)); 
end

%Remove data variable to save some RAM
clear in_data;

OrderedTrials = [stim_trial_table{:}];
MaxTrials = max(OrderedTrials);

for i = 1:MaxTrials
   
    trial_start = trial_times(OrderedTrials(i)) - offset*sample_rate;
    trial_end = trial_start + window_size*sample_rate;
    
    Data.values(:,:,i) = D(trial_start:trial_end, selected_channels);
    
end

Data.interval = 1/sample_rate;


save(out_file,'Data');