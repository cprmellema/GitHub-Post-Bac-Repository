function output = GLMtest( spikes,distrib,link,backstep,forwardstep)
%
%This function takes a .nev file with data on neural spiking and 
%torques and generates a generalized linear model with the link function
%'link' and the error distribution 'distrib'. It uses the spiking of
%all units except the one being predicted at 'backstep' previous time
%steps. In other words, it predicts the behaviour of unit N using the 
%behavior of all units j!=N at times t-1, t-2,... t-backstep. It 
%outputs the actual spiking behavior, the names of the spikes, the
%matrix of spikes at [t-1|t-2|...|t-backstep] for predictions (called
%'spikesprime', the %coefficient matrix for predicting behavior, the 
%original deviances of the data, the deviances of the data with a single 
%unit removed from the model, the change in deviance between the current 
%and reduced model, the p values from a chi squared test looking at the 
%change in deviance,a smoothed version of the actual spiking train to use 
%in statistical testing, a matrix of the predicted firing rate ('muhat'), 
%and the r squared value of a linear fit plotting the predicted vs. the 
%actual firing rate (they should be ~the same, and a higher r^2 indicates
%a better predictive power in the model
%
%
%% Preprocessing data and initiating variables

%because of one iteration outside of a loop, we crank backstep back 
%by 1. This does impose the constraint on the code that the backstep
%must be >=2
tic
backstep=backstep-1;
forwardstep=forwardstep-1;
position = spikes(:,end-1:end);

%this is outputting the actual spikes and the names of the units
%that are spiking
output.position = position;

%this saves the number of units that are spiking
[m,n]=size(spikes);

%this initiates the coefficient matrix for the linear model
spikes2=spikes;
originaldeviances=zeros(1,n);


%% Determining coefficients for the model

%this sets up the matrix that we will use to predict the firing. It
%is generating the matrix of spikes at [t-1|t-2|...|t-backstep]

 spikes2=circshift(spikes2,[1,0]);
 spikes2(1,:)=0;
 spikesprime1=spikes2;

for t=1:forwardstep
       
    spikes2=circshift(spikes2,[1,0]);
    spikes2(1,:)=0;
    spikesprime1=[spikesprime1,spikes2];
    
end

 spikes2=spikes;
 spikes2=circshift(spikes2,[-1,0]);
 spikes2(m,:)=0;
 spikesprime2=spikes2;

for t=1:backstep
       
    spikes2=circshift(spikes2,[-1,0]);
    spikes2(m,:)=0;
    spikesprime2=[spikesprime2,spikes2];
    
end

spikesprime=[spikesprime1,spikesprime2];
[~,l]=size(spikesprime);

%this is the matrix of spikes at of spikes at [t-1|t-2|...|t-backstep]
output.spikesprime=spikesprime;

%this is removing the kth unit from the predictive matrix and is using
%the other units spike histories in order to predict the spiking of 
%unit k. It is fitting coefficients of a generalized linear model with
%error distribution and link function specified above using the past
%'backstep' number of spikes of all units!=k fitted to the actual
%spiking of unit k

coeff=cell(1,n);

for k=1:n
    spikes2=spikesprime;
    spikes0=spikes(:,k);
    
        [coeff{1,k},originaldeviances(1,k),stats(1,k)]= glmfit(spikes2,spikes0,distrib,link);
  
%     meansqerror(1,k)=(((sum((stats.resid.^2)))/((size(stats(1,k).resid,1))))^(1/2));
end


%These outputs are the coefficients of the model and the deviances
%of the model for each unit

output.stats=stats;
% %output.meansqerror=meansqerror;
output.coefficients=coeff;
% output.originaldeviances=originaldeviances;

%%%% Calculating the change in deviance when a unit is dropped from
%the model

%initiating the deviance matrix
Deviance=zeros(n,n);

%this calculates the deviances for the data with a single unit dropped
for j=1:n
    for k=1:n
    
       spikes2=spikesprime;
       spikes0=spikes(:,k);
      
        if j~=k

             if k==n
                 spikes2(:,mod(1:n*(backstep+1),n)==0 | mod(1:n*(backstep+1),n)==j)=[];
             elseif j==n
                     spikes2(:,mod(1:n*(backstep+1),n)==k | mod(1:n*(backstep+1),n)==0)=[];  
             else    
                 spikes2(:,mod(1:n*(backstep+1),n)==k | mod(1:n*(backstep+1),n)==j)=[];
             end
             
             [~,Deviance(j,k)]=glmfit(spikes2,spikes0,distrib);
             
        end
    end
end


% output.newdeviances=Deviance;

%this calculates the change in deviance for the data
for t=1:n
   for g=1:n
       if g~=t
          deltadeviance(g,t)=Deviance(g,t)-originaldeviances(1,t); 
       end
   end
end

% output.deltadeviance=deltadeviance;
test=deltadeviance;

for k=1:n
    test(:,k)=test(:,k)/var(spikes(:,k));
end

output.test=test;

%% Additional statistical testing, including a chi squared test and
%a measure of predictiveness

% % chi squared test between the new and reduced model
% p0=chi2cdf(deltadeviance, n-2);
% output.pvalues=p0;

%applying gaussian filter to the data (without a gaussian filter, the
%results are nonsensical when graphed because of the discreete nature
%of the spikes)
% filter1 = fspecial('gaussian',[30,1],15);
% mu1=imfilter(spikes,filter1); 
% 
% output.smoothed=mu1;
% 
% %this bit of code linearly fits the predicted spiking (smoothed) versus
% %the actual spiking. The closer this prediction is to y=x the better
% %the model fits overall. The r^2 of this model is a measure of
% %"predictiveness"
% 
% for j=1:n
%     
%     spikesprime2=spikesprime;
%     
%     muhat(:,j)=glmval(coeff(:,j),spikesprime2,link);
% end
% 
% output.predicted=muhat;
% 
% %tests the predicted (muhat1) versus the actual with a gaussian
% %filter(mu1) by performing a linear regression of mu vs muhat
% %and recording the r squared values
% rsq=zeros(1,n);
% 
% for h=1:n
%     x=muhat1(:,h);
%     y=mu1(:,h);
%     p=polyfit(x,y,1);
%     yfit=polyval(p,x);
%     yresid=y-yfit;
%     ssresid=sum(yresid.^2);
%     sstot=(length(y)-1)*var(y);
%     rsq(1,h)=1-ssresid/sstot;
% end
% 
% output.rsquared=rsq;
toc
end