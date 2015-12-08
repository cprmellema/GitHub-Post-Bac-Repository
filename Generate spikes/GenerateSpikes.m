C=rand(31,31);

for i=1:31
    for j=1:31
        if i==j
            C(i,j)=1;
        elseif C(i,j)<0.3
            C(i,j)=0;
        elseif C(i,j)>=0.6
            C(i,j)=1;
        else
            C(i,j)=0.5;
        end
        C(j,i)=C(i,j);
    end
end

clear i

for i=1:31
    C2=C;
    C2(:,i)=[];
    S(i,:)=sampleCovPoisson(0.2,C2,15000);
end

S=S';