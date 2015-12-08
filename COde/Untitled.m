roundedA = round(A.muhat.*10)./10;
scatter(roundedA(:,2),A.spikes(:,2),'b')
title('Brain control, linear')
hold on

[m,n]=size(A.spikes);

x=A.muhat(:,1);
y=A.spikes(:,1);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'g')
