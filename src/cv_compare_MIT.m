clear;
clc;
close all;

rng(38);

% 结果保存路径
exp_dir = 'result/result_mit_cls/';
if ~exist(exp_dir, 'dir')
    mkdir(exp_dir);
end

% 获取日期
today_mmdd = datestr(now, 'mmdd');

% 加载数据
%% MIT
Xo = xlsread('data/MIT_feature.xlsx'); 

Y = xlsread('data/mit_label.xlsx');
% 划分训练集，测试集1，测试集2
train_idx = 2:2:83;  
test_idx_1 = 1:2:84;
test_idx_1 = [test_idx_1, 84];
test_idx_2 = 85:124; 


%% run model
N = size(Xo, 1);
feature_nums = size(Xo, 2);

% 树模型
% 将数据重新拼接一下，train 和 test_1 做为训练和验证集
X_tree = cat(1, Xo(train_idx,:), Xo(test_idx_1,:));
Y_tree = cat(1, Y(train_idx,:), Y(test_idx_1,:));
Ntr = 41;
N_tree = size(X_tree, 1);

Xr = (X_tree - repmat(mean(X_tree(1:Ntr, :)), N_tree, 1)) ./ repmat(std(X_tree(1:Ntr, :)), N_tree, 1);
MY1 = mean(Y_tree(1:Ntr, 1));
SY1 = std(Y_tree(1:Ntr, 1));
Y1 = (Y_tree(:, 1) - MY1) / SY1;
                 

P = 0.2; % stop growing tree if MAPE increase is larger than 120%
Num = 20; % maximum 20 nodes in each level 

[Tree1, Link1] = GenerateTree2(Xr, Y1, MY1, SY1, Ntr, Num, P);
[Model1, RMSE1] = ExtractModel(Tree1, Link1);

% 找到最小的Tree set
best_idx = find(RMSE1 == min(RMSE1));
selectedModels = Model1(best_idx);
best_T_set = selectedModels{1};

% 计算在test_2上的RMSE
X_test_2 = cat(1, Xo(train_idx,:), Xo(test_idx_2,:));
Y_test_2 = cat(1, Y(train_idx,:), Y(test_idx_2,:));

N_test_2 = size(X_test_2, 1);

X_test_2_r = (X_test_2 - repmat(mean(X_test_2(1:Ntr, :)), N_test_2, 1)) ./ repmat(std(X_test_2(1:Ntr, :)), N_test_2, 1);
Y_test_2_r = (Y_test_2(:, 1) - MY1) / SY1;

tree_rmse_test_1 = min(RMSE1);
tree_rmse_test_2 = getRMSE2(X_test_2_r(:,best_T_set),Y_test_2_r, MY1, SY1, Ntr);


%% OMP
[RMSEo1, Set1] = OMP(X_tree, Y_tree(:,1), Ntr,P);
omp_rmse_test_1 = min(RMSEo1);
omp_best_idx = find(RMSEo1==min(RMSEo1));
omp_T_set = Set1(1:omp_best_idx);
omp_rmse_test_2 = getRMSE2(X_test_2_r(:,omp_T_set),Y_test_2_r, MY1, SY1, Ntr);



%% 找到所有比omp好的特征组合，求 test_2

selected_idx = find(RMSE1 <= min(RMSEo1));
selectedModels = Model1(selected_idx);

% 初始化一个标志矩阵，记录哪些模型需要保留
toKeep = ones(1, length(selectedModels));

% 遍历每对模型
for i = 1:length(selectedModels)
    for j = i+1:length(selectedModels)
        % 检查是否为子集
        isSubset = all(ismember(selectedModels{i}, selectedModels{j}));

        % 如果是子集，则标记较小的模型为去除
        if isSubset
            toKeep(i) = 0;
        end
    end
end

% 根据标志矩阵筛选保留的模型
filteredIndex = selected_idx(toKeep == 1);
filteredModels = selectedModels(toKeep == 1);
filteredRMSE = RMSE1(filteredIndex);

RMSE2= zeros(1, length(filteredModels));

for i = 1:length(filteredModels)
    F_set = selectedModels{i};
    temp_rmse_test_2 = getRMSE2(X_test_2_r(:,F_set),Y_test_2_r, MY1, SY1, Ntr);
    RMSE2(i) = temp_rmse_test_2;
end



%% ElasticNet
en_rmse_test_1 = 184.2;
en_rmse_test_2 = 231.8;
a1 =3; %omp和EN的颜色


% 绘制 RMSE 曲线，并与 Elastic Net 方法的结果比较
set(groot, 'defaultAxesFontName', 'Arial');       % 坐标轴字体
set(groot, 'defaultTextFontName', 'Arial');        % 文本字体
set(groot, 'defaultLegendFontName', 'Arial');      % 图例字体
set(groot, 'defaultColorbarFontName', 'Arial');    % 颜色条字体

% figure('Position', [100 100 1500 500]);
% % plot(RMSE1, '--o','Color', '#8FA7DD','MarkerFaceColor','#8FA7DD','MarkerSize',6,'linewidth', 1.5); %树颜色】
% plot(RMSE1, '--o','Color', '#8FA7DD','MarkerFaceColor','#8FA7DD','MarkerSize',4,'linewidth', 1); %树颜色】
% xlabel('Model Index','FontSize', 30); %【】
% ylabel('RMSE','FontSize', 30);
% hold on; 
% plot(1:length(RMSE1), omp_rmse_test_1 * ones(1, length(RMSE1)),'Color',  '#EA9EAB', 'linewidth', 3);  %omp颜色】
% hold on;
% plot(1:length(RMSE1), en_rmse_test_1 * ones(1, length(RMSE1)), 'Color',  '#9AD0D6', 'linewidth', 3); %en颜色】
% title('MIT dataset Test-1'); legend('Proposed Method', 'OMP', 'EN');
% xlim([1, length(RMSE1)]);



figure('Position', [100 100 2000 350]);
t = tiledlayout(1,1, 'Padding', 'compact');
nexttile;

% 绘制 Proposed Method（虚线 + 实心标记）
plot(RMSE1, '-o', 'Color', '#8FA7DD', 'MarkerSize',8, 'linewidth', 2); 
% xlabel('Model Index', 'FontSize', 18);
ylabel('RMSE', 'FontSize', 20);
hold on; 

% 绘制 OMP 和 EN（保持实线）
plot(1:length(RMSE1), omp_rmse_test_1 * ones(1, length(RMSE1)), 'Color', '#EA9EAB', 'linewidth', 3);  % OMP
plot(1:length(RMSE1), en_rmse_test_1 * ones(1, length(RMSE1)), 'Color', '#9AD0D6', 'linewidth', 3);    % EN

% title('TRI dataset Test-1'); 
legend('    ', 'OMP', 'ElasticNet', 'Location', 'best','FontSize', 16); % 自动选择最佳图例位置
xlim([1, length(RMSE1)]);

% 设置刻度字体大小
set(gca, 'FontSize', 20, 'Box', 'off'); % 关闭上/右刻度线
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

% box on;  % 确保坐标轴框线显示
set(gca, 'TickDir', 'out');
box off;

% set(gca, 'LooseInset', get(gca, 'TightInset'));

% 去除上/右刻度线
% ax.XAxis.TickLength = [1 0]; % 可选：调整X轴刻度线长度
% ax.YAxis.TickLength = [1 0]; % 可选：调整Y轴刻度线长度
% 保存图像时去除白边
% set(gcf, 'Color', 'white'); % 设置背景为白色（避免透明背景）


% 设置刻度字体大小为14
% set(gca, 'FontSize', 26);  % 全局字体大小（包含刻度）

img_filename = [exp_dir,sprintf('TRI_test_222.svg')];
set(gca, 'YTick', 100:50:250);
ylim([100 260]);
saveas(gcf, img_filename);  % 保存当前图像为 .png 文件

% exportgraphics(gcf, img_filename, 'ContentType', 'vector');

%%--------------------------------------------------------------
% figure('Position', [100 100 2000 350]);
% t = tiledlayout(1,1, 'Padding', 'compact');
% nexttile;
% 
% 
% 
% % 绘制 Proposed Method（虚线 + 实心标记）
% plot(RMSE2, '-o', 'Color', '#8FA7DD', 'MarkerSize',8, 'linewidth', 2); 
% % xlabel('Model Index', 'FontSize', 18);
% ylabel('RMSE', 'FontSize', 20);
% hold on; 
% 
% % 绘制 OMP 和 EN（保持实线）
% plot(1:length(RMSE2), omp_rmse_test_2 * ones(1, length(RMSE2)), 'Color', '#EA9EAB', 'linewidth', 3);  % OMP
% plot(1:length(RMSE2), en_rmse_test_2 * ones(1, length(RMSE2)), 'Color', '#9AD0D6', 'linewidth', 3);    % EN
% 
% % title('TRI dataset Test-1'); 
% legend('    ', 'OMP', 'ElasticNet', 'Location', 'best','FontSize', 16); % 自动选择最佳图例位置
% xlim([1, length(RMSE2)]);
% 
% % 设置刻度字体大小
% set(gca, 'FontSize', 20, 'Box', 'off'); % 关闭上/右刻度线
% ax = gca;
% ax.XAxis.FontSize = 20;
% ax.YAxis.FontSize = 20;
% 
% % box on;  % 确保坐标轴框线显示
% set(gca, 'TickDir', 'out');
% box off;
% 
% % set(gca, 'LooseInset', get(gca, 'TightInset'));
% 
% % 去除上/右刻度线
% % ax.XAxis.TickLength = [1 0]; % 可选：调整X轴刻度线长度
% % ax.YAxis.TickLength = [1 0]; % 可选：调整Y轴刻度线长度
% % 保存图像时去除白边
% % set(gcf, 'Color', 'white'); % 设置背景为白色（避免透明背景）
% 
% 
% % 设置刻度字体大小为14
% % set(gca, 'FontSize', 26);  % 全局字体大小（包含刻度）
% 
% img_filename = [exp_dir,sprintf('TRI_test_22.svg')];
% set(gca, 'YTick', 200:50:350);
% ylim([190 360]);
% saveas(gcf, img_filename);  % 保存当前图像为 .png 文件


%%--------------------------------------------------------------

% figure('Position', [100 100 2000 350]);
% plot(RMSE2, '-o','Color', '#8FA7DD','MarkerFaceColor','#8FA7DD','MarkerSize',10,'linewidth', 3);
% % xlabel('Model Index','FontSize', 20);
% ylabel('RMSE','FontSize', 20);
% hold on; 
% plot(1:length(RMSE2), omp_rmse_test_2 * ones(1, length(RMSE2)), 'Color',  '#EA9EAB', 'linewidth', 2);
% hold on; 
% plot(1:length(RMSE2), en_rmse_test_2 * ones(1, length(RMSE2)), 'Color',  '#9AD0D6', 'linewidth', 2);
% 
% % % title('TRI dataset Test-1'); 
% % legend('Proposed Method', 'OMP', 'ElasticNet', 'Location', 'best','FontSize', 16); % 自动选择最佳图例位置
% % xlim([1, length(RMSE2)]);
% 
% % title('MIT-Stanford dataset Test-2'); 
% legend('     ', 'OMP', 'ElasticNet', 'Location', 'northeast', 'FontSize',16);
% % legend('Proposed Method', 'OMP', 'ElasticNet', 'Location', 'northeast', 'FontSize',13);
% xlim([1, length(RMSE2)]);
% 
% % 设置刻度字体大小为14
% set(gca, 'FontSize', 26);  % 全局字体大小（包含刻度）
% ax = gca;
% set(gca, 'FontSize', 20, 'Box', 'off'); % 关闭上/右刻度线
% ax.XAxis.FontSize = 20;  % X轴刻度字体
% ax.YAxis.FontSize = 20;  % Y轴刻度字体
% 
% box on;  % 确保坐标轴框线显示
% set(gca, 'TickDir', 'out');
% box off;
% 
% set(gca, 'LooseInset', get(gca, 'TightInset'));
% %去除上/右刻度线
% ax.XAxis.TickLength = [1 0]; % 可选：调整X轴刻度线长度
% ax.YAxis.TickLength = [1 0]; % 可选：调整Y轴刻度线长度
% %保存图像时去除白边
% set(gcf, 'Color', 'white'); % 设置背景为白色（避免透明背景）
% 
% % 保存图像
% img_filename = [exp_dir,sprintf('MIT_test_2.svg')];
% saveas(gcf, img_filename);  % 保存当前图像为 .png 文件









