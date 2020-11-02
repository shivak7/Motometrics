function [Combination_data X Ym] = combine_batch(Combination_data)

num_combine  = numel(Combination_data);    %Number of combinations
 
 for i = 1:num_combine   
    
     total_curves = numel(Combination_data(1).expt);  %Number of curves per session
     
     %% Baseline calculations
     curve_num = 1;
      cx    = Combination_data(i).expt(curve_num).rec_curve.x;
      cy    = Combination_data(i).expt(curve_num).rec_curve.y;
      p      = Combination_data(i).expt(curve_num).params;
     
       [val,pos]          = max(cy);
       max_stim           = cx(pos);

       maxResponse        = val;               %Set threshold for response as 100% of maximal response
       thresholdResponse  = (100/100) * maxResponse;
       f_temp             = find(cy >= thresholdResponse,1,'first');%find(sort_response >= thresholdResponse);
       thresholdStim      = cx(f_temp(1));
    
       cx_new = (cx./thresholdStim) * 100;  %Normalized curves
       cy_new = (cy./maxResponse) * 100;    %Normalized curves
       
       
       Combination_data(i).expt(curve_num).rec_curve.nx = cx_new;
       Combination_data(i).expt(curve_num).rec_curve.ny = cy_new;
        
       Y(curve_num, i,:) = cy_new;
       X = cx_new;
       
       %% Rest of the curves
       
       for curve_num = 2:total_curves
            cx    = Combination_data(i).expt(curve_num).rec_curve.x;
            cy    = Combination_data(i).expt(curve_num).rec_curve.y;
            p      = Combination_data(i).expt(curve_num).params;
            
            cx_new = (cx./thresholdStim) * 100;
            cy_new = (cy./maxResponse) * 100;
            
            Combination_data(i).expt(curve_num).rec_curve.nx = cx_new;
            Combination_data(i).expt(curve_num).rec_curve.ny = cy_new;
             
            Y(curve_num, i,:) = cy_new;
       end
 end
 
 Ym = squeeze(mean(Y,2));