function [ maxD ] = maxROCdist( Sn, Sp )
%finds the maximum (positive) distance from the line y=x to the ROC curve

y=1-Sp;
x=Sn;

D=(y-x)/(sqrt(2));

maxD=max(D);

end

