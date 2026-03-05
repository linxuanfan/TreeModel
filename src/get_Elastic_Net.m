function [w, intercept, rmse_train, rmse_test]=get_Elastic_Net(X, y, Xt, Yt, SY)
% alphas = [0.2, 0.4, 0.6];
alphas = linspace(0.05, 1.0, 50);  % 待测试的 Alpha 值
n_folds = 4;                         % 4 折交叉验证
mse_values = zeros(length(alphas), 1);
coef_values = cell(length(alphas), 1);
int_values = zeros(length(alphas), 1);
lamb_values = zeros(length(alphas), 1);

for i = 1:length(alphas)
    % 交叉验证
    [B, FitInfo] = lasso(X, y, 'Alpha', alphas(i), 'CV', n_folds);
    
    % 记录最小 MSE
    % mse_values(i) = FitInfo.MSE(FitInfo.IndexMinMSE);
    % 记录测试集MSE
    coef = B(:, FitInfo.IndexMinMSE);
    interc = FitInfo.Intercept(FitInfo.IndexMinMSE);
    lamb = FitInfo.Lambda(FitInfo.IndexMinMSE);

    y_pred = Xt * coef + interc;
    mse_values(i) = mean((Yt-y_pred).^2);

    coef_values{i} = coef;
    int_values(i) = interc;

    lamb_values(i) = lamb;
    
end

% 找到最优 Alpha
[min_mse, best_alpha_idx] = min(mse_values);
best_alpha = alphas(best_alpha_idx);

% 用最优 Alpha 重新训练模型
% [B_final, FitInfo_final] = lasso(X, y, 'Alpha', best_alpha, 'CV', n_folds);

w = coef_values{best_alpha_idx};
intercept = int_values(best_alpha_idx);

% test1 rmse  记得乘以缩放系数
rmse_test = sqrt(min_mse) * SY;
y_train_pred = X * w + intercept;
rmse_train = sqrt(mean((y_train_pred - y).^2)) * SY;

% 输出结果
disp(['最优 Alpha: ', num2str(best_alpha)]);
disp(['最优 Lambda: ', num2str(lamb_values(best_alpha_idx))]);
disp('最优系数:');
% disp(B_final(:, FitInfo_final.IndexMinMSE)');
disp(w');
% intercept = FitInfo_final.Intercept(FitInfo_final.IndexMinMSE);
end