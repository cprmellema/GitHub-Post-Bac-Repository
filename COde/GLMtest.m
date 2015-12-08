p = preprocess('./20130117SpankyUtah005.nev');
spikes = p.binnedspikes;

p2 = preprocess('./20130117SpankyUtah001.nev');
spikes20 = p2.binnedspikes;

[m,n]=size(spikes);
[l,o]=size(spikes20);

coeff=zeros(n+1);
originaldeviances=zeros(n,1);
coeff1=zeros(o+1); 
originaldeviances1=zeros(o,1);

for k=1:n
    spikes2=spikes;
    spikes0=spikes(:,k);
    spikes2(:,k)=0;
    [coeff(k,:),originaldeviances(k,1)]= glmfit(spikes2,spikes0);
end
coeff(end,:)=[];

Deviance=zeros(n);

for k=1:o
    spikes02=spikes20;
    spikes00=spikes20(:,k);
    spikes02(:,k)=0;
    [coeff1(k,:),originaldeviances1(k,1)]= glmfit(spikes02,spikes00);
end
coeff1(end,:)=[];

Deviance1=zeros(o);

for j=1:n
    spikes2=spikes;
    spikes0=spikes(:,j);
    spikes2(:,j)=0;
    for k=1:n
        if k~=j
            spikes3=spikes2;
            spikes3(:,k)=[];
            [newcoeff,Deviance(j,k)]=glmfit(spikes3,spikes0);
            clear newcoeff
        end
    end
    
end

deltadeviance=zeros(n);

for j=1:o
    spikes02=spikes20;
    spikes00=spikes20(:,j);
    spikes02(:,j)=0;
    for k=1:o
        if k~=j
            spikes03=spikes02;
            spikes03(:,k)=[];
            [newcoeff,Deviance1(j,k)]=glmfit(spikes03,spikes00);
            clear newcoeff
        end
    end
    
end

deltadeviance1=zeros(o);

for t=1:n
   for g=1:n
       if g~=t
          deltadeviance(t,g)=Deviance(t,g)-originaldeviances(t,1); 
       end
   end
end

for t=1:o
   for g=1:o
       if g~=t
          deltadeviance1(t,g)=Deviance1(t,g)-originaldeviances1(t,1); 
       end
   end
end

p0=chi2cdf(deltadeviance, n-2);
p1=chi2cdf(deltadeviance1, o-2);

colormap('winter')
subplot(2,2,1)
image(deltadeviance)
colorbar
subplot(2,2,2)
imagesc(p0)
colorbar
subplot(2,2,3)
image(deltadeviance1)
colorbar
subplot(2,2,4)
imagesc(p1)
colorbar

filter1 = fspecial('gaussian',[30,1],15);
filter2 = fspecial('gaussian',[30,1],15);
mu1=imfilter(spikes,filter1); 
mu2=imfilter(spikes20,filter2); 
constants1=coeff(:,1);
constants2=coeff1(:,1);

coeff(:,1)=[];
coeff1(:,1)=[];

muhat1=spikes*coeff;
muhat2=spikes20*coeff1;
[q,k]=size(spikes);
[l,m]=size(spikes20);

for p=1:k
    muhat1(:,p)=muhat1(:,p)+constants1(p);
end

for p=1:m
    muhat2(:,p)=muhat2(:,p)+constants2(p);
end
plot(muhat1,1:length(muhat1))
% y=x;
% plot(mu2,muhat2,'.')
% hold on
% plot(x,y,'b');
% axis([0 5 0 5])
% title('Predicted Firing Rate Versus Smoothed Observed Rate')