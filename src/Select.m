function [NewTree,NewSet,NewRes,NewLink]=Select(Tree,Fset,Res,Link,Num)

%% This function only keeps the Num nodes with minimum MAPEs at each level

NewTree=cell(0);
NewSet=cell(0);
NewRes=cell(0);

MAPE=zeros(1,size(Tree,2));

for i=1:length(MAPE)
    MAPE(i)=Tree{1,i}{1};
end

[~,Rank]=sort(MAPE);

NewLink=Link(Rank(1:Num));

for i=1:Num
    NewTree{1,i}=Tree{1,Rank(i)};
    NewSet{1,i}=Fset{1,Rank(i)};
    NewRes{1,i}=Res{1,Rank(i)};
end

end