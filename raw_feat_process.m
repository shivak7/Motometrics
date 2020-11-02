function [raw_data] = raw_feat_process(Master_data,feat_select)


Expt_size = numel(Master_data(1).expt); %Get total number of experiments per subject
raw_data = [];
%  for j = 1:length(Master_data)
%      k = 1;
%      BL_ref = mean(Master_data(j).expt(k).Post_Raw{1});   %1 hard coded because single stim intensity assumed
%      
%      for k = 1:length(Master_data(j).expt)         
%         raw_bar{k} = 100.*[(Master_data(j).expt(k).Post_Raw{1})./BL_ref];
%      end
%     keyboard
%      raw_data{j} = raw_bar;
%      
%  end
 

 for k = 1:Expt_size
     
     raw_bar = [];
     for j = 1:length(Master_data)
         
         BL_ref = mean(Master_data(j).expt(1).Post_Raw{1});
         raw_bar = [raw_bar 100.*[(Master_data(j).expt(k).Post_Raw{1})./BL_ref]];
     end
   raw_data{k} = raw_bar;
 end
