%Code to fit superfluid density with a single gap with Tc, Gap ratio, dC/C, and lamda0 as parameters
%Select the data file(delta_lamba) and enter the parameters when prompted. 
%Input data should be delta_lamda data as a text file (Temperature,delta_lamda) without headers.
%This code requires functions 'get_inputs.m','calculate_error.m','calculate rho.m', and 'calculate_lamda.m' in the same folder.
%Output data will be stored in the same folder as data (Temperature,Rho_data,Rho_fit).

close all;

%[name,path,check]= uigetfile('.txt','Import delta_lamda data from');

data = importdata(fullfile(path,name));
T=data(:,1);
Yd=data(:,2);

m=get_model();

defin={'5','2','1','2550'}; %default initial values
%pars=[Tc,gr,dC,lam0(A)]
LB=[0,0,0,500];    %lower bounds
UB=[10,5,5,10000];    %upper bounds

[x,vars,C,in]=get_inputs(defin);
lb=double(LB(vars));ub=double(UB(vars));
V=zeros(1,4);
V(vars)=abs(x);V(in)=C;

%interpolation for speedy computation
T1=T;
Yd1=Yd;
Ti=0.3*V(1);
T=[(T1(1):0.02:Ti) (Ti:0.05:T1(length(T1)))]'; %can change the T intervals here.
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

disp('Starting Optimization...')

opts = optimoptions('fmincon','Display','final');
par={T,Yd,vars,C,in,En,m};
[x,err,~,~,L,~,H] = fmincon(@(x) calculate_error(x,par),x,[],[],[],[],lb,ub,[],opts);
V=zeros(1,4);
V(vars)=x;V(in)=C;
V=num2cell(V);
[Tc,gr,dC,lam0]=deal(V{:}); %values for best fit
Y=1./((Yd/lam0)+1).^2;
rho=calculate_rho(x,T,vars,C,in,En,m);
dx=sqrt(diag(inv(H)));

dV=zeros(1,4);
dV(vars)=dx;dV(in)=0;
dV=num2cell(dV);
[dTc,dgr,ddC,dlam0]=deal(dV{:}); %errror bars

if(any(vars==4))
    Tt=T(T<Tc);Ydt=Yd(1:length(Tt));
    x=lam0;
    [x,R,J]=nlinfit(Tt,Ydt,@(x,Tt)calculate_lamda(x,Tt,V,En,m),x);
    ci = nlparci(x,R,'jacobian',J);
    dlam0=(ci(1,2)-ci(1,1))/2; %error bar for lamda0
end
toc

fdat=[T,Y,rho];
n0=['s' 'd'];
f0=['fit_',n0(m),'wave'];
F=[f0,'_',name];
dlmwrite(fullfile(path,F), 'T(K),Data,Fit', 'delimiter',''); %save data to file
dlmwrite(fullfile(path,F), fdat, '-append', 'precision',9,'newline', 'pc');

sp=[' ' char(177) ' '];
par=['Parameters for fit :-' char(10) 'Tc: ' num2str(Tc) sp num2str(dTc) char(10) ...
    'Gap Ratio: ' num2str(gr) sp num2str(dgr) char(10) ...
    'dC/C: ' num2str(dC) sp num2str(ddC) char(10) ...
    'Lamda0 : ' num2str(lam0) sp num2str(dlam0) char(10) ...
    'MSE : ' num2str(err) char(10) 'Output File: ' F];
uicontrol('Style', 'text','String', par,'Units','normalized','Position', [0.5 0.6 0.4 0.3]);
saveas(gcf,[path,f0,'.png']);
disp(par);
