function [ P ] = findP( response, predictor, backstep)
%finds the choice probability based on the predictor and responder
%specified, based off of the Haefner et Al paper

spikes2=predictor;

avgpredictor=mean(predictor);
avgresponse=mean(response);

[~,n]=size(predictor);

for t=1:backstep
       
    spikes2=circshift(spikes2,[-1,0]);
    spikes2(1,:)=0;
    predictor=[predictor,spikes2];
  
end

B=regress(response, predictor);

C=cov(predictor);

a=zeros(1,length(B)-1);
CP=a;
P=a;
z=1;
k=1;

for i=1:length(avgpredictor)
   a=((sum(B(i)*C(i,:)))/(C(i,i)*(B.')*C*B-((sum(B(i)*C(i,:)))^2)));
   
   CP(1,i)=1/2+2/pi*atan(a/(a^2+2));
   
   P(1,i)=(abs(avgpredictor(1,k)-CP(1,i)))/avgresponse;
   
   z=z+1;
   
   if z>n
       z=1;
       k=k+1;
   end
   
end

end

