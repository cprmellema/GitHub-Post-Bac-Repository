function [ output ] = MultipleAnalysis( spikes, backstep )
%does 4 comparisons: covariance, spike summing, Granger, and Transfer
%entropy

output.Covariance = cov( spikes );

output.Differences = SumTest2(spikes, backstep);

a = GLMtest( spikes, 'normal', 'identity', backstep, 1 );
output.GLMtest =a.test;

output.Entropy = findAlldHNs( spikes, backstep );

end

