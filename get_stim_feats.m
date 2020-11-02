function data_bars = get_stim_feats(curves_obj, cut)

for j = 1:size(curves_obj,1)

    base_max_mep       = max(curves_obj(j,1).y);  % baseline curve
    base_min_mep       = min(curves_obj(j,1).y);  % baseline curve

    if base_min_mep < 0 ; base_min_mep = 0;end
    base_mep_cut  = base_min_mep + ((base_max_mep-base_min_mep)/(100/cut));  % cut % of the max mep

    base_stim_cut_idx = find(curves_obj(j,1).y <= base_mep_cut,1,'last');
    base_stim_cut = curves_obj(j,1).x(base_stim_cut_idx); % Stim needed to evoke cut % of max base mep
    base_mep_cut = curves_obj(j,1).y(base_stim_cut_idx);
    
    for i = 1: size(curves_obj,2)  % first curve is baseline
        mep_cut_idx = find(curves_obj(j,i).x <= base_stim_cut,1,'last'); %Find closest match to base_stim
        mep_cut = curves_obj(j,i).y(mep_cut_idx); % Identify how much mep does this stim evoke in all cases
        data_bars(j,i) =  (((mep_cut./base_mep_cut)) *100);
    end
    
end
