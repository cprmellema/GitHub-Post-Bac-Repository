function [ output ] = MultipleAnalysis( spikes, backstep )
%does 4 comparisons: covariance, spike summing, Granger, and Transfer
%entropy

output.Covariance = cov( spikes );

output.Differences = SumTest2(spikes, backstep);

a = GLMtest( spikes, 'normal', 'identity', backstep, 1 );
output.GLMtest =a.test;

b = GLMtest( spikes, 'poisson', 'log', backstep, 1 );
output.GLMtest =b.test;

%output.Entropy = findAlldHNs( spikes, backstep );

output.TransferEntropy = TEfunction(spikes,3);

end

