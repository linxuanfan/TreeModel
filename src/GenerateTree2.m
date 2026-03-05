function [Tree,Link,flag]=GenerateTree2(X,Y,MY,SY,Ntr,Num,P)
% X：标准化后的特征矩阵；Y：标准化后的标签矩阵。
% P is the stopping criteria

N=size(X,1); %样本数量
M=size(X,2); %特征数量

ResT={Y(1:Ntr,:)};  % Initial residual初始残差

Tree=cell(0); % store the nodes of all levels 节点信息

Root={Inf,[],Inf,Inf};   % 因为起始的比较值要无穷大
                         % first is traing RMSE
                         % second is selected feature at this level
                         % third is validation RMSE
                         % last is minimum validation RMSE
                         % this is the root


                         
Link=cell(0); % the links in the tree, at a level, each entry is the parent node index 
tmpLevel=cell(0);
tmpLevel{1,1}=Root;
Tree{1,1}=tmpLevel;

Fset=cell(1,1); % 特征集 store the feature set of each leaf node

% Lev=min([M-2,Ntr-2,Levx]); % max level of the tree
Lev=min([M-2,Ntr-2]);

flag=0;

                            

for le=1:Lev     %树的最大层数
    tmpTree=cell(0);
    tmpFset=cell(0);
    tmpRes=cell(0);
    tmpLink=[];
    count=0;
    for i=1:size(Tree{1,le},2) % each node in current level
        Restmp=ResT{i}; % current residual
        Rset=Fset{1,i};
        Aset=setxor(1:M,Rset);
        COR=abs(X(1:Ntr,Aset)'*Restmp); % inner product with residual
        ARMSE=Tree{1,le}{i}{4};
        if length(COR)>2
            Selec=Clus(COR);
        else
            [~,Selec]=max(COR);
        end
        % compute next level
        for j=1:length(Selec)
            Tset=[Rset,Aset(Selec(j))];
            Res=TakeRes(X(1:Ntr,Tset),Y(1:Ntr,:));
%             disp(Tset)
%             disp(Coeff)
            
            RMSE1=getRMSE1(X(:,Tset),Y,MY,SY,Ntr);
            RMSE2=getRMSE2(X(:,Tset),Y,MY,SY,Ntr);

%             disp(RMSE2)
            
            if RMSE2<=ARMSE*(1+P) % early stop for this branch otherwise
                Tpnode={RMSE1,Aset(Selec(j)),RMSE2,min(ARMSE,RMSE2)};
                count=count+1;
                tmpTree{1,count}=Tpnode;
                tmpFset{1,count}=Tset;
                tmpRes{1,count}=Res;
                tmpLink(1,count)=i;
            else
                flag=1;
            end
            
        end
    end
    
    % prune same level nodes
     [tmpTree,tmpFset,tmpRes,tmpLink]=Prune(tmpTree,tmpFset,tmpRes,tmpLink);
    
    % further prune if number of nodes is still large
    
    if size(tmpTree,2)>Num
        [tmpTree,tmpFset,tmpRes,tmpLink]=Select(tmpTree,tmpFset,tmpRes,tmpLink,Num);
    end
    
    % check if any node generated at this level
    
    if size(tmpTree,2)~=0
        Tree{1,le+1}=tmpTree;
        Fset=tmpFset;
        ResT=tmpRes;
        Link{1,le}=tmpLink;
    else
        break;
    end
end

end





