shortnoisysimtests.real=J;

save('shortnoisysimtests.mat','shortnoisysimtests')

binnedspikes=timematrix2spikes(spikes',1);

shortnoisysimtests.binnedspikes=binnedspikes;

save('shortnoisysimtests.mat','shortnoisysimtests')

shortnoisysimtests.Covariance = cov( binnedspikes );

save('shortnoisysimtests.mat','shortnoisysimtests')

a = GLMtest( binnedspikes, 'normal', 'identity', 20, 1 );
shortnoisysimtests.LMtest =a.test;

save('shortnoisysimtests.mat','shortnoisysimtests')

b = GLMtest( binnedspikes, 'poisson', 'log', 20, 1 );
shortnoisysimtests.GLMtest =b.test;

save('shortnoisysimtests.mat','shortnoisysimtests')

shortnoisysimtests.TransferEntropy = TEfunction(binnedspikes,20);

save('shortnoisysimtests.mat','shortnoisysimtests')