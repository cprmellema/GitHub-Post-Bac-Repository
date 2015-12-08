load BrainControlLinear.mat
load BrainControlGenLinear.mat
load ManualControlLinear.mat
load ManualControlGenlinear.mat

subplot(2,2,1)
SpecialLinGraph('Brain control, Linear',A,1)
hold on

x=A.muhat(:,2);
y=A.spikes(:,2);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'r')

subplot(2,2,2)
SpecialLinGraph('Brain control, Genlinear',A1,1)
hold on

x=A1.muhat(:,2);
y=A1.spikes(:,2);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'r')

subplot(2,2,3)
roundedB = round(B.muhat.*10)./10;
scatter(roundedB(:,2),B.spikes(:,2),'g')
title('Manual control, linear')
hold on


x=B.muhat(:,2);
y=B.spikes(:,2);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'r')

subplot(2,2,4)
roundedB1 = round(B1.muhat.*10)./10;
scatter(roundedB1(:,2),B1.spikes(:,2),'k')
title('Manual control, Genlinear')
hold on


x=B1.muhat(:,2);
y=B1.spikes(:,2);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'r')