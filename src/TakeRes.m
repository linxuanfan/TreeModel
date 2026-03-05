function Res=TakeRes(X,Y)

Coeff=X\Y;

Res=Y-X*Coeff; % use X to fit Y and compute the residual

end