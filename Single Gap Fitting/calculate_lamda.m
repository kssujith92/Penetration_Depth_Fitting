function Ylam=calculate_lamda(x,T,gr,Tc,dC,En,m)
    %function input to nlinfit in main_code
    %Used in calculating error bar in lamda0
    lam0=x;
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
    Ylam=lam0*((1./sqrt(rho))-1);
    