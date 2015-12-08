function [ output ] = SumSpikesForProbability( window, spikes )
%Sums preceding spikes for each timepoint

[n,m]=size(spikes);

output=zeros(n,m);

for i=1:n
    for j=1:window
        if i-j>1
        output(i,:)=output(i,:)+spikes(i-j,:);
        end
    end
end

end

