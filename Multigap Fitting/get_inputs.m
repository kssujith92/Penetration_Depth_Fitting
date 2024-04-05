function [x,vars,C,in]=get_inputs(defin)
    %Function to get the input parameters from user (2d wave).
    %Tickboxes to select which parameters to vary.
    %Dialog box to get the initial guess/values.
    
    title='Select the parameters to vary';
    % Create figure
    h.f = figure('name',title,'NumberTitle','off',...
    'units','normalized','position',[0.4,0.4,0.3,0.3],...
             'toolbar','none','menu','none');
    % Create checkboxes
    h.c(2) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.3,0.3,0.5,0.1],'string','Tc');
    h.c(3) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.7,0.5,0.1],'string','Gap Ratio'); 
    h.c(4) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.1,0.5,0.5,0.1],'string','dC/C');
    h.c(1) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.3,0.1,0.5,0.1],'string','Lamda_0');
    h.c(5) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.3,0.2,0.5,0.1],'string','Weight');
    h.c(6) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.5,0.7,0.5,0.1],'string','Gap Ratio');
    h.c(7) = uicontrol('style','checkbox','units','normalized',...
                'position',[0.5,0.5,0.5,0.1],'string','dC/C');

    %Create OK pushbutton   
    h.p = uicontrol('style','pushbutton','units','normalized',...
                'position',[0.7,0.1,0.2,0.1],'string','OK',...
                'callback',@p_call);
    h.t1 = uicontrol('style','text','units','normalized',...
                'position',[0.1,0.85,0.1,0.1],'string','Gap 1');
    h.t2 = uicontrol('style','text','units','normalized',...
                'position',[0.5,0.85,0.1,0.1],'string','Gap 2');

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

    prompt={horzcat('Enter the value of parameters:-',...
        newline,newline,'Enter Lamda0 (Angstroms):'),'Tc :',...
        horzcat(newline,newline,'Gap 1',newline,'Gap Ratio'),'dC/C :','Weight factor:',...
        horzcat(newline,newline,'Gap 2',newline,'Gap Ratio :'),'dC/C :'};
    dim=[1 40];
    answ= inputdlg(prompt,'Parameters',dim,defin);

    lam0=cellfun(@str2num,answ(1));
    Tc=cellfun(@str2num,answ(2));
    gr1=cellfun(@str2num,answ(3));
    dC1=cellfun(@str2num,answ(4));
    r=cellfun(@str2num,answ(5));
    gr2=cellfun(@str2num,answ(6));
    dC2=cellfun(@str2num,answ(7));
    V=[lam0 Tc gr1 dC1 r gr2 dC2];
    x=V(vars);
    temp=1:1:length(V);
    in=setdiff(temp,vars);
    C=V(in);

end