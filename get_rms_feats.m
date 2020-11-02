function [rms_feat rms_data] = get_rms_feats(Data,Fs)

data_abs = abs(Data);   % Rectify
rms_data = rms(data_abs,1);

%data_mean = mean(abs(Data),2);   % Rectify and average across trials
%rms_feat = rms(data_mean);

rms_feat = mean(rms_data);