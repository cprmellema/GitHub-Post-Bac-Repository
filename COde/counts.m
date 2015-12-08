function [ out ] = counts( Matrix )
%gives the counts in a bin for the input
T=max(Matrix);
T2=max(T);
F=min(Matrix);
F2=min(F);
maxim=ceil(T2);
minim=floor(F2);

val=(minim:maxim);
counts=(1:length(val));

for k=1:length(counts)
   counts(k)=0;
end

[~,s]=size(Matrix);

for j=1:s
    for n=1:length(val)
        h=histc(Matrix(:,j),[minim+1*(n-1),minim+1*n]);
        counts(n)=h(1,1);
    end
end

out=counts;

end

