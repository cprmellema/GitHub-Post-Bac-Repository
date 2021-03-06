noisysimtests.real=J;

binnedspikes=times2binned(spikes,0.05);

noisysimtests.Covariance = cov( binnedspikes );

a = GLMtest( binnedspikes, 'normal', 'identity', 20, 1 );
output.GLMtest =a.test;

b = GLMtest( binnedspikes, 'poisson', 'log', 20, 1 );
output.GLMtest =b.test;

output.TransferEntropy = TEfunction(spikes,20);