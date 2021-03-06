function [ output ] = ProcessAndAnalyse( spikebins, nspikes, binsize, backstep, J )
%does 4 comparisons: covariance, spike summing, Granger, and Transfer
%entropy
tic
% spikebins=timematrix2spikes(spiketimes',binsize);

subsample=randselect(spikebins,nspikes);

for i=1:nspikes
    
    samplethis(:,i)=cell2mat(subsample(2,i));
    
end

for i=1:nspikes
    
    names(1,i)=str2num(cell2mat(subsample(1,i)));
    
end

output.names=names;

output.real=FindRealConnections(names,J);

output.Covariance = cov( samplethis );

output.Differences = SumTest2(samplethis, backstep);

tic
a = GLMtest( toBsampled, 'normal', 'identity', 1 , 30 );
noisytests.LM =a.test;

b = GLMtest( toBsampled, 'poisson', 'log', 1 , 30 );
noisytests.GLM =b.test;

toc
beep

output.Entropy = findAlldHNs( samplethis, backstep );
toc

end

