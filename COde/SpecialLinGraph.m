function [out]= SpecialLinGraph(titl, A,n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
roundedA = round(A.muhat.*100)./100;
Uniquex=unique(roundedA(:,n));
yb=zeros(Uniquex,1);
for i=1:length(Uniquex)
    yb(i)=mean(A.spikes((roundedA(:,n)==Uniquex(i)),n));
end
scatter(Uniquex,yb,'b')
title(titl)
hold on

x=A.muhat(:,n);
y=A.spikes(:,n);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'r')

end

