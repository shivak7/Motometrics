clc;
clear all;

load Example    %Assumes Example contains varialbe data. This should be obtained by exporting recorded data from AD instruments to MATLAB
% Reconstrucing data by channels
sel_channels = [2:3];
trigger_channel = 5;

offset = 0.0;
window_size = 0.4;

%User specified stim-trial information. This is used to de-randomize and
%reorder data.
stim_trial_table{1} = [41:45 71:75];    %Indicates trials 41-45 and 71-75 all belong to the same stim intensity
stim_trial_table{2} = [1:10];
stim_trial_table{3} = [21:25 46:50];
stim_trial_table{4} = [11:20];
stim_trial_table{5} = [31:35 61:65];
stim_trial_table{6} = [36:40 66:70];
stim_trial_table{7} = [26:30 51:60];

trial_times = com(:,3);

out_file = 'Test_AD.mat';
preformat_Datafile(data,datastart, dataend, samplerate(1),sel_channels , window_size, offset, stim_trial_table, trial_times, out_file)