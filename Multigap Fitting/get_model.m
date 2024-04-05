function [m]=get_model()
    %Function to get the input parameters from user.
    %Tickboxes to select which parameters to vary.
    %Dialog box to get the initial guess/values.
    
    title='Select the gap function to use';
    % Create figure
    h.f = figure('name',title,'NumberTitle','off',...
    'units','normalized','position',[0.4,0.45,0.15,0.2],...
             'toolbar','none','menu','none');
    % Create checkboxes
    h.c(1) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.75,0.5,0.1],'string','s + s');
    h.c(2) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.5,0.5,0.1],'string','s + d'); 
    h.c(3) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.25,0.5,0.1],'string','d + d');
    %Create OK pushbutton   
    h.p = uicontrol('style','pushbutton','units','normalized',...
                'position',[0.6,0.1,0.3,0.1],'string','OK',...
                'callback',@p_call);

    % Pushbutton callback
    function p_call(varargin)
        vals = get(h.c,'Value');
        m = find([vals{:}]);
        if isempty(m)
            msgbox('Pls select atleast one model')
            return
        elseif length(m)>1
            msgbox('Pls select one model only')
            return
        end
        close(h.f);
    end
    uiwait(h.f)

end