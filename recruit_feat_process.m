function [rec_bar rec_type rec_cut] = recruit_feat_process(Combination_data_main, feat_select)

 
 for i = 1: numel(Combination_data_main.Master)
       for j = 1: numel(Combination_data_main.Master(1).expt)
        curves_all(i,j).x = Combination_data_main.Master(i).expt(j).rec_curve.nx;
        curves_all(i,j).y = Combination_data_main.Master(i).expt(j).rec_curve.ny;
       end
 end  
   

i = 1;
if(feat_select.mep10==1)
   rec_bar{i} = get_mep_feats(curves_all,10);
   rec_type{i} = 'mep';
   rec_cut{i} = 10;
   i = i+1;
end

if(feat_select.mep50==1)
   rec_bar{i} = get_mep_feats(curves_all,50);
   rec_type{i} = 'mep';
   rec_cut{i} = 50;
   i = i+1;
end

if(feat_select.mep90==1)
   rec_bar{i} = get_mep_feats(curves_all,90);
   rec_type{i} = 'mep';
   rec_cut{i} = 90;
   i = i+1;
end

if(feat_select.custom_mep==1)
   rec_bar{i} = get_mep_feats(curves_all,feat_select.custom_mep_value);
   rec_type{i} = 'mep';
   rec_cut{i} = feat_select.custom_mep_value;
   i = i+1;
end

if(feat_select.slope==1)
   rec_bar{i} = get_slope_feats(curves_all, feat_select.slope_raw); 
   rec_type{i} = 'slope';
   rec_cut{i} = [];
   i = i+1;
end

if(feat_select.stim50==1)
   rec_bar{i} = get_stim_feats(curves_all,50);
   rec_type{i} = 'stim';
   rec_cut{i} = 50;
   i = i+1;
end

if(feat_select.custom_stim==1)
   rec_bar{i} = get_stim_feats(curves_all,feat_select.custom_stim_value);
   rec_type{i} = 'stim';
   rec_cut{i} = feat_select.custom_stim_value;
   i = i+1;
end