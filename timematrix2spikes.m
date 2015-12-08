function [ spikes ] = timematrix2spikes( spiketimes, binsize )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[~,n]=size(spiketimes);

maxtime=max(max((spiketimes)));

spikes=zeros(round(maxtime/binsize)+1,n);

for i=1:n
    spikes(:,i)=times2binned(spiketimes(:,i), binsize, maxtime);
end

end