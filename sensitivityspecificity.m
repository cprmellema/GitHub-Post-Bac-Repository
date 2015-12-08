function [ sensitivity, specificity, thresholds, thresholds2, TP, FN,FP,TN] = sensitivityspecificity( realconnections, predictors, parts )
%generates sensitivity and specificity data oa a variety of thresholds

[m,n]=size(realconnections);

thresholds=min(predictors):((max(predictors)-min(predictors))/parts):max(predictors);
thresholds2=min(realconnections):((max(realconnections)-min(realconnections))/parts):max(realconnections);
    
sensitivity=zeros(length(thresholds2),length(thresholds));
specificity=sensitivity;
TP=sensitivity;
FP=TP;
FN=TP;
TN=TP;


for z=1:length(thresholds2)

    
    for i=1:length(thresholds)

        for j=1:m 
            for k=1:n
                %TP=true positives, FP=false positives, FN=false negatives,
                %TN=true negatives
                if predictors(j,k)>thresholds(i)&&realconnections(j,k)>=thresholds2(z)
                    TP(z,i)=TP(z,i)+1;
                elseif predictors(j,k)<thresholds(i)&&realconnections(j,k)>=thresholds2(z)
                    FN(z,i)=FN(z,i)+1;
                elseif predictors(j,k)>thresholds(i)&&realconnections(j,k)<thresholds2(z)
                    FP(z,i)=FP(z,i)+1;
                elseif predictors(j,k)<thresholds(i)&&realconnections(j,k)<thresholds2(z)
                    TN(z,i)=TN(z,i)+1;      
                end

            end
        end
        
        
        if (TP(z,i)+FN(z,i))==0

            sensitivity(z,i)=0;

        elseif (TN(z,i)+FP(z,i))==0

            specificity(z,i)=0;

        else
            sensitivity(z,i)=TP(z,i)/(TP(z,i)+FN(z,i));

            specificity(z,i)=TN(z,i)/(TN(z,i)+FP(z,i));
        end
        
    
    end
    
end
