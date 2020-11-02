function [Master_data] = feat_process(Master_data,feat_select)

if((isempty(feat_select.latency_thresh))||(feat_select.latency_thresh <= 0))
    feat_select.latency_thresh = 0.05;
end


for i = 1:numel(Master_data.expt)
   for j = 1:numel(Master_data.expt(i).Pre_Data)
       if(feat_select.rectify==1)
        Master_data.expt(i).Pre_Data{j} = abs(Master_data.expt(i).Pre_Data{j});
       end
       
       if(feat_select.rms==1)
           [Master_data.expt(i).Post_Data(j) Master_data.expt(i).Post_Raw{j}] = get_rms_feats(Master_data.expt(i).Pre_Data{j}, Master_data.expt(i).Fs);
           Master_data.expt(i).feat_choice = 'RMS value (mv)';
         elseif(feat_select.peak==1)
           [Master_data.expt(i).Post_Data(j) Master_data.expt(i).Post_Raw{j}] = get_peak_feats(Master_data.expt(i).Pre_Data{j}, Master_data.expt(i).Fs);
           Master_data.expt(i).feat_choice  = 'Peak to Peak (mv)';
         elseif(feat_select.latency==1)
             [Master_data.expt(i).Post_Data(j) Master_data.expt(i).Post_Raw{j}] = get_latency_feats(Master_data.expt(i).Pre_Data{j}, Master_data.expt(i).Fs, feat_select.latency_thresh);
             Master_data.expt(i).feat_choice = 'Latency (ms)';
         elseif(feat_select.auc==1)
             [Master_data.expt(i).Post_Data(j) Master_data.expt(i).Post_Raw{j}] = get_area_feats(Master_data.expt(i).Pre_Data{j}, Master_data.expt(i).Fs);
             Master_data.expt(i).feat_choice = 'Area under Curve (mv-ms)';
       end
       
   end
   
            if((feat_select.gen_rec_curve==1)&&(feat_select.latency==0))
                [Master_data.expt(i).params]      = dishfit(Master_data.expt(i).stim_vals,Master_data.expt(i).Post_Data',feat_select.fit_tolerance);  %TODO: Make tolerence a variable instead of hardcoding as 0.1            
                [Master_data.expt(i).rec_curve]   = plot(Master_data.expt(i).params);
            
            else
                Master_data.expt(i).params = [];
                Master_data.expt(i).rec_curve = [];
            
            end
end