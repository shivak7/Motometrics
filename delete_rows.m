function handles = delete_rows(handles)

pre_sessions = unique(cell2mat(cellfun(@str2num, handles.table_session.Data(:,1),'un',0)));
    handles.table_session.Data(handles.CurrentSelection(:,1),:) = [];
    handles.CurIndex = handles.CurIndex - length(unique(handles.CurrentSelection(:,1)));
    post_sessions = unique(cell2mat(cellfun(@str2num, handles.table_session.Data(:,1),'un',0)));
    handles.CurrentSelection=[];
    if(length(pre_sessions)>length(post_sessions))
          missing_vals = setdiff(pre_sessions,post_sessions);
          
          map_sessions = cell2mat({(handles.Map(:).SessionNumber)});
          for i = 1:numel(missing_vals)
            [~,idx] = find(missing_vals(i)==map_sessions);
          
            handles.Map(idx) = [];
            handles.list_session_file.String(idx + 1) = []; 
            map_sessions(idx) = [];
          end
    end