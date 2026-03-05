function MAPE=getMAPE(X,Y,MY,SY,Nh) %线性规划之后求残差/不同求残差方法
% X为124*54的特征值，
% Y为124*1的标签值的残差，
% MY为均值，SY为标准差，Ntr为训练数据个数,Levx为最大层数，Num为最大总节点数
%Nh=4;


N=size(X,1);
h=round(N/Nh);
    
ST=zeros(1,Nh);
EN=zeros(1,Nh);
    
for nh=1:Nh
    ST(1,nh)=(nh-1)*h+1;
    EN(1,nh)=min((nh-1)*h+h,N);
end
    
NS=length(ST);

YE=zeros(N,1);

for cv_index=1:NS
    cv_fold=ST(cv_index):EN(cv_index);
    temp_index=setxor(1:N,cv_fold);
    data_x_train = X(temp_index,:); 
    data_y_train = Y(temp_index,1);
    data_x_test = X(cv_fold,:);
            
    % normalize x again   
    for col=1:size(X,2)
        MXtr=mean(data_x_train(:,col));    
        SXtr=std(data_x_train(:,col));    
        data_x_train(:,col)=(data_x_train(:,col)-MXtr)/max(0.000000000001,SXtr);    
        data_x_test(:,col)=(data_x_test(:,col)-MXtr)/max(0.000000000001,SXtr); 
    end
    
    % normalize y again
    MYtr=mean(data_y_train);
    SYtr=std(data_y_train);
    data_y_train=(data_y_train-MYtr)/max(0.000000000001,SYtr); 
    coeff=data_x_train\data_y_train;
    YE(cv_fold,1) = data_x_test*coeff*SYtr+MYtr;
end

YE=YE*SY+MY;
YR=Y*SY+MY;

MAPE=mean(abs((YR-YE)./YR));

end



