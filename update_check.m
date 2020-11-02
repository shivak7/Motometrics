function handles = update_check(handles)

if(handles.BeginSession == 0)
    return          %Do nothing if session has NOT started
end
   
emat = cell2mat(cellfun(@isempty, handles.table_session.Data,'un',0));
FileStat = squeeze(struct2cell(handles.Map));
FileStat = FileStat(2,:);
FileStat = strcmp('MissingFile',FileStat);
if(sum(sum(emat))>0)
    warndlg('Error! Empty values in Session Manager Matrix!');
    handles.ReadySave = 0;
    return
end

SessionMat = cell2mat(cellfun(@str2num, handles.table_session.Data,'un',0));

all_sessions = unique(SessionMat(:,1));
map_sessions = cell2mat({(handles.Map(:).SessionNumber)});

missing1 = setdiff(all_sessions,map_sessions);  %Sessions in manager but missing from list
missing2 = setdiff(map_sessions,all_sessions);  %Sessions in list but missing from manager

if(~isempty(missing1))
    for i = 1:numel(missing1)
        handles.Map(numel(handles.Map)+1).SessionNumber = missing1(i);
        handles.Map(numel(handles.Map)).FileName = 'MissingFile';
        handles.Map(numel(handles.Map)).PathName = '';

        handles.list_session_file.String{numel(handles.list_session_file.String) + 1} = [num2str(handles.Map(numel(handles.Map)).SessionNumber) handles.Spacer handles.Spacer handles.Map(numel(handles.Map)).FileName];
    end
end

if(~isempty(missing2))
    for i = 1:numel(missing2)
            [~,idx] = find(missing2(i)==map_sessions);
          
            handles.Map(idx) = [];
            handles.list_session_file.String(idx + 1) = [];
            map_sessions(idx) = [];
    end
end

if(sum(sum(FileStat))>0)
    warndlg('Error! Files not Linked to Session!');
    handles.ReadySave = 0;
    return
end

handles.ReadySave = 1;