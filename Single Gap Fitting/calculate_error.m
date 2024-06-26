function err=calculate_error(x,par)
    %function input to fminsearch in main_code
    %Used for finding the best fit
    [T,Yd,vars,C,in,En,m]=deal(par{:});
    V(vars)=x;V(in)=C;
    V=num2cell(V);
    [Tc,~,~,lam0]=deal(V{:});
    Y=1./((Yd/lam0)+1).^2;
    rho = calculate_rho(x,T,vars,C,in,En,m);
    err = goodnessOfFit(Y,rho,'MSE');
    scatter(T,Y); hold on;
    plot(T,rho,'r');hold off;
    M=['s', 'd'];
    t0=M(m);
    title([t0 ' wave fit: Tc=' num2str(Tc) ' K'])
    drawnow