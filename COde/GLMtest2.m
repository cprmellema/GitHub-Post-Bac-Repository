LMspanky001 = LMprocess1('./20130117SpankyUtah001.nev');
LMspanky005 = LMprocess1('./20130117SpankyUtah005.nev');

colormap('winter')
subplot(2,2,1)
image(LMspanky001.deltadeviance)
colorbar
subplot(2,2,2)
imagesc(LMspanky001.pvalues)
colorbar
subplot(2,2,3)
image(LMspanky005.deltadeviance)
colorbar
subplot(2,2,4)
imagesc(LMspanky05.pvalues)
colorbar

LMavgrsq001=sum(LMspanky001.rsquared)/length(LMspanky001.rsquared);
LMavgrsq005=sum(LMspanky005.rsquared)/length(LMspanky005.rsquared);