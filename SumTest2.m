function [ diff ] = SumTest2( spikes, backstep)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[~,n]=size(spikes);

sum=SumSpikesForProbability(backstep,spikes);

diff=zeros(n,n);

for i=1:n
    
    [spiked,notspiked]=FindSumsSpikesandNot(i,spikes,sum);

    clear k
    for k=1:n-1
       f=spiked(:,k);
       g=notspiked(:,k);
       a=0;
       b=0;
       for z=1:length(f)
           a=a+f(z);
       end
       for z=1:length(g)
           b=b+g(z);
       end
       h(k)=abs((a)/length(f)-(b)/length(g));
       
    end
    
    for j=1:n-1
       if j<i
           diff(i,j)=h(1,j);
       else
           diff(i,j+1)=h(1,j);
       end
    end
      
end

end

