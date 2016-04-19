tic
%noise_sim

[n,m]=size(spikes);
spikes2=spikes;

for i=1:n
    for j=1:m
        if spikes2(i,j)<0
            spikes2(i,j)=0;
        end
    end
end

clear n
clear m
clear i
clear j

toc

beep

spikes3=spikes2(1:10,:);

spiketrains=timematrixtospikes( spikes', 0.05);


tic
noisyTE=cell(1,50);
for i=1:50
   noisyTE{i}=TEfunction(spiketrains,i);
end
beep
toc