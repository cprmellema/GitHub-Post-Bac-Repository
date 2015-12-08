load BrainControlLinear.mat
load BrainControlGenLinear.mat
load ManualControlLinear.mat
load ManualControlGenlinear.mat

subplot(2,2,1)
roundedA = round(A.muhat.*10)./10;
scatter(roundedA(:,1),A.spikes(:,1),'b')
title('Brain control, linear')
hold on

x=A.muhat(:,1);
y=A.spikes(:,1);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'g')

subplot(2,2,2)
roundedA1 = round(A1.muhat.*10)./10;
scatter(roundedA1(:,1),A1.spikes(:,1),'b')
title('Brain control, Genlinear')
hold on

x=A1.muhat(:,1);
y=A1.spikes(:,1);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'g')

subplot(2,2,3)
roundedB = round(B.muhat.*10)./10;
scatter(roundedB(:,1),B.spikes(:,1),'b')
title('Manual control, linear')
hold on


x=B.muhat(:,1);
y=B.spikes(:,1);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'g')

subplot(2,2,4)
roundedB1 = round(B1.muhat.*10)./10;
scatter(roundedB1(:,1),B1.spikes(:,1),'b')
title('Manual control, Genlinear')
hold on


x=B1.muhat(:,1);
y=B1.spikes(:,1);
p=polyfit(x,y,1);
v=0:0.01:2;
yfit=polyval(p,v);
plot(v,yfit,'k',v,v,'g')