function cfg = remove_trials(hObj,event_obj,handles,figure_handle)


%% recruitment curves
rem_trials = getappdata(figure_handle,'rem_trials');
rem_expt = getappdata(figure_handle,'rem_expt');

[rem_expt, sort_idx] = sort(rem_expt);  %Sort in increasing order of expt no.
rem_trials = rem_trials(sort_idx);

u_expt = unique(rem_expt);  %Find unique experiment numbers

for i = 1:numel(u_expt)
   
    u_idx = find(rem_expt==u_expt(i));  %All trials to be deleted for given expt no.
    delete_list = rem_trials(u_idx);
    
    Y = cell2mat(handles.Master_data.expt(u_expt(i)).Pre_Data);
    Y(:,delete_list) = [];
    Y = Y';
    
    for j = 1:numel(delete_list)
       frame_chk = delete_list(j) - cumsum(handles.Master_data.expt(u_expt(i)).frame_vals);
       f_idx = find(frame_chk <= 0,1,'first');
       
       handles.Master_data.expt(u_expt(i)).frame_vals(f_idx) = handles.Master_data.expt(u_expt(i)).frame_vals(f_idx) - 1;
    end
    
    frame_end_range = cumsum(handles.Master_data.expt(u_expt(i)).frame_vals);   %Create indices to select the correct number of data frames per stim value
    frame_start_range = [1; 1+frame_end_range];
    frame_start_range(end) = [];
    
     for j = 1:length(handles.Master_data.expt(u_expt(i)).stim_vals) %Perform frame and data extraction into distinct data sets based on 
        handles.Master_data.expt(u_expt(i)).Pre_Data{j} =  Y(frame_start_range(j):frame_end_range(j),:)';
     end
    
    setappdata(handles.figure1,'master_data',handles.Master_data);
    delete(figure_handle);
    delete(hObj);
end



