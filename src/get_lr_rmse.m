function RMSE=get_lr_rmse(X,Y)
N = size(X,1);
MX = mean(X);
SX = std(X);
Xr=(X-repmat(MX,N,1))./repmat(SX,N,1);

MY = mean(Y);
SY = std(Y);
Yr=(Y-MY)./SY;

coeff=Xr\Yr;

YE=Xr*coeff*SY+MY;

RMSE = sqrt(mean((YR - YE) .^ 2));

end