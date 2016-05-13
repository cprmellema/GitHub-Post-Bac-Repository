sinsimtests.real=J;

binnedspikes=timematrix2spikes(spikes',2);

sinsimtests.Covariance = cov( binnedspikes );

a = GLMtest( binnedspikes, 'normal', 'identity', 20, 1 );
sinsimtests.LMtest =a.test;

b = GLMtest( binnedspikes, 'poisson', 'log', 20, 1 );
sinsimtests.GLMtest =b.test;

sinsimtests.TransferEntropy = TEfunction(binnedspikes,20);