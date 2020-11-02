function success = validate_session_path(current_file, current_path)

if(current_file==0)
   success = 0;
    return
end

load([current_path current_file]);

if(exist('SessionFiles')==0)
        warndlg('Error! This is not a single record file. Try loading as a master file instead');
        success = 0;
        return;
end

dir_flag = exist(SessionFiles(1).PathName);

if(~dir_flag)
   waitfor(warndlg('Path error: Path to session data files missing! Please specify correct data directory! '));
   updated_path = uigetdir('','Pick Data directory for session files');
   
   if(~updated_path)
       warndlg('Program error: Appropriate directory for session data files not selected!');
       success = 0;
       return
   end
   
   for i = 1:numel(SessionFiles)
      SessionFiles(i).PathName = [updated_path filesep];
   end
    
   save([current_path current_file],'SessionMat','SessionFiles');
end

success = 1;