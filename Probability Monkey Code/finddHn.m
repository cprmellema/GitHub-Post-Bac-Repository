function [ dHn ] = finddHn( Pn, N, response, predictor, backstep )
%Finds the difference in H from the full model with choice probability CPn
%and the H of the model with unit N removed

reducedpredictor=predictor;

reducedpredictor(:,N)=[];

dHn=findH(Pn)-findH(findP(response, reducedpredictor, backstep ));

end

