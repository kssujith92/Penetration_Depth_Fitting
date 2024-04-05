function [x,vars,C,in]=get_inputs(defin)
    %Function to get the input parameters from user.
    %Tickboxes to select which parameters to vary.
    %Dialog box to get the initial guess/values.
    
    title='Select the parameters to vary';
    % Create figure
    h.f = figure('name',title,'NumberTitle','off',...
    'units','normalized','position',[0.4,0.4,0.2,0.3],...
             'toolbar','none','menu','none');
    % Create checkboxes
    h.c(1) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.8,0.5,0.1],'string','Tc');
    h.c(2) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.6,0.5,0.1],'string','Gap Ratio'); 
    h.c(3) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.4,0.5,0.1],'string','dC/C'); 
    h.c(4) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.2,0.5,0.1],'string','Lamda_0');
    %Create OK pushbutton   
    h.p = uicontrol('style','pushbutton','units','normalized',...
                'position',[0.6,0.1,0.3,0.1],'string','OK',...
                'callback',@p_call);

    % Pushbutton callback
    function p_call(varargin)
        vals = get(h.c,'Value');
        vars = find([vals{:}]);
        if isempty(vars)
            msgbox('Pls select atleast one variable')
            return
        end
        close(h.f);
    end
    uiwait(h.f)

    dims=[1 60];
    promp={horzcat('Enter the value(guess) of fixed(variable) parameters:-',...
        newline,newline,'Enter Tc (Kelvin):'),'Gap ratio :','dC/C:','Lamda0 (Angstroms):'};
    answ= inputdlg(promp,'Parameters',dims,defin);
    Tc=cellfun(@str2num,answ(1));
    gr=cellfun(@str2num,answ(2));
    dC=cellfun(@str2num,answ(3));
    lam0=cellfun(@str2num,answ(4));
    V=[Tc gr dC lam0];
    x=V(vars);
    temp=1:1:length(V);
    in=setdiff(temp,vars);
    C=V(in);

end