spikes2=spikes;
coeff=zeros(n,n+1,backstep);

for t=0:backstep-1
    
    for k=1:n
        spikes0=spikes(:,k);
        spikes3=spikes2(:,k);
        spikes2(:,k)=0;
        [coeff(k,:,t+1)]= glmfit(spikes2,spikes0);
        spikes2(:,k)=spikes3;
    end
    
    spikes2=circshift(spikes2,[1,0]);
    spikes2(1,:)=0;
    
end

filter1 = fspecial('gaussian',[30,1],15);
mu1=imfilter(spikes,filter1); 

constants1=coeff(:,1,:);
coeff(:,1,:)=[];

muhat1=zeros(m,n);
spikes2=spikes;

for t=0:backstep-1
    muhat1=muhat1+spikes2*coeff(:,:,t+1);
    
    for p=1:n
    	muhat1(p,:)=muhat1(p,:)+constants1(:,1,t+1).';
    end
    
    spikes2=circshift(spikes2,[1,0]);
    spikes2(1,:)=0;
%     plot(muhat1,1:length(muhat1))
end

