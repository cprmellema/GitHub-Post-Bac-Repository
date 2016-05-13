noisysimtests.real=J;

binnedspikes=timematrix2spikes(spikes',10);

noisysimtests.Covariance = cov( binnedspikes );

a = GLMtest( binnedspikes, 'normal', 'identity', 20, 1 );
noisysimtests.LMtest =a.test;

b = GLMtest( binnedspikes, 'poisson', 'log', 20, 1 );
noisysimtests.GLMtest =b.test;

noisysimtests.TransferEntropy = TEfunction(binnedspikes,20);