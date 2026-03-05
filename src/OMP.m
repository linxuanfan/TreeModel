function [ RMSE,Bset ] = OMP(X,Y,Ntr,P)
%OMP Summary of this function goes here
%   Ntr specifies the partition

% normalize first
k=1+P;

[N,M]=size(X);

Xtr=X(1:Ntr,:);
Ytr=Y(1:Ntr,:);

MX=mean(Xtr);
SX=std(Xtr);

MY=mean(Ytr);
SY=std(Ytr);

Xt=X(Ntr+1:end,:);
Yt=Y(Ntr+1:end,:);

Xtr=(Xtr-repmat(MX,Ntr,1))./repmat(SX,Ntr,1);
% 将训练集变换为均值为0、标准差为1的分布

Ytr=(Ytr-MY)/SY;

Xt=(Xt-repmat(MX,N-Ntr,1))./repmat(SX,N-Ntr,1);
% 将验证集变换为均值为0、标准差为1的分布

Numb=min(Ntr-1,M-1); % the maximum number of features
% Numb = 10;

% RMSE=zeros(1,Numb); % for each number of features, record the MAPE
RMSE = Inf(1, Numb); % for each number of features, initialize RMSE to Inf


res=Ytr; %上次迭代的残差
Bset=[]; %选的特征


% OMP迭代
for num=1:Numb % sequentially select the features and compute RMSE
    [coeff_b,coeff_c,res,Bset]=get_Model_OMP_r(Xtr,Ytr,res,Bset);
     YE=(Xt*coeff_b + coeff_c)*SY+MY;
     RMSE(num) = sqrt(mean((Yt - YE) .^ 2)); %用验证集算的RMSE
     if num > 5 % 判断是否不是第一次迭代
        % 判断当前RMSE是否比之前的增加超过20%
        if RMSE(num) > k * RMSE(num - 1)
            disp(['迭代在第 ', num2str(num), ' 步中断，因为RMSE增加超过20%']);
            break; % 中断循环
        end
    end
end



end

