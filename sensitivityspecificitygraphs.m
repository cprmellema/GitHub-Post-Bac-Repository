figure
[ sensitivity, specificity, ~ , ~, TP, FN,FP,TN ] = sensitivityspecificity(ans1.real,ans1.Entropy,100);
for i=1:101
% scatter(1-specificity(i,:),sensitivity(i,:))
% hold on
plot(TP(i,:),'r')
hold on
plot(FN(i,:),'b')
hold on
plot(FP(i,:),'g')
hold on
plot(TN(i,:),'k')
hold on
end
% hold on
% plot(0.001:0.001:1,0.001:0.001:1,'r')
title('Entropy, varying thresholds for weak vs strong connections')
% xlabel('1-Sp')
% ylabel('Sn')
xlabel('count')
ylabel('TP-r, FN-b, FP-g, TN-k')

figure
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(ans1.real,ans1.GLMtest,100);
for i=1:101
% scatter(1-specificity(i,:),sensitivity(i,:))
% hold on
plot(TP(i,:),'r')
hold on
plot(FN(i,:),'b')
hold on
plot(FP(i,:),'g')
hold on
plot(TN(i,:),'k')
hold on
end
% hold on
% plot(0.001:0.001:1,0.001:0.001:1,'r')
title('Granger, varying thresholds for weak vs strong connections')
% xlabel('1-Sp')
% ylabel('Sn')
xlabel('count')
ylabel('TP-r, FN-b, FP-g, TN-k')


figure
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(ans1.real,ans1.Covariance,100);
for i=1:101
% scatter(1-specificity(i,:),sensitivity(i,:))
% hold on
plot(TP(i,:),'r')
hold on
plot(FN(i,:),'b')
hold on
plot(FP(i,:),'g')
hold on
plot(TN(i,:),'k')
hold on
end
% hold on
% plot(0.001:0.001:1,0.001:0.001:1,'r')
title('Covariances, varying thresholds for weak vs strong connections')
% xlabel('1-Sp')
% ylabel('Sn')
xlabel('count')
ylabel('TP-r, FN-b, FP-g, TN-k')

figure
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(ans1.real,ans1.Differences,100);
for i=1:101
% scatter(1-specificity(i,:),sensitivity(i,:))
% hold on
plot(TP(i,:),'r')
hold on
plot(FN(i,:),'b')
hold on
plot(FP(i,:),'g')
hold on
plot(TN(i,:),'k')
hold on
end
% hold on
% plot(0.001:0.001:1,0.001:0.001:1,'r')
title('Differences, varying thresholds for weak vs strong connections')
% xlabel('1-Sp')
% ylabel('Sn')
xlabel('count')
ylabel('TP-r, FN-b, FP-g, TN-k')