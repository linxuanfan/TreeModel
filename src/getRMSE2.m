function RMSE=getRMSE2(X,Y,MY,SY,Ntr)
%GETMAPE2 Summary of this function goes here
%   Ntr indicates the partition of training and validation

% Xtr：标准化后的训练数据（特征）。
% Ytr：标准化后的训练数据（标签）。
% Xt：标准化后的测试数据（特征）。
% coeff：线性回归模型的回归系数。
% SYtr 和 MYtr：训练标签 Ytr 的标准差和均值，用于将预测的标准化结果转换回原始尺度。
% SY 和 MY：原始标签 Y 的标准差和均值，用于最终的反标准化。

[N,M]=size(X);

Xtr=X(1:Ntr,:);
Ytr=Y(1:Ntr,:);

Xt=X(Ntr+1:end,:);
Yt=Y(Ntr+1:end,:);

% normalize

MXtr=mean(Xtr);
SXtr=std(Xtr);

MYtr=mean(Ytr);
SYtr=std(Ytr);

Xtr=(Xtr-repmat(MXtr,Ntr,1))./repmat(SXtr,Ntr,1); % 减均值除标准差

Ytr=(Ytr-MYtr)/SYtr; % 减均值除标准差

Xt=(Xt-repmat(MXtr,N-Ntr,1))./repmat(SXtr,N-Ntr,1); %用测试集
% 每列将具有零均值和单位方差

% fit model and estimate

coeff=Xtr\Ytr;  %使用标准化后的训练数据进行线性回归，得到回归系数
% X = A\B 表示求解方程组 A*X = B。
YE=(Xt*coeff*SYtr+MYtr)*SY+MY; %回归系数计算预测值，返回原始尺度

YR=Yt*SY+MY;

RMSE = sqrt(mean((YR - YE) .^ 2)); % compute RMSE实际值-预测值

end

