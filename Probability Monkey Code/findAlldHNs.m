function [ dHns ] = findAlldHNs( spikes, backstep )
%makes a matrix of the change in entropy for unit i with unit j dropped

[~,n]=size(spikes);

dHns=zeros(n);

for i=1:n
    spikes2=spikes;
    spikes2(:,i)=[];
    Pn=findP(spikes(:,i),spikes2, backstep);
    
    for j=1:n-1
        
        if j<i
            dHns(i,j)=finddHn( Pn, j, spikes(:,i), spikes2, backstep );
        else
            dHns(i,j+1)=finddHn( Pn, j, spikes(:,i), spikes2, backstep );
        end
    end
end

end