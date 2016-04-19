q=2;

figure
title('One Connection Away Graphs')
subplot(2,2,1)
[ sensitivity, specificity, ~ , ~, TP, FN,FP,TN ] = sensitivityspecificity(fulltestscan.real,fulltestscan.GLMpoissonlin,100);
[sz,~]=size(sensitivity);
for i=1:sz
    if q==1
        scatter(1-specificity(i,:),sensitivity(i,:))
        hold on
    elseif q==2
        plot(TP(i,:),'r')
        hold on
        plot(FN(i,:),'b')
        hold on
        plot(FP(i,:),'g')
        hold on
        plot(TN(i,:),'k')
        hold on
    end
end
title('Poisson GLM, varying thresholds for weak vs strong connections')
if q==1 
    hold on
    plot(0.001:0.001:1,0.001:0.001:1,'r')
    xlabel('1-Sp')
    ylabel('Sn')
elseif q==2
    xlabel('count')
    ylabel('TP-r, FN-b, FP-g, TN-k')
end


subplot(2,2,2)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(fulltestscan.real,fulltestscan.GLMtest,100);
[sz,~]=size(sensitivity);
for i=1:sz
    if q==1
        scatter(1-specificity(i,:),sensitivity(i,:))
        hold on
    elseif q==2
        plot(TP(i,:),'r')
        hold on
        plot(FN(i,:),'b')
        hold on
        plot(FP(i,:),'g')
        hold on
        plot(TN(i,:),'k')
        hold on
    end
end
title('Linear Model, varying thresholds for weak vs strong connections')
if q==1 
    hold on
    plot(0.001:0.001:1,0.001:0.001:1,'r')
    xlabel('1-Sp')
    ylabel('Sn')
elseif q==2
    xlabel('count')
    ylabel('TP-r, FN-b, FP-g, TN-k')
end


subplot(2,2,3)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(fulltestscan.real,fulltestscan.Covariance,100);
[sz,~]=size(sensitivity);
for i=1:sz
    if q==1
        scatter(1-specificity(i,:),sensitivity(i,:))
        hold on
    elseif q==2
        plot(TP(i,:),'r')
        hold on
        plot(FN(i,:),'b')
        hold on
        plot(FP(i,:),'g')
        hold on
        plot(TN(i,:),'k')
        hold on
    end
end
title('Covariances, varying thresholds for weak vs strong connections')
if q==1 
    hold on
    plot(0.001:0.001:1,0.001:0.001:1,'r')
    xlabel('1-Sp')
    ylabel('Sn')
elseif q==2
    xlabel('count')
    ylabel('TP-r, FN-b, FP-g, TN-k')
end


subplot(2,2,4)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificity(fulltestscan.real,fulltestscan.TE,100);
[sz,~]=size(sensitivity);
for i=1:sz
    if q==1
        scatter(1-specificity(i,:),sensitivity(i,:))
        hold on
    elseif q==2
        plot(TP(i,:),'r')
        hold on
        plot(FN(i,:),'b')
        hold on
        plot(FP(i,:),'g')
        hold on
        plot(TN(i,:),'k')
        hold on
    end
end
title('Transfer Entropy, varying thresholds for weak vs strong connections')
if q==1 
    hold on
    plot(0.001:0.001:1,0.001:0.001:1,'r')
    xlabel('1-Sp')
    ylabel('Sn')
elseif q==2
    xlabel('count')
    ylabel('TP-r, FN-b, FP-g, TN-k')
end