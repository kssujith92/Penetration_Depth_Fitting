function err=calculate_error(x,par)
    %function input to fminsearch in main_code
    %Used for finding the best fit
    [T,Yd,vars,C,in,En,m]=deal(par{:});
    V(vars)=x;V(in)=C;
    V=num2cell(V);
    [lam0,Tc,gr1,dC1,r,gr2,dC2]=deal(V{:});
    Y=1./((Yd/lam0)+1).^2;
    Gap1=real(gr1*Tc*tanh((pi/gr1)*sqrt((2/3)*dC1*((Tc./T)-1))));
    Gap2=real(gr2*Tc*tanh((pi/gr2)*sqrt((2/3)*dC2*((Tc./T)-1))));
    rho1=zeros(length(T),1);
    rho2=zeros(length(T),1);
    switch(m)
        case 1
            fun1=@(E) exp(sqrt(E.^2+Gap1.^2)./T)./(T.*(exp(sqrt(E.^2+Gap1.^2)./T)+1).^2);
            rho1 = 1-2*integral(fun1,0,100,'ArrayValued',true);
            fun2=@(E) exp(sqrt(E.^2+Gap2.^2)./T)./(T.*(exp(sqrt(E.^2+Gap2.^2)./T)+1).^2);
            rho2 = 1-2*integral(fun2,0,100,'ArrayValued',true);
        case 2
            fun1=@(E) exp(sqrt(E.^2+Gap1.^2)./T)./(T.*(exp(sqrt(E.^2+Gap1.^2)./T)+1).^2);
            rho1 = 1-2*integral(fun1,0,100,'ArrayValued',true);
            for i=1:length(T)
                fun2=@(E,phi) exp(sqrt(E.^2+(Gap2(i)*cos(2*phi)).^2)./T(i))./(T(i).*(exp(sqrt(E.^2+(Gap2(i)*cos(2*phi)).^2)./T(i))+1).^2);
                rho2(i)=1-(1/pi)*integral2(@(E,phi)fun2(E,phi),0,En(i),0,2*pi);
            end
        case 3
            for i=1:length(T)
            fun1=@(E,phi) exp(sqrt(E.^2+(Gap1(i)*cos(2*phi)).^2)./T(i))./(T(i).*(exp(sqrt(E.^2+(Gap1(i)*cos(2*phi)).^2)./T(i))+1).^2);
            fun2=@(E,phi) exp(sqrt(E.^2+(Gap2(i)*cos(2*phi)).^2)./T(i))./(T(i).*(exp(sqrt(E.^2+(Gap2(i)*cos(2*phi)).^2)./T(i))+1).^2);
            rho1(i)=1-(1/pi)*integral2(@(E,phi)fun1(E,phi),0,En(i),0,2*pi);
            rho2(i)=1-(1/pi)*integral2(@(E,phi)fun2(E,phi),0,En(i),0,2*pi);
            end
    end
    rho=r*rho1+(1-r)*rho2;
    err = goodnessOfFit(Y,rho,'MSE');
    scatter(T,Y); hold on;
    plot(T,rho,'r');hold off;
    M='ssdsdd';
    title([M(m) '+' M(3+m) ': Tc=' num2str(Tc) ' K'])
    drawnow