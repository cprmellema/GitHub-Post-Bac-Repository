[Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.Entropy,100);
[Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.Entropy,100);
[Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.Entropy,100);
figure
plot(Sn,1-Sp)
hold on
plot(Sn2,1-Sp2)
hold on
plot(Sn3,1-Sp3)
hold on
plot(0.001:0.001:1,0.001:.001:1,'r')
title('Entropy')
xlabel('1-Sp')
ylabel('Sn')

[Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.GLMtest,100);
[Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.GLMtest,100);
[Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.GLMtest,100);
figure
plot(Sn,1-Sp)
hold on
plot(Sn2,1-Sp2)
hold on
plot(Sn3,1-Sp3)
hold on
plot(0.001:0.001:1,0.001:.001:1,'r')
title('Granger')
xlabel('1-Sp')
ylabel('Sn')

[Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.Covariance,100);
[Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.Covariance,100);
[Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.Covariance,100);
figure
plot(Sn,1-Sp)
hold on
plot(Sn2,1-Sp2)
hold on
plot(Sn3,1-Sp3)
hold on
plot(0.001:0.001:1,0.001:.001:1,'r')
title('Covariances')
xlabel('1-Sp')
ylabel('Sn')

[Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.Differences,100);
[Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.Differences,100);
[Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.Differences,100);
figure
plot(Sn,1-Sp)
hold on
plot(Sn2,1-Sp2)
hold on
plot(Sn3,1-Sp3)
hold on
plot(0.001:0.001:1,0.001:.001:1,'r')
title('Sums')
xlabel('1-Sp')
ylabel('Sn')
