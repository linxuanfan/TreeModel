function [ CoeffB1,CoeffB2,Res1,Res2,Bset ] = get_Model_SOMP( XValue,YValue1,YValue2, Res_p1,Res_p2,Bset_p)

% NumBasis is the 
% initialization

[~,b]=size(Bset_p);
if b<1
    Bset_p=[];
end
XNum = size(XValue,2);

    
    % calculate inner product & select basis function
    %ind=setxor(Bset_p,1:XNum);
    %X_temp=XValue(:,ind);
    X_temp=XValue;
    cur_corr = abs(Res_p1'*X_temp)+abs(Res_p2'*X_temp);
    [~,temp_index] = max(cur_corr); 
    temp_index = temp_index(1);
    Bset = [Bset_p,temp_index];
    OMPBasis = XValue(:,Bset);
    
    % fit least-squares model

    Coeff1 = OMPBasis \ YValue1;
    Coeff2 = OMPBasis \ YValue2;

    % update DataRes
    Res1 = YValue1 - OMPBasis*Coeff1;
    Res2 = YValue2 - OMPBasis*Coeff2;


% return CoeffB & CoeffC
CoeffB1 = zeros(XNum,1);
CoeffB1(Bset,1) = Coeff1;
CoeffB2 = zeros(XNum,1);
CoeffB2(Bset,1) = Coeff2;

end

