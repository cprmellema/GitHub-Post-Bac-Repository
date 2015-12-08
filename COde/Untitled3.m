spikes2=1:24;
n=4;
k=1;
backstep=6;

if mod(k,n)~=0
        spikes2(:,mod(1:n*(backstep),n)<=k & mod(1:n*(backstep),n)>(k-1))=[];
    else if mod(k,n)==0
             spikes2(:,mod(1:n*(backstep),n)==0)=[];
         end
end
    spikes2