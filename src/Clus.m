function Selec=Clus(Data)
    [~,Selecm]=max(Data); % take in the correlation values and find the maximum one
    Z=linkage(Data,'complete','euclidean'); % use hierarchical clustering
    Dis=fliplr(Z(:,3)'); % extract the distance of merging
    RMSE=Inf;
    N_op = 1;
    for n=1:length(Dis) % use 2 lines to fit the distance curve 
        if n==1         % compute the root mean square distance
            X1=1;       % find the position with minimum weighted root mean square error
            Yr1=Dis(n);
            Y1=Dis(n);
            X2=n+1:length(Dis);
            Y2=Dis(n+1:end);
            [a2,b2]=Fit(X2,Y2);
            Yr2=X2*a2+b2;
        else
            Y1=Dis(1:n);
            Y2=Dis(n+1:end);
            X1=1:n;
            X2=n+1:length(Dis);
            [a1,b1]=Fit(X1,Y1);
            [a2,b2]=Fit(X2,Y2);
            Yr1=X1*a1+b1;
            Yr2=X2*a2+b2;
        end
        rms=sqrt(length(X1))*norm(Yr1-Y1)+sqrt(length(X2))*norm(Yr2-Y2);            
        if rms<RMSE
            RMSE=rms;
            N_op=n;
            Line=[Yr1,Yr2];
        end
    end
    C=cluster(Z,'maxclust',N_op); % find the clustering of each feature
    Selec=find(C==C(Selecm)); % find the features in the same cluster with maximum correlation
end





