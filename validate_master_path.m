function success = validate_master_path(current_file, current_path)

if(current_file==0)
    success = 0;
    return
end

load([current_path current_file]);

if(exist('session_files_list','var')==0)
    errordlg('File loaded is not a master file!','Error');
    success = 0;
    return
end


for i = 1:numel(session_files_list)
    dir_flag(i) = exist([session_files_list{i} '.mat']);
end

idx = find(~dir_flag);

if(~isempty(idx))  
    
   check_flag = 1;   
   missing_list = [];
   
   for i = 1:length(idx)
       [~,filename,~] = fileparts(session_files_list{idx(i)});
       missing_list = [missing_list '; ' filename];
   end
   
   options.Interpreter = 'none';
   options.Default = 'Directory';
   while(check_flag)
           
           choice = questdlg(['Program Error: Cannot find one or more session files ' missing_list ' '...
               'Either specify correct directory or session files. Choose "Directory" option if all session files are in the same directory.'],...
               'Missing session file(s)/path','Directory','Files',options);
           
           if(strcmp(choice,'Directory'))   %Check if old session files all exist within this new directory
               
               updated_path = uigetdir('','Pick Data directory for session group files');
               if(~updated_path)
                   warndlg('Program error: Appropriate directory for session data files not selected!');
                   success = 0;
                   return
               end                           
               
               new_session_list = session_files_list;
               dir_flag = [];
               for i = 1:length(idx)
                    [~,filename,~] = fileparts(session_files_list{idx(i)});
                    new_session_list(idx(i)) = {[updated_path filesep filename]};
                    dir_flag(i) = exist([new_session_list{idx(i)} '.mat']);
               end
               idx2 = find(~dir_flag);
               if(isempty(idx2))
                   check_flag = 0;
               end
           
           else
                dir_flag = [];
                new_session_list = session_files_list;
                for i = 1:length(idx)
                     [~,old_filename,~] = fileparts(session_files_list{idx(i)});
                     [filename, updated_path, filterindex] = uigetfile('*.mat',['Select file corresponding to ' old_filename]);
                      if(~filename)
                            warndlg('Program error: Appropriate session data files not selected!');
                            success = 0;
                            return
                      end         
                     [~,new_filename,~] = fileparts(filename);
                     new_session_list(idx(i)) = {[updated_path new_filename]};
                     dir_flag(i) = exist([new_session_list{idx(i)} '.mat']);
                end
                idx2 = find(~dir_flag);
                if(isempty(idx2))
                   check_flag = 0;
                end
               
           end
           
   end

   session_files_list = new_session_list;
   save([current_path current_file],'session_files_list');

   
end
success = 1;