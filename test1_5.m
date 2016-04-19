figure
scatter(reshape(ans1.real,[1,900]),reshape(ans1.Covariance,[1,900]))
xlabel('Real Connection Strength')
ylabel('Predicted Connection Strength')
title('Covariances')

figure
scatter(reshape(ans1.real,[1,900]),reshape(ans1.Differences,[1,900]))
xlabel('Real Connection Strength')
ylabel('Predicted Connection Strength')
title('Differences')

figure
scatter(reshape(ans1.real,[1,900]),reshape(ans1.GLMtest,[1,900]))
xlabel('Real Connection Strength')
ylabel('Predicted Connection Strength')
title('Linear Model')

figure
scatter(reshape(ans1.real,[1,900]),reshape(ans1.Entropy,[1,900]))
xlabel('Real Connection Strength')
ylabel('Predicted Connection Strength')
title('Entropy')

figure
scatter(reshape(ans1.real,[1,900]),reshape(ans1.GLMpoissonlin,[1,900]))
xlabel('Real Connection Strength')
ylabel('Predicted Connection Strength')
title('Poisson GLM, Normal Error Distribution')