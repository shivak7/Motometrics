function [out_txt] = save_position(~,event_obj,figure_handle)

Ypos_new=[];


pos     = get(event_obj,'Position');
X_pos   = pos(1);
Y_pos   = pos(2);

out_txt = {['X: ',num2str(pos(1),4)],['Y: ',num2str(pos(2),4)]};

subplot_col = getappdata(figure_handle,'subplot_handle');

% save all the positions clicked by user
 target_subplot = find(subplot_col==gca);
 subplot_Ypos   = [target_subplot,Y_pos];
 
 if isappdata(figure_handle,'select_data');
       
    Ypos_new = [getappdata(figure_handle,'select_data');subplot_Ypos];
    
 else
    Ypos_new = subplot_Ypos;
   
 end

 setappdata(figure_handle,'select_data',Ypos_new);


