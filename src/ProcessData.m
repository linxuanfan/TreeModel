load('mismatch_data.mat');
load('perf_data.mat');
load('process_data.mat');

X=[];
Yx=[];

for i=1:32
    Yx=[Yx;perf_data{1,i}];
    X=[X;[mismatch_data{1,i},process_data{1,i}]];
end