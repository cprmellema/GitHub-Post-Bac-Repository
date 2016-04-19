q=3;

figure
title('Two Connections Away Graphs')
subplot(2,2,1)
[ sensitivity, specificity, ~ , ~, TP, FN,FP,TN ] = sensitivityspecificitytwoaway(fulltestscan.real,fulltestscan.GLMpoissonlin,100);
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
    elseif q==3
        break
    end
end
if q==1 
    title('Poisson GLM, varying thresholds for weak vs strong connections')
    hold on
    plot(0.001:0.001:1,0.001:0.001:1,'r')
    xlabel('1-Sp')
    ylabel('Sn')
elseif q==2
    title('Poisson GLM, varying thresholds for weak vs strong connections')
    xlabel('count')
    ylabel('TP-r, FN-b, FP-g, TN-k')
elseif q==3
    title('Poisson GLM')
    xlabel('Real Connection Strength')
    ylabel('Predicted Connection Strength')
    x=reshape(fulltestscan.real,[1,900]);
    y=reshape(fulltestscan.GLMpoissonlin,[1,900]);
    scatter(x,y)
end


subplot(2,2,2)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificitytwoaway(fulltestscan.real,fulltestscan.GLMtest,100);
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
    elseif q==3
        break
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
elseif q==3
    title('Linear Model')
    xlabel('Real Connection Strength')
    ylabel('Predicted Connection Strength')
    x=reshape(fulltestscan.real,[1,900]);
    y=reshape(fulltestscan.GLMtest,[1,900]);
    scatter(x,y)
end


subplot(2,2,3)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificitytwoaway(fulltestscan.real,fulltestscan.Covariance,100);
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
        
    elseif q==3
        break
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
elseif q==3
    title('Covariance')
    xlabel('Real Connection Strength')
    ylabel('Predicted Connection Strength')
    x=reshape(fulltestscan.real,[1,900]);
    y=reshape(fulltestscan.Covariance,[1,900]);
    scatter(x,y)
end


subplot(2,2,4)
[ sensitivity, specificity, ~ , ~ , TP, FN,FP,TN] = sensitivityspecificitytwoaway(fulltestscan.real,fulltestscan.TE,100);
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
        
    elseif q==3
        break
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
elseif q==3
    title('Transfer Entropy')
    xlabel('Real Connection Strength')
    ylabel('Predicted Connection Strength')
    x=reshape(fulltestscan.real,[1,900]);
    y=reshape(fulltestscan.TE,[1,900]);
    scatter(x,y)
end