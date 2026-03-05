clear;
clc;
close all;

rng(38);

% 结果保存路径
exp_dir = 'result/xjtu/';
if ~exist(exp_dir, 'dir')
    mkdir(exp_dir);
end

% 获取日期
today_mmdd = datestr(now, 'mmdd');

%% XJTU
Xo = xlsread('data/xjtu_feature.xlsx');
Y = xlsread('data/xjtu_label.xlsx');

% Xo = Xo(:,Tset);

train_idx = 9:23;
test_idx = 1:8;

%% tree model
N = size(Xo, 1);
feature_nums = size(Xo, 2);

% 树模型
% 将数据重新拼接一下，train 和 test 做为训练和验证集
X_tree = cat(1, Xo(train_idx,:), Xo(test_idx,:));
Y_tree = cat(1, Y(train_idx,:), Y(test_idx,:));
Ntr = size(train_idx, 2);


Xr = (X_tree - repmat(mean(X_tree(1:Ntr, :)), N, 1)) ./ repmat(std(X_tree(1:Ntr, :)), N, 1);
MY1 = mean(Y_tree(1:Ntr, 1));
SY1 = std(Y_tree(1:Ntr, 1));
Y1 = (Y_tree(:, 1) - MY1) / SY1;
                 

P = 0.2; % stop growing tree if MAPE increase is larger than 120%
Num = 20; % maximum 20 nodes in each level N

[Tree1, Link1] = GenerateTree2(Xr, Y1, MY1, SY1, Ntr, Num, P);
[Model1, RMSE1] = ExtractModel(Tree1, Link1);

% 找到最小的Tree set
best_idx = find(RMSE1 == min(RMSE1));
selectedModels = Model1(best_idx);
best_T_set = selectedModels{1};
tree_rmse_test = min(RMSE1);

%% OMP
[RMSEo1, Set1] = OMP(X_tree, Y_tree(:,1), Ntr, P);
OMP_rmse_test = min(RMSEo1);

%% ElasticNet

en_rmse_test = 26; % paper



%% 绘制 RMSE 曲线，并与 Elastic Net 方法的结果比较

figure('Position', [100 100 2600 350]);

set(groot, 'defaultAxesFontName', 'Arial');       % 坐标轴字体
set(groot, 'defaultTextFontName', 'Arial');        % 文本字体
set(groot, 'defaultLegendFontName', 'Arial');      % 图例字体
set(groot, 'defaultColorbarFontName', 'Arial');    % 颜色条字体
% title('XJTU Dataset','FontSize', 16); legend('Proposed Method', 'OMP', 'Temp.model','FontSize', 16);
   

plot(RMSE1, '-o','Color', '#8FA7DD','MarkerSize',8,'linewidth', 1); 
% xlabel('Model Index','FontSize', 24);
ylabel('RMSE','FontSize', 24);
hold on; 
plot(1:length(RMSE1), OMP_rmse_test * ones(1, length(RMSE1)),'Color',  '#EA9EAB', 'linewidth', 2);%OMP
hold on;
plot(1:length(RMSE1), en_rmse_test * ones(1, length(RMSE1)), 'Color',  '#9AD0D6', 'linewidth', 2);%原文
title('XJTU Dataset','FontSize', 24); 


% 设置刻度字体大小为14（原为12）
set(gca, 'FontSize', 14);  % 全局字体大小（包含刻度）
legend('Proposed Method', 'OMP', 'Temp.model', 'Location', 'best','FontSize', 16); % 自动选择最佳图例位置
ax = gca;
ax.TickDir = 'out';                  % 刻度朝外   
xlim([1, length(RMSE1)]);
xticks(50:50:max(xlim));  % 从50开始，步长50，直到当前X轴最大值

% 设置刻度字体大小
set(gca, 'FontSize', 20, 'Box', 'off'); % 关闭上/右刻度线
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

% 去除上/右刻度线
ax.XAxis.TickLength = [0.005 0.005]; % 可选：调整X轴刻度线长度
ax.YAxis.TickLength = [0.005 0.005]; % 可选：调整Y轴刻度线长度
% 保存图像时去除白边
set(gcf, 'Color', 'white'); % 设置背景为白色（避免透明背景）
exportgraphics(gcf, [exp_dir, 'MIT_test_1.png'], 'Resolution', 300, 'ContentType', 'auto', 'BackgroundColor', 'none');

% 保存图像
img_filename = [exp_dir,sprintf('XJTU_test.svg')];
saveas(gcf, img_filename);  % 保存当前图像为 .png 文件

disp(['X轴刻度大小: ' num2str(get(gca,'FontSize'))]);
disp(['Y轴刻度大小: ' num2str(get(gca,'FontSize'))]);








