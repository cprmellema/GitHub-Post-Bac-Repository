sinsimtests.real=J;

save('sinsimtests.mat','sinsimtests')

binnedspikes=timematrix2spikes(spikes',1);

sinsimtests.binnedspikes=binnedspikes;

save('sinsimtests.mat','sinsimtests')

sinsimtests.Covariance = cov( binnedspikes );

save('sinsimtests.mat','sinsimtests')

a = GLMtest( binnedspikes, 'normal', 'identity', 20, 1 );
sinsimtests.LMtest =a.test;

save('sinsimtests.mat','sinsimtests')

b = GLMtest( binnedspikes, 'poisson', 'log', 20, 1 );
sinsimtests.GLMtest =b.test;

save('sinsimtests.mat','sinsimtests')

sinsimtests.TransferEntropy = TEfunction(binnedspikes,20);

save('sinsimtests.mat','sinsimtests')