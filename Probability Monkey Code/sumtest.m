Test=zeros(31);

sum=SumSpikesForProbability(50,S);

for i=1:31
    
    [spiked,notspiked]=FindSumsSpikesandNot(i,S,sum);
    
    h=ttest2(spiked,notspiked);
    
    for j=1:30
       if j<i
           Test(i,j)=h(1,j);
       else
           Test(i,j+1)=h(1,j);
       end
    end
    
    clear spiked
    clear notspiked
      
end
