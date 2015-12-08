n=33;
backstep=6;


for j=1:n
    for k=1:n
    
       spikes2=1:n*backstep;
      
        if j~=k

             if k==n
                 spikes2(:,mod(1:n*(backstep),n)==0 | mod(1:n*(backstep),n)==j)=[];
             elseif j==n
                     spikes2(:,mod(1:n*(backstep),n)==k | mod(1:n*(backstep),n)==0)=[];  
             else    
                 spikes2(:,mod(1:n*(backstep),n)==k | mod(1:n*(backstep),n)==j)=[];
             end
             size(spikes2)
        end
    end
end