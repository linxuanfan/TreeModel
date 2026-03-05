function [rmse,NoClasses]=Lmethod(x,y);
%
%
%  Description: This function applies the L-method (Salvador and Chan, 2005) for the estimation of the
%              appropriate number of classes on an evaluation graph.
%
%  Inputs:
%    x: x-coordinates of the evaluation graph (number of classes)
%    y: y-coordinates of the evaluation graph (value of a distance/similarity/error/quality)
%
%  Outputs:
%    rmse :  The total root mean squared error
%
%    NoClasses: the appropriate number of clusters based on the intersection 
%               of two best-fit lines to the left and right side around the
%               'knee', a critical location on the evaluation graph denoted
%               with a green square marker.
%
%
%  Example: 
%           close all, clc, clear all
%           x=[1:16]'; 
%           y=[44.51; 33.71; 26.11; 21.05; 17.19; 14.32; 12.50;	...
%              10.51; 7.63; 4.47; 2.47; 2.02; 2.00; 2.00; 2.00; 2.00];
%           [rmse,NoClasses]=Lmethod(x,y)
%     
% 
%  Figures: 
%       upper left: the evaluation graph
%       upper right: all the possible best-fit lines (green & red pairs)
%       lower left: the minimization of RMSE (a green square marker denotes the 'knee')
%       lower right: the best-fit lines correnspoding to the minimum RMSE  
% 
%
%  *** Further details about this function can be found in the paper : 
%       Salvador, S., Chan, P., 2005. Learning States and Rules for Detecting 
%       Anomalies in Time Series. Applied Intelligence 23(3), 241-255.
%
%  Version 2.00 (23/10/2012) <----
%  Version 1.00 (17/02/2012)
% ************************************************************************************************************
% ************************************************************************************************************
% If you use this code for academic use, it would be appreciated to cite the following publication(s) in you work:
% 
% *** [1] A. Zagouras, R.H. Inman, C.F.M. Coimbra, On the determination of coherent solar microclimates for utility planning and operations, 
% Solar Energy, Volume 102, April 2014, Pages 173-188, 
% ISSN 0038-092X, http://dx.doi.org/10.1016/j.solener.2014.01.021.
% 
% *** [2] A. Zagouras, A. Kazantzidis, E. Nikitidou, A.A. Argiriou, Determination of measuring sites for solar irradiance, based on cluster analysis of satellite-derived cloud estimations, 
% Solar Energy, Volume 97, November 2013, Pages 1-11, 
% ISSN 0038-092X, http://dx.doi.org/10.1016/j.solener.2013.08.005.
% 
%
% Any questions or comments are mostly welcome; please contact me at my email address below.
%
%
%  Copyright (c) 2012, Athanassios Zagouras, University of California, San Diego (UCSD)
%  All rights reserved.
%  Email: azagouras@eng.ucsd.edu; thzagouras@gmail.com; 
% ************************************************************************************************************
% ************************************************************************************************************
ffont=10;
axfsize=10;
marks=12;
subplot(2,2,1); 
plot(x,y,'b.-','MarkerSize', marks); xlim([0 max(x)+2]);
title('Evaluation Graph','FontSize',ffont,'FontWeight','bold')
xlabel('Number of classes','FontSize',ffont);
ylabel('Evaluation Metric','FontSize',ffont);
Fit1=polyfit(x,y,1);
yfit = Fit1(1)*x + Fit1(2);
hold on;
data=y; estimate=yfit;
rmse_1line=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));
t=0;
for c=2:length(data)-2; t=t+1;
    %-------------------------------&
    
    
    Fit10=polyfit(x(1:c),y(1:c),1);
    yfit_10 = Fit10(1)*x(1:c) + Fit10(2);
    
    subplot(2,2,2); 
    
    hold on; plot(x(1:c),yfit_10,'r'); xlim([0 max(x)+2]);
    
    Fit20=polyfit(x(c+1:end),y(c+1:end),1);
    yfit_20 = Fit20(1)*x(c+1:end) + Fit20(2);
    hold on; plot(x(c+1:end),yfit_20,'g');
    hold on; plot(x,y,'b.','MarkerSize', marks);
    
    title('Possible Fit Lines','FontSize',ffont,'FontWeight','bold')
    xlabel('Number of classes','FontSize',ffont);
    ylabel('Evaluation Metric','FontSize',ffont);
    
    %-------------------------------&
    
    dataL=y(1:c); estimateL=yfit_10;
    rmseL=sqrt(sum((dataL(:)-estimateL(:)).^2)/numel(dataL));
    
    dataR=y(c+1:end); estimateR=yfit_20;
    rmseR=sqrt(sum((dataR(:)-estimateR(:)).^2)/numel(dataR));
    
    c_factor=x(c);
    b_factor=x(end);
    rmse_t=(c_factor-1)./(b_factor-1)*rmseL + ...
        (b_factor-c_factor)./(b_factor-1)*rmseR ;
    %-------------------------------&
    rmse(t)=rmse_t;
    c_all(t)=c;
    
    clear Fit10 Fit20 b_factor c_factor dataL dataR estimateL estimateR...
        rmseL rmseR yfit_10 yfit_20 rmse_t data estimate
end
subplot(2,2,3); plot(x(2:end-2),rmse,'k.:', 'MarkerSize',marks); xlim([0 max(x)+2])
title('RMSE','FontSize',ffont,'FontWeight','bold')
xlabel('Number of classes','FontSize',ffont);
ylabel('RMSE_c','FontSize',ffont);
set(gca,'fontsize',axfsize);
[val,pos]=min(rmse); BestPos=pos+1; NoClasses=x(BestPos);
hold on;
plot(x(BestPos),rmse(BestPos),'gs:','MarkerSize',12);
% ----------------------------- &
% Best-fit lines :
% figure
subplot(2,2,4); plot(x,y,'b.','MarkerSize', marks); xlim([0 max(x)+2])
FitBest1=polyfit(x(1:pos+1),y(1:pos+1),1);
yfit_Best = FitBest1(1)*x(1:pos+1) + FitBest1(2);
hold on; plot(x(1:pos+1),yfit_Best,'r','MarkerSize', marks,'LineWidth',2); 
set(gca,'fontsize',axfsize);
FitBest2=polyfit(x(pos+2:end),y(pos+2:end),1);
yfit_Best2 = FitBest2(1)*x(pos+2:end) + FitBest2(2);
hold on; plot(x(pos+2:end),yfit_Best2,'g','MarkerSize', marks,'LineWidth',2);
set(gca,'fontsize',axfsize);
title('Best Fit Lines','FontSize',ffont,'FontWeight','bold')
xlabel('Number of classes','FontSize',ffont);
ylabel('Evaluation Metric','FontSize',ffont);