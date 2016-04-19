% [Sn,Sp,thresholds]=sensitivityspecificity(J,noisyTE,100);
[n,m]=size(J);
real=reshape(J,1,m*n);
real=normalize_connections(real);
predicted=reshape(noisyTE,1,m*n);
predicted=normalize_connections(predicted);
figure
scatter(predicted,real)
hold on
plot(0.001:0.001:max(predicted),0.001:.001:max(predicted),'r')
title('noisy TE')
xlabel('predicted')
ylabel('real')

% [Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.GLMtest,100);
% [Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.GLMtest,100);
% [Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.GLMtest,100);
% figure
% plot(Sn,1-Sp)
% hold on
% plot(Sn2,1-Sp2)
% hold on
% plot(Sn3,1-Sp3)
% hold on
% plot(0.001:0.001:1,0.001:.001:1,'r')
% title('Granger')
% xlabel('1-Sp')
% ylabel('Sn')
% 
% [Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.Covariance,100);
% [Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.Covariance,100);
% [Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.Covariance,100);
% figure
% plot(Sn,1-Sp)
% hold on
% plot(Sn2,1-Sp2)
% hold on
% plot(Sn3,1-Sp3)
% hold on
% plot(0.001:0.001:1,0.001:.001:1,'r')
% title('Covariances')
% xlabel('1-Sp')
% ylabel('Sn')
% 
% [Sn,Sp,thresholds]=sensitivityspecificity(ans.real,ans.Differences,100);
% [Sn2,Sp2,thresholds]=sensitivityspecificity(ans2.real,ans2.Differences,100);
% [Sn3,Sp3,thresholds]=sensitivityspecificity(ans3.real,ans3.Differences,100);
% figure
% plot(Sn,1-Sp)
% hold on
% plot(Sn2,1-Sp2)
% hold on
% plot(Sn3,1-Sp3)
% hold on
% plot(0.001:0.001:1,0.001:.001:1,'r')
% title('Sums')
% xlabel('1-Sp')
% ylabel('Sn')
