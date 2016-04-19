function [ out ] = istwoawayFN( hypothesis, real, j, k, thresholdonhypothesis, thresholdonreal)
%True if there is a primary or secondary connection between units j and k
%with the thresholds set in the input, false otherwise
out = false;

%test for primary connection
if hypothesis(j,k)<=thresholdonhypothesis && real(j,k)>thresholdonreal
    out= true;
end

%test for secondary connection
for n=1:length(hypothesis(1,:))
    if hypothesis(j,k)<=thresholdonhypothesis && real(n,k)>thresholdonreal && real(j,n)>thresholdonreal
        out= true;
    end
end

end

