function [ TPR, FPR, thresholds ] = TPRFPR( realconnections, predictors, parts )
%generates sensitivity and specificity data oa a variety of thresholds

[m,n]=size(realconnections);

thresholds=min(predictors):((max(predictors)-min(predictors))/parts):max(predictors);

TPR=zeros(1,length(thresholds));
FPR=zeros(1,length(thresholds));

for i=1:length(thresholds)
    TP=0;
    FP=0;
    FN=0;
    TN=0;
    for j=1:m 
        for k=1:n
            %TP=true positives, FP=false positives, FN=false negatives,
            %TN=true negatives
            if predictors(j,k)>thresholds(i)&&realconnections(j,k)>0
                TP=TP+1;
            elseif predictors(j,k)<thresholds(i)&&realconnections(j,k)>0
                FN=FN+1;
            elseif predictors(j,k)>thresholds(i)&&realconnections(j,k)==0
                FP=FP+1;
            elseif predictors(j,k)<thresholds(i)&&realconnections(j,k)==0
                TN=TN+1;      
            end
            
        end
    end
    
    TPR(i)=TP/(TP+FN);
    
    FPR(i)=TP/(TP+FP);

end

