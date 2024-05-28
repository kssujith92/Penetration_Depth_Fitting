function err=calculate_error(x,par)
    %function input to fminsearch in main_code
    %Used for finding the best fit
    [T,Yd,vars,C,in,En,m]=deal(par{:});
    V(vars)=x;V(in)=C;
    V=num2cell(V);
    [lam0,Tc,~,~,~,~,~]=deal(V{:});
    Y=1./((Yd/lam0)+1).^2;
    rho=calculate_rho(x,T,vars,C,in,En,m);
    err = goodnessOfFit(Y,rho,'MSE');
    scatter(T,Y); hold on;
    plot(T,rho,'r');hold off;
    M='ssdsdd';
    title([M(m) '+' M(3+m) ': Tc=' num2str(Tc) ' K'])
    drawnow