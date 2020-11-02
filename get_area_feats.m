function [peak_feat area_data] = get_area_feats(Data,Fs)

for k = 1:size(Data,2)
    emg_sig = Data(:,k);
    emg_sig = emg_sig - mean(emg_sig);
    Ts = 1000/Fs; %Time step in ms
    Te = (length(emg_sig) - 1)*Ts;
    T = [0:Ts:Te];
    area_data(k) = trapz(T,abs(emg_sig)); %Calculate actual area under the curve
end
peak_feat = mean(area_data);



