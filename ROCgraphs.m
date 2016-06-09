function [ output_args ] = ROCgraphs( file, name )
%Makes ROC graphs of file

[n,m]=size(file.real);
real=reshape(file.real,1,m*n);
real=normalize_connections(real);

predicted=reshape(file.TransferEntropy,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
figure
plot(1-Sp,Sn,'r')
hold on
title(['ROC curves - ',name])
xlabel('1-Sp')
ylabel('Sn')
hold on

predicted=reshape(file.LMtest,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(1-Sp,Sn,'k')
hold on


predicted=reshape(file.GLMtest,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(1-Sp,Sn,'b')
hold on


predicted=reshape(file.Covariance,1,m*n);
predicted=normalize_connections(predicted);
[Sn,Sp,~]=sensitivityspecificity(real,predicted,100);
plot(1-Sp,Sn,'g')
hold on

plot(0:0.01:1,0:0.01:1,'.m')

figure
subplot(2,2,1)
[n,m]=size(file.real);
real=reshape(file.real,1,m*n);
real=normalize_connections(real);

predicted=reshape(file.TransferEntropy,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('Transfer Entropy Scatter')

subplot(2,2,2)

predicted=reshape(file.LMtest,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('LM Scatter')

subplot(2,2,3)

predicted=reshape(file.GLMtest,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('GLM Scatter')

subplot(2,2,4)

predicted=reshape(file.Covariance,1,m*n);
predicted=normalize_connections(predicted);

scatter(predicted,real)
xlabel('predicted')
ylabel('real')
title('Covariance Scatter')


end

