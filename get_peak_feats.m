function [peak_feat peak_data] = get_peak_feats(Data,Fs)


        peak_vals = max(Data);
        trough_vals = min(Data);
        peak_data = peak_vals - trough_vals;
        peak_feat = mean(peak_data);
       
