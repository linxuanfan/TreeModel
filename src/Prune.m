function [NewTree,NewSet,NewRes,NewLink]=Prune(Tree,Fset,Res,Link)

%% This function prunes the nodes in the same level if the feature set are the same

% Tree is the current level of the tree
% for each node of the tree 
                         % first is MAPE
                         % second is selected feature at this level
                         % third is the minimum MAPE
                         
% Fset is the featureset of each tree
    
N=size(Tree,2);

NewTree=cell(0);
NewSet=cell(0);
NewRes=cell(0);
NewLink=[];


for n=1:N
    if size(NewTree,2)==0
        NewTree{1,n}=Tree{1,n};
        NewSet{1,n}=Fset{1,n};
        NewRes{1,n}=Res{1,n};
        NewLink(1,n)=Link(1,n);
    end
    flag=0;
    set1=sort(Fset{1,n});
    for m=1:size(NewTree,2)
        set2=sort(NewSet{1,m});
        if isequal(set1,set2)
            flag=1;
%             % keep the minimum MAPEmin
%             if NewTree{1,m}{1,3}>Tree{1,n}{1,3}
                NewTree{1,m}=Tree{1,n};
                NewSet{1,m}=Fset{1,n};
                NewRes{1,m}=Res{1,n};
                NewLink(1,m)=Link(1,n);
            %end
        end
    end
    if flag==0
        NewTree{1,m+1}=Tree{1,n};
        NewSet{1,m+1}=Fset{1,n};
        NewRes{1,m+1}=Res{1,n};
        NewLink(1,m+1)=Link(1,n);
    end
end

end




