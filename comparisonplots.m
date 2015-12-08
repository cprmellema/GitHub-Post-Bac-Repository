figure

subplot(2,3,1)
imagesc(comparisons.real)
colorbar
title('Real Connections')

subplot(2,3,2)
imagesc(comparisons.covariance)
colorbar
title('Covariances')

subplot(2,3,3)
imagesc(comparisons.differences)
colorbar
title('Sum Comparisons')

subplot(2,3,4)
imagesc(comparisons.GLM)
colorbar
title('Changes in GLM Deviance')

subplot(2,3,5)
imagesc(comparisons.entropy)
colorbar
title('Change in Entropy')

subplot(2,3,6)
imagesc(comparisons.ttest)
colorbar
title('ttest for Sums')