function data_bars = get_slope_feats(curves_obj, raw)
% base_slope = exp(cfg(1).params.p(2)); % Critically dependent on slope variable p(2) in dishfit.m


        
for j = 1:size(curves_obj,1)
    
    dx = [0 diff(curves_obj(j,1).x)];
    dy = [0 diff(curves_obj(j,1).y)];
    mid = length(dy)/2;
    base_slope = dy(mid)/dx(mid);

    for i = 1: size(curves_obj,2)
        dx = [0 diff(curves_obj(j,i).x)];
        dy = [0 diff(curves_obj(j,i).y)];
        mid = length(dy)/2;
        slope = dy(mid)/dx(mid);
%         figure; plot(curves_obj(j,i).x,curves_obj(j,i).y);
%         hold on
%         plot(curves_obj(j,i).x,curves_obj(j,i).x*slope,'r');
        if(raw==1)
            data_bars(j,i) =  slope;
        else
            data_bars(j,i) =  (((slope./base_slope)) *100);
        end
    end
end