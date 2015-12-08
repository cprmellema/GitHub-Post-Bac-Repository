function [ spiked, notspiked, tTests ] = SumTest( spikes, pval, backstep)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[~,n]=size(spikes);

sum=SumSpikesForProbability(backstep,spikes);

for i=1:n
    
    [spiked,notspiked]=FindSumsSpikesandNot(i,spikes,sum);
    
    h=ttest2(spiked, notspiked, 'Alpha',pval);
    
    for j=1:n-1
       if j<i
           tTests(i,j)=h(1,j);
       else
           tTests(i,j+1)=h(1,j);
       end
    end
      
end

end

