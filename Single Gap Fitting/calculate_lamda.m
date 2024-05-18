function Ylam=calculate_lamda(x,T,V,En,m)
    %function input to nlinfit in main_code
    %Used in calculating error bar in lamda0
    lam0=x;
    [Tc,gr,dC,~]=deal(V{:});
    x=[];
    vars=[];
    C=[Tc gr dC lam0];
    in=[1 2 3 4];
    rho = calculate_rho(x,T,vars,C,in,En,m);
    Ylam=lam0*((1./sqrt(rho))-1);
    