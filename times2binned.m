function [ spikes ] = times2binned( spiketimes, binsize, maxtime )
%converts spiketimes to spikes in bins

spikes=zeros(round(maxtime/binsize)+1,1);

for i=1:length(spiketimes)
   
    if round((1/binsize)*round2(spiketimes(i), binsize))>0

        if spiketimes(i)>0
            spikes((1/binsize)*round2(spiketimes(i), binsize),1)=spikes((1/binsize)*round2(spiketimes(i), binsize),1)+1; 
        end
        
    end
end
end



