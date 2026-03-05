function [Models,RMSE]=ExtractModel(Tree,Link)
    Models=cell(0);
    RMSE=[];
    Ratio=[];
    % use bfs
    count=0;
    PreLevel={Tree{1,1}{1}{2}};
    for i=1:size(Tree,2)-1
        tmplevel=cell(0);
        for j=1:size(Link{1,i},2)  %列数：每一层多的节点数
            count=count+1;
            tmplevel{1,j}=[PreLevel{1,Link{1,i}(j)},Tree{i+1}{j}{2}];
            Models{1,count}=[PreLevel{1,Link{1,i}(j)},Tree{i+1}{j}{2}];
            RMSE(count)=Tree{i+1}{j}{3};
        end
        PreLevel=tmplevel;
    end
end