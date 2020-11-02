function data_bars = get_mep_feats(curves_obj, cut)

for j = 1:size(curves_obj,1)

    base_max_mep       = max(curves_obj(j,1).y);  % baseline curve
    base_min_mep       = min(curves_obj(j,1).y);  % baseline curve

    if base_min_mep < 0 ; base_min_mep = 0;end
    mep_cut  = base_min_mep + ((base_max_mep-base_min_mep)/(100/cut));  % cut% of the max mep

    base_stim_cut_idx = find(curves_obj(j,1).y <= mep_cut,1,'last');
    base_stim_cut = curves_obj(j,1).x(base_stim_cut_idx);

    
    for i = 1: size(curves_obj,2)  % first curve is baseline
        stim_cut_idx = find(curves_obj(j,i).y <= mep_cut,1,'last');
        if(isempty(stim_cut_idx))
            stim_cut_idx = 1;
        end
        stim_cut = curves_obj(j,i).x(stim_cut_idx);
        data_bars(j,i) =  (((stim_cut./base_stim_cut)) *100);
    end

end