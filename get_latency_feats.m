function [latency_feat latency_data] = get_latency_feats(Data,Fs, Thresh)


for k = 1:size(Data,2)

   emg_sig = Data(:,k);

   %if(max(abs(emg_sig))<Thresh)
   %    data_delay(k) = inf;    %Storing infinite latency if signal is too weak
   %else
   idx = find(abs(emg_sig)>=Thresh.*max(emg_sig),1,'first');     % Find first point to cross threshold
   delay_ms = idx/(Fs/1000); %  Calculate latency in millseconds
   data_delay(k) = delay_ms;
   %end
end
data_mean = mean(data_delay);

if(data_mean<0)
    keyboard
end

latency_feat = data_mean; %Store inverse latency
latency_data = (data_delay);