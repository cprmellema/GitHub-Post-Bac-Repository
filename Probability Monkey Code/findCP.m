function [ CP ] = findCP( response, predictor, backstep)
%finds the choice probability based on the predictor and responder
%specified, based off of the Haefner et Al paper

spikes2=predictor;

for t=1:backstep
       
    spikes2=circshift(spikes2,[-1,0]);
    spikes2(1,:)=0;
    predictor=[predictor,spikes2];
  
end

B=regress(response, predictor);

C=cov(predictor);

a=zeros(1,length(B));
CP=a;

for i=1:length(B)
   a=((sum(B(i)*C(i,:)))/(C(i,i)*(B.')*C*B-((sum(B(i)*C(i,:)))^2)));
   
   CP(1,i)=1/2+2/pi*atan(a/(a^2+2));
end

end

