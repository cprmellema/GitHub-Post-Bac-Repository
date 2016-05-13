[n,m]=size(sinsimtests.real);
real=reshape(sinsimtests.real,1,m*n);
real=normalize_connections(real);

predicted=reshape(sinsimtests.TransferEntropy,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
figure
plot(Sn,1-Sp,'r')
hold on
title('ROC curves - sinusoidal input')
xlabel('1-Sp')
ylabel('Sn')
hold on

predicted=reshape(sinsimtests.LMtest,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(Sn,1-Sp,'k')
hold on


predicted=reshape(sinsimtests.GLMtest,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(Sn,1-Sp,'b')
hold on


predicted=reshape(sinsimtests.Covariance,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(Sn,1-Sp,'g')
hold on

plot(0:0.01:1,0:0.01:1,'.m')

figure
subplot(2,2,1)
[n,m]=size(sinsimtests.real);
real=reshape(sinsimtests.real,1,m*n);
real=normalize_connections(real);

predicted=reshape(sinsimtests.TransferEntropy,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('Transfer Entropy Scatter')

subplot(2,2,2)

predicted=reshape(sinsimtests.LMtest,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('LM Scatter')

subplot(2,2,3)

predicted=reshape(sinsimtests.GLMtest,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('GLM Scatter')

subplot(2,2,4)

predicted=reshape(sinsimtests.Covariance,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('Covariance Scatter')

