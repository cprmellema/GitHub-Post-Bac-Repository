function [ subsampledconnections ] = FindRealConnections( subsamplenames, connections )
%takes the real connections and selects those with the same names as the
%names vector

n=length(subsamplenames);

subsampledconnections=zeros(n,n);

for i=1:n
    horizunit=(subsamplenames(1,i));
    for j=1:n
        verticunit=(subsamplenames(1,j));
        
        subsampledconnections(i,j)=connections(horizunit,verticunit);
        
    end
end

end

