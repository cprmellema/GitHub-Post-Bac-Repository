function [ H ] = findH( P )
%finds the entropy H based off of the choice probability

H=zeros(1,length(P));

for i=1:length(P)
  
   if P(i)>0

       H(i)=P(i)*log(P(i)); 
       
   end
end

H=sum(H);

end

