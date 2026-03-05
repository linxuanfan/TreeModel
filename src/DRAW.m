


close all;


j=13;


Numbin=max(C(:,j));

Xbin=[];
Ybin=[];
for indbin=1:Numbin
    Xbin{indbin}=Xtrain2(C(:,j)==indbin,j);
    Ybin{indbin}=Ytrain(C(:,j)==indbin);
end


scatter(Xtrain2(:,j),Ytrain(:,pred),30,C(:,j));
figure;plot(Dis(j,:),'-ob');
hold on;plot(1:N_op(j),Line(j,1:N_op(j)),'r','linewidth',2);
hold on;plot(N_op(j)+1:length(Line(j,:)),Line(j,N_op(j)+1:end),'r','linewidth',2);
title('Fitting');
figure;hist(C(:,j),max(C(:,j)));

figure;semilogy(Error(j,:),'-ob');xlabel('Number of Clusters');ylabel('Fitting Error');