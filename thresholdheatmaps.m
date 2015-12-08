figure
[ sensitivity, specificity, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Entropy,100);
distances=((sensitivity-(1-specificity)));
imagesc(distances);
colorbar
title('Entropy, thresholds heat map (distance from y=x on ROC curve based on thresholds)')
xlabel('predictor thresholds (% of max value)')
ylabel('true value thresholds (% of max value)')

figure
[ sensitivity, specificity, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.GLMtest,100);
distances=((sensitivity-(1-specificity)));
imagesc(distances);
colorbar
title('Granger, thresholds heat map (distance from y=x on ROC curve based on thresholds)')
xlabel('predictor thresholds (% of max value)')
ylabel('true value thresholds (% of max value)')

figure
[ sensitivity, specificity, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Covariance,100);
distances=((sensitivity-(1-specificity)));
imagesc(distances);
colorbar
title('Covariances, thresholds heat map (distance from y=x on ROC curve based on thresholds)')
xlabel('predictor thresholds (% of max value)')
ylabel('true value thresholds (% of max value)')

figure
[ sensitivity, specificity, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Differences,100);
distances=((sensitivity-(1-specificity)));
imagesc(distances);
colorbar
title('Differences, thresholds heat map (distance from y=x on ROC curve based on thresholds)')
xlabel('predictor thresholds (% of max value)')
ylabel('true value thresholds (% of max value)')