figure
subplot(2,2,1)
scatter(TEMC, TEBC);
hold on
plot(0:0.001:max(TEMC),0:0.001:max(TEMC),'r')
CMB=corr(TEMC, TEBC);
xlabel('TEMC')
ylabel('TEBC')
title(strcat('TE manual v brain, correlation = ',num2str(CMB)))

subplot(2,2,2)
scatter(TEMCb, TEMC2);
hold on
plot(0:0.001:max(TEMCb),0:0.001:max(TEMCb),'r')
CMM=corr(TEMCb, TEMC2);
xlabel('TEMC')
ylabel('TEMC2')
title(strcat('TE manual v 2nd manual, correlation = ',num2str(CMM)))

subplot(2,2,3)
scatter(TEMCb, TEDC);
hold on
plot(0:0.001:max(TEMCb),0:0.001:max(TEMCb),'r')
CMD=corr(TEMCb, TEDC);
xlabel('TEMC')
ylabel('TEDC')
title(strcat('TE manual v dual, correlation = ',num2str(CMD)))

subplot(2,2,4)
scatter(TEBCb, TEDC);
hold on
plot(0:0.001:max(TEBCb),0:0.001:max(TEBCb),'r')
CBD=corr(TEBCb, TEDC);
xlabel('TEBC')
ylabel('TEDC')
title(strcat('TE brian v dual, correlation = ',num2str(CBD)))