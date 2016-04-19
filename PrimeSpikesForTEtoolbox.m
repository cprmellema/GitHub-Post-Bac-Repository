function [ out ] = PrimeSpikesForTEtoolbox( toBsampled )
%Primes spikes for TE Toolbox 
   addpath(genpath('F:\Post-Bac'));

   asdf=SparseToASDF(toBsampled',1);
   
   simple_demo;
   
   out=TE333';
   
end

