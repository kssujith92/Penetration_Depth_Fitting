%Code to fit superfluid density with a multi-gap with Tc (Tc1=Tc2), Gap ratio,dC/C,and lamda0 as parameters.
%Select the data file(delta_lambda) and enter the parameters when prompted. 
%Input data should be delta_lamda data as a text file(Temperature,delta_lamda) without headers.
%This code requires functions 'get_inputs.m','calculate_error.m','calculate rho.m', and 'calculate_lamda.m' in the same folder.
%Output data will be stored in the same folder as data (Temperature,Rho_data,Rho_fit).

close all;

[name,path,check]= uigetfile('.txt','Import delta_lamda data from');

data = importdata(fullfile(path,name));

T=data(:,1);
Yd=data(:,2);

m=get_model();

defin={'2550','5','1','1','0.5','3','2'}; %default initial values
%pars=[lam0,Tc,gr1,dC1,r,gr2,dC2]
LB=[500,0,0,0,0,0,0];    %lower bounds
UB=[10000,15,5,5,1,5,5];    %upper bounds

[x,vars,C,in]=get_inputs(defin);
lb=double(LB(vars));ub=double(UB(vars));
V=zeros(1,7);
V(vars)=abs(x);V(in)=C;

%interpolation for speedy computation
T1=T;
Yd1=Yd;
Ti=0.3*V(2);
T=[(T1(1):0.02:Ti) (Ti:0.05:T1(length(T1)))]';  %can change intervals for T here
Yd = interp1(T1,Yd1,T);

tic;

%calculate upper limits for E
Tx=(T(1):0.1:T(length(T))+1);
Enx=Tx;i=1;
for t=Tx    
    syms Ee;
    Enx(i) = abs(vpasolve(+exp(Ee/t)/(t*(exp(Ee/t)+1)^2)-0.00001*(1/(t*4)),Ee));
    i=i+1;  
end
En=interp1(Tx,Enx,T);

disp('Starting optimization...')

opts = optimoptions('fmincon','Display','final');
par={T,Yd,vars,C,in,En,m};
[x,err,~,~,L,~,H] = fmincon(@(x) calculate_error(x,par),x,[],[],[],[],lb,ub,[],opts); %fmincon
V=zeros(1,7);
V(vars)=x;V(in)=C;
V=num2cell(V);
[lam0,Tc,gr1,dC1,r,gr2,dC2]=deal(V{:}); %values for best fit
Y=1./((Yd/lam0)+1).^2;
rho=calculate_rho(x,T,vars,C,in,En,m);
dx=sqrt(diag(inv(H)));

dV=zeros(1,7);
dV(vars)=dx;dV(in)=0;
dV=num2cell(dV);
[dlam0,dTc,dgr1,ddC1,dr,dgr2,ddC2]=deal(dV{:}); %errror bars

if(any(vars==1))
    Tt=T(T<Tc);Ydt=Yd(1:length(Tt));
    x=lam0;
    [x,R,J]=nlinfit(Tt,Ydt,@(x,Tt)calculate_lamda(x,Tt,V,En,m),x);
    ci = nlparci(x,R,'jacobian',J);
    dlam0=(ci(1,2)-ci(1,1))/2; %error bar for lamda0
end
toc

M='ssdsdd';
f0=['fit_' M(m) '+' M(3+m)];
fdat=[T,Y,rho];
F=[f0,'_',name];
dlmwrite(fullfile(path,F), 'T(K),Data,Fit', 'delimiter',''); %save data to file
dlmwrite(fullfile(path,F), fdat, '-append', 'precision',9,'newline', 'pc');

sp=[' ' char(177) ' '];
par=['Parameters for fit :-' newline ...
    'Tc: ' num2str(Tc) sp num2str(dTc) ' K' newline ...
    'Gap1' newline 'Gap Ratio: ' num2str(gr1) sp num2str(dgr1) newline ...
    'dC/C: ' num2str(dC1) sp num2str(ddC1) newline ...
    'Weight : ' num2str(r) sp num2str(dr) newline ...
    'Gap2' newline 'Gap Ratio: ' num2str(gr2) sp num2str(dgr2) newline ...
    'dC/C: ' num2str(dC2) sp num2str(ddC2) newline ...
    'Lamda0 : ' num2str(lam0) sp num2str(dlam0) ' A' newline ...
    'MSE : ' num2str(err) newline 'Output File: ' F];
uicontrol('Style', 'text','String', par,'Units','normalized','Position', [0.5 0.4 0.38 0.52]); 
saveas(gcf,[path,f0,'.png']);
disp(par);
