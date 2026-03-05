function [ CoeffB,CoeffC,Res,Bset ] = get_Model_OMP_r( XValue,YValue, Res_p,Bset_p)

% NumBasis is the 
% initialization

[a,b]=size(Bset_p);
if b<1
    Bset_p=[];
end
XNum = size(XValue,2);

    
    % calculate inner product & select basis function
    %ind=setxor(Bset_p,1:XNum);
    %X_temp=XValue(:,ind);
    X_temp=XValue;
    cur_corr = abs(Res_p'*X_temp);
    [max_corr,temp_index] = max(cur_corr); temp_index = temp_index(1);
    Bset = [Bset_p,temp_index];
    OMPBasis = XValue(:,Bset);
    
    % fit least-squares model

    Coeff = OMPBasis \ YValue;

    % update DataRes
    Res = YValue - OMPBasis*Coeff;


% return CoeffB & CoeffC
CoeffB = zeros(XNum,1);
CoeffB(Bset,1) = Coeff;
CoeffC = 0;

end

