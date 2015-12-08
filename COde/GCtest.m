p = preprocess('./20130117SpankyUtah005.nev');
spikes = p.binnedspikes;
output.spikes = spikes;
output.names = p.unitnames;
backstep=6;

%this saves the spikes dimensions
[~,n]=size(spikes);

%this initiates the coefficient matrix for the linear model
coeff=zeros(n+1,backstep*n);
originaldeviances=zeros(n,backstep);

%this determines the coefficients for the linear model
spikes2=spikes;
for j=0:backstep-1
    
    for k=1:n
        spikes0=spikes(:,k);
        spikes3=spikes2(:,k);
        spikes2(:,k)=0;
        [coeff(:,k+j*n)]= glmfit(spikes2,spikes0);
        spikes2(:,k)=spikes3;
    end
    
    spikes2=circshift(spikes2,[1,0]);
    spikes2(1,:)=0;
end

coeff