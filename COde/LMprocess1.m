function output = LMprocess1(nevfile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%this preprocesses the raw data and sorts it into a matrixof spikes
p = preprocess(nevfile);
spikes = p.binnedspikes;
output.spikes = spikes;
output.names = p.unitnames;

%this saves the spikes dimensions
[~,n]=size(spikes);

%this initiates the coefficient matrix for the linear model
coeff=zeros(n+1);
originaldeviances=zeros(n,1);

%this determines the coefficients for the linear model
for k=1:n
    spikes2=spikes;
    spikes0=spikes(:,k);
    spikes2(:,k)=0;
    [coeff(k,:),originaldeviances(k,1)]= glmfit(spikes2,spikes0);
end
coeff(end,:)=[];

output.coefficients=coeff;

%initiating the deviance matrix
Deviance=zeros(n);

%this calculates the deviances for the data
for j=1:n
    spikes2=spikes;
    spikes0=spikes(:,j);
    spikes2(:,j)=0;
    for k=1:n
        if k~=j
            spikes3=spikes2;
            spikes3(:,k)=[];
            [~,Deviance(j,k)]=glmfit(spikes3,spikes0);
        end
    end
    
end

%this initiates the change in deviance matrix
deltadeviance=zeros(n);

%this calculates the change in deviance for the data
for t=1:n
   for g=1:n
       if g~=t
          deltadeviance(t,g)=Deviance(t,g)-originaldeviances(t,1); 
       end
   end
end

output.deltadeviance=deltadeviance;

% chi squared test
p0=chi2cdf(deltadeviance, n-2);
output.pvalues=p0;

%applying gaussian filter
filter1 = fspecial('gaussian',[30,1],15);
mu1=imfilter(spikes,filter1); 

constants1=coeff(:,1);
coeff(:,1)=[];

muhat1=spikes*coeff;
plot(muhat1,1:length(muhat1))

for p=1:n
    muhat1(:,p)=muhat1(:,p)+constants1(p);
end
output.muhat=muhat1;
%tests the predicted (muhat1) versus the actual with a gaussian
%filter(mu1) by performing a linear regression of mu vs muhat
%and recording the r squared values
rsq=zeros(1,n);

for h=1:n
    x=muhat1(:,h);
    y=mu1(:,h);
    p=polyfit(x,y,1);
    yfit=polyval(p,x);
    yresid=y-yfit;
    ssresid=sum(yresid.^2);
    sstot=(length(y)-1)*var(y);
    rsq(1,h)=1-ssresid/sstot;
end
output.rsquared=rsq;

end