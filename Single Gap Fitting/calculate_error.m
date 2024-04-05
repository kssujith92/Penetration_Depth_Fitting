function err=calculate_error(x,par)
    %function input to fminsearch in main_code
    %Used for finding the best fit
    [T,Yd,vars,C,in,En,m]=deal(par{:});
    V(vars)=x;V(in)=C;
    V=num2cell(V);
    [Tc,gr,dC,lam0]=deal(V{:});
    Y=1./((Yd/lam0)+1).^2;
    Gap=real(gr*Tc*tanh((pi/gr)*sqrt((2/3)*dC*((Tc./T)-1))));
    rho=zeros(length(T),1);
    switch m
        case 1
            fun=@(E) exp(sqrt(E.^2+Gap.^2)./T)./(T.*(exp(sqrt(E.^2+Gap.^2)./T)+1).^2);
            rho = 1-2*integral(fun,0,100,'ArrayValued',true);
        case 2
            for i=1:length(T)
                fun=@(E,phi) exp(sqrt(E.^2+(Gap(i)*cos(2*phi)).^2)./T(i))./(T(i).*(exp(sqrt(E.^2+(Gap(i)*cos(2*phi)).^2)./T(i))+1).^2);
                rho(i)=1-(1/pi)*integral2(@(E,phi)fun(E,phi),0,En(i),0,2*pi);
            end
    end
    err = goodnessOfFit(Y,rho,'MSE');
    scatter(T,Y); hold on;
    plot(T,rho,'r');hold off;
    M=['s', 'd'];
    t0=M(m);
    title([t0 ' wave fit: Tc=' num2str(Tc) ' K'])
    drawnow