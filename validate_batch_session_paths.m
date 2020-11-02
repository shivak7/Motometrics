function success = validate_batch_session_paths(current_file, current_path)

if(current_file==0)
    return
end

load([current_path current_file]);

k = 1
for i = 1:numel(session_files_list)
    load([session_files_list{i} '.mat']);
    
    for j = 1:numel(SessionFiles)
        Group(i).Session(j).Path = SessionFiles(j).PathName;
        Group(i).Session(j).File = SessionFiles(j).FileName;
        dir_flag(k) = exist([SessionFiles(j).PathName SessionFiles(j).FileName]);
        k = k + 1;
    end
end

total_files = numel(session_files_list) * numel(SessionFiles);  
idx1 = find(~dir_flag);

check_flag = 0;
if(length(idx1)>0)
    check_flag = 1;
end

options.Interpreter = 'none';
options.Default = 'Parent';
        
while(check_flag)
    
     choice = questdlg(['Program Error: Cannot find one or more session files '...
               'Either specify correct parent directory or individual session directories. Choose "Parent" option if all UNCHANGED session file directories are in the same parent directory.'],...
               'Incorrect session file(s)/path','Parent','Directory',options);         
           
                if(strcmp(choice,'Parent'))
                    parent_path = uigetdir('','Enter Parent directory that holds all SESSION data Directories');
                     if(~parent_path)
                                warndlg('Program error: Appropriate Parent directory for session data directories not selected!');
                                success = 0;
                                return
                     end
                    
                    k = 1;
                    for i = 1:numel(session_files_list)
                        load([session_files_list{i} '.mat']);

                        for j = 1:numel(SessionFiles)
                            [path1,~,~] = fileparts(SessionFiles(j).PathName);
                            [~,new_path,~] = fileparts(path1);
                            Group(i).Session(j).Path = [parent_path filesep new_path filesep];
                            Group(i).Session(j).File = SessionFiles(j).FileName;
                            dir_flag(k) = exist([Group(i).Session(j).Path Group(i).Session(j).File]);
                            k = k + 1;
                        end
                    end

                        idx1 = find(~dir_flag);

                        if(length(idx1)<1)
                            check_flag = 0;
                        end                       
                
                else
                    
                   
                    for i = 1:numel(session_files_list)
                        load([session_files_list{i} '.mat']);
                        
                          updated_path = uigetdir('',['Pick Data directory for session group files corresponding to ' session_files_list{i}]);
                            if(~updated_path)
                                warndlg('Program error: Appropriate directory for session data files not selected!');
                                success = 0;
                                return
                            end

                            dir_flag = [];
            
                         k = 1;
                        for j = 1:numel(SessionFiles)
                            Group(i).Session(j).Path = [updated_path filesep];
                            Group(i).Session(j).File = SessionFiles(j).FileName;
                            dir_flag(k) = exist([Group(i).Session(j).Path Group(i).Session(j).File]);
                            k = k + 1;
                        end
                    end
                        
                        idx1 = find(~dir_flag);

                        if(length(idx1)<1)
                            check_flag = 0;
                        end                  
                
                end
                
    if(~check_flag)
       for i = 1:numel(session_files_list)
           load([session_files_list{i} '.mat']); 
            for j = 1:numel(SessionFiles)
                SessionFiles(j).PathName = Group(i).Session(j).Path;
                SessionFiles(j).FileName = Group(i).Session(j).File;
            end
            save([session_files_list{i} '.mat'],'SessionMat','SessionFiles');
       end
    end
                                      
end


success = 1;