[ sensitivity{1}, specificity{1}, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Differences,100);

[ sensitivity{2}, specificity{2}, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Covariance,100);

[ sensitivity{3}, specificity{3}, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.GLMtest,100);

[ sensitivity{4}, specificity{4}, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.GLMpoissonlin,100);

[ sensitivity{5}, specificity{5}, ~ , ~, ~, ~,~,~ ] = sensitivityspecificity(ans1.real,ans1.Entropy,100);

summarystats=cell(5,1);

for i=1:5
    summarystats{i,1}=cell(2,1);
    summarystats{i,1}{1,1}=zeros(99,1);
    summarystats{i,1}{2,1}=zeros(99,1);
end

for k=2:100
        
        for i=1:5
            summarystats{i,1}{1,1}(k-1,1)=-ROCarea(sensitivity{i}(k,:),specificity{i}(k,:));
        end

        for i=1:5
            summarystats{i,1}{2,1}(k-1,1)=maxROCdist(sensitivity{i}(k,:),specificity{i}(k,:));
        end
        
end

maxsumstats=zeros(5,2);

for i=1:5
   maxsumstats(i,1)=max(max(summarystats{i,1}{1,1}));
   maxsumstats(i,2)=max(max(summarystats{i,1}{2,1}));
end
