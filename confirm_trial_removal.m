function out_text = confirm_trial_removal(hObj,eventObj,figure_handle)

% This functions is evoked in response to pressing the 'Confirm' box

% confirms the selected trial to be removed
% look for the last value clicked by user
rem_trials = [];

dcm = datacursormode(figure_handle);
cursor_val = dcm.getCursorInfo;
curr_trial = cursor_val.Position(2);
curr_expt = get(gca,'UserData');

rem_trials = getappdata(figure_handle,'rem_trials');
rem_expt = getappdata(figure_handle,'rem_expt');

if(~isempty(rem_trials))
    if((rem_trials(end)~=curr_trial)||(rem_expt(end)~=curr_expt))
        rem_trials = [rem_trials curr_trial];
        rem_expt = [rem_expt curr_expt];

        setappdata(figure_handle,'rem_trials',rem_trials);
        setappdata(figure_handle,'rem_expt',rem_expt);

        uicontrol('Style','text','Position',[200,0,(200*8),30],'String', ['Remove Trial(s):' num2str(rem_trials) '     Experiments:' num2str(rem_expt)],'FontSize',16,'FontWeight','bold');
    end
else
        rem_trials = [rem_trials curr_trial];
        rem_expt = [rem_expt curr_expt];

        setappdata(figure_handle,'rem_trials',rem_trials);
        setappdata(figure_handle,'rem_expt',rem_expt);

        uicontrol('Style','text','Position',[200,0,(200*8),30],'String', ['Remove Trial(s):' num2str(rem_trials) '     Experiments:' num2str(rem_expt)],'FontSize',16,'FontWeight','bold');
end

%keyboard

% if isappdata(figure_handle,'select_data');
%      temp = getappdata(figure_handle,'select_data');
%     
%      trial_to_remove = temp(end,:);
% else
%      trial_to_remove   = nan;
%    
% end
% 
% if isappdata(figure_handle,'confirmed_trials_to_remove')
%     rem_trials = [getappdata(figure_handle,'confirmed_trials_to_remove');trial_to_remove];
% else 
%     rem_trials = trial_to_remove; 
% end
% 
%  setappdata(figure_handle,'confirmed_trials_to_remove',rem_trials);
% 
%   %% update the display formatted for respective columns
%   file_signs ={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
%   num_of_cols     = max(rem_trials(:,1));
%   final_re_trials = {};col_string={};string_to_disp ='';
%   
%   keyboard   
%   if ~isempty(rem_trials)
%     for i = 1 : num_of_cols 
%    
%       temp_trNum          = find(rem_trials(:,1)==i);
%       temp_trials         = rem_trials(temp_trNum,2);
%       final_rem_trials{i} = unique(temp_trials);
%       col_string{i}       = ['File ',file_signs{i},': ',num2str(final_rem_trials{i}')];
%       string_to_disp      = [string_to_disp,' ; ',col_string{i}]; 
%       temp_trials         = []; 
%       temp_trNum          = []; 
%     
%     end
%    
%   end
%  
%   uicontrol('Style','text','Position',[90,30,(200*num_of_cols),30],'String',string_to_disp);
% 
%   %% for ease of computation
%   
%   setappdata(figure_handle,'confirmed_separated_trials_to_remove',final_rem_trials);

