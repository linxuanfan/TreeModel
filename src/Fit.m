function [ a, b ] = Fit( X,Y )
%FIT: X and Y are the X and Y data need to be fitted. a and b are the slope
%and offset. Both X and Y are row vectors

MX=mean(X);
MY=mean(Y);

a=(X-MX)'\(Y-MY)';

b=MY-a*MX;

end

