% load sinsimtests.mat
% 
% ROCgraphs(sinsimtests,'5 min sin')
% 
% load noisysimtests.mat
% 
% ROCgraphs(noisysimtests,'5 min noise')
% 
% load shortsinsimtests.mat
% 
% ROCgraphs(shortsinsimtests, '3 min sin')

load shortnoisysimtests.mat

ROCgraphs(shortnoisysimtests, '3 min noise')