clear;
clc;
close all;

% 结果保存路径
exp_dir = 'linear_reg_result_all/';
if ~exist(exp_dir, 'dir')
    mkdir(exp_dir);
end

% 获取日期
today_mmdd = datestr(now, 'mmdd');

% 加载数据
Xo = xlsread('data/feature_1104_124x55'); 
Y = xlsread('data/label.xls'); 
N = size(Xo, 1);
feature_nums = size(Xo, 2);

seed_list = [3407,34,1225,271];
seed_nums = size(seed_list, 2);

for seed_id = 1:seed_nums
    seed = seed_list(seed_id);
    % 设置随机种子以确保每次运行结果一致，代表打乱顺序
    % seed = 3407;
    rng(seed);
    
    randomIndex = randperm(N);
    Xo = Xo(randomIndex, :);  %124x53 列都被保持）
    Y = Y(randomIndex, :);
    % 随机生成相同的置乱索引，并对Xo和Y进行置乱
    
    % 计算平移量（20%）
    shift_amount = floor(N * 0.2);
    % 生成新的索引
    shiftIndex = mod((1:N) + shift_amount - 1, N) + 1;
    train_times = 5;
    
    Tset = [7,1,56];
    
    sum_rmse_all = 0;
    sum_rmse_2 = 0;
    
    disp(['Seed is ', num2str(seed)]);
    
    for random = 1:train_times
        % 向前平移20% ，最后20%留作验证集
    
        Xo = Xo(shiftIndex, :);  %124x53 列都被保持）
        Y = Y(shiftIndex, :);
    
        Nh = 10; % means we use 8/10 data for training and 2/10 for validation
        Ntr = floor(N/Nh*(Nh-2)); % 向下取整 8/10 做训练集
    
        Var = var(Xo(1:Ntr, :)); % 计算每个特征的方差 方差小说明预测没啥用
        indv = find(Var ~= 0); 
        X = Xo(:, indv); % 选择在训练集中方差不为零的特征
    
        Xr = (X - repmat(mean(X(1:Ntr, :)), N, 1)) ./ repmat(std(X(1:Ntr, :)), N, 1);
        MY1 = mean(Y(1:Ntr, 1));
        SY1 = std(Y(1:Ntr, 1));
        Y1 = (Y(:, 1) - MY1) / SY1;
    
        RMSE_all = getRMSE2(Xr,Y1,MY1,SY1,Ntr);
        RMSE_2 = getRMSE2(Xr(:,Tset),Y1,MY1,SY1,Ntr);
        
        disp(['Fold ' num2str(random)]);
        disp(['all features result is ' num2str(RMSE_all)]);
        disp(['selected features result is ' num2str(RMSE_2)]);
        
        sum_rmse_all = sum_rmse_all + RMSE_all;
        sum_rmse_2 = sum_rmse_2 + RMSE_2;
    end
    
    disp(['Average of ' num2str(random) 'Folds']);
    disp(['Average all features result is ' num2str(sum_rmse_all / train_times)]);
    disp(['Average selected features result is ' num2str(sum_rmse_2 / train_times)]);


end




