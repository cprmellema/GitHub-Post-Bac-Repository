addpath(genpath('F:/Post-Bac'))

simspikes=simNetworkGLMCoupled;

clear B

for i=1:30
    B(:,i)=times2binned(simspikes{1,i},0.01);
end