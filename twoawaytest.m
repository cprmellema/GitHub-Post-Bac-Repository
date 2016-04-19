function [ out ] = twoawaytest( hypothesis, real, j, k, thresholdonhypothesis, thresholdonreal)
%True if there is a secondary connection between units j and k
%with the thresholds set in the input, false otherwise

out=FALSE;

for i=1:length(hypothesis(1,:))
    if hypothesis(j,k)>thresholdonhypothesis && real(n,k)>thresholdonreal && real(j,n)>thresholdonreal
        out=TRUE;
    end
end

end

