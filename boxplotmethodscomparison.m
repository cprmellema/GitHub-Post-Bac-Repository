real=normalize_connections(reshape(fulltestscan.real,1,900));
TEpredictions=normalize_connections(reshape(fulltestscan.TE,1,900));
LMpredictions=normalize_connections(reshape(fulltestscan.GLMtest,1,900));
GLMpredictions=normalize_connections(reshape(fulltestscan.GLMpoissonlin,1,900));
Covpredictions=normalize_connections(reshape(fulltestscan.Covariance,1,900));

figure
hold on
plot(0:0.01:1,0:0.01:1,'--k')
hold on
[Sn,Sp,~]=sensitivityspecificity(real,TEpredictions,100);
plot(1-Sp,Sn,'r')
hold on
[Sn,Sp,~]=sensitivityspecificity(real,LMpredictions,100);
plot(1-Sp,Sn,'k')
hold on
[Sn,Sp,~]=sensitivityspecificity(real,GLMpredictions,100);
plot(1-Sp,Sn,'b')
hold on
[Sn,Sp,~]=sensitivityspecificity(real,Covpredictions,100);
plot(1-Sp,Sn,'g')



% boxplot([(TEpredictions-real),(LMpredictions-real), (GLMpredictions-real), (Covpredictions - real)], [ones(1,900),2*ones(1,900),3*ones(1,900),4*ones(1,900)]);