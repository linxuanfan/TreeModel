function RMSE=getRMSE1(X,Y,MY,SY,Ntr)
%GETMAPE2 Summary of this function goes here
%   Ntr indicates the partition of training and validation


[N,M]=size(X);

Xtr=X(1:Ntr,:);
Ytr=Y(1:Ntr,:);

% normalize

MXtr=mean(Xtr);
SXtr=std(Xtr);

MYtr=mean(Ytr);
SYtr=std(Ytr);

Xtr=(Xtr-repmat(MXtr,Ntr,1))./repmat(SXtr,Ntr,1);

Ytr=(Ytr-MYtr)/SYtr;

% fit model and estimate

coeff=Xtr\Ytr;
YE=(Xtr*coeff*SYtr+MYtr)*SY+MY;

YR=(Ytr*SYtr+MYtr)*SY+MY;

RMSE=sqrt(mean((YR - YE) .^ 2)); % compute RMSE

end

