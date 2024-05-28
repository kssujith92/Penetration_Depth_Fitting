function Ylam=calculate_lamda(x,T,V,En,m)
    %function input to nlinfit in main_code (s+d wave)
    %Used in calculating error bar in lamda0
    lam0=x;
    [~,Tc,gr1,dC1,r,gr2,dC2]=deal(V{:});
    x=[];
    vars=[];
    C=[lam0 Tc gr1 dC1 r gr2 dC2];
    in=[1 2 3 4 5 6 7];
    rho=calculate_rho(x,T,vars,C,in,En,m);
    Ylam=lam0*((1./sqrt(rho))-1);