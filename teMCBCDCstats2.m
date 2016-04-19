conn = database('','root','Fairbanks1!','com.mysql.jdbc.Driver', ...
	'jdbc:mysql://fairbanks.amath.washington.edu:3306/spanky_db');


teMCBC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, et.`tuning_type` FROM `experiment_tuning` et '...
'INNER JOIN `fits` fMC '...
'ON et.`manualrecording` = fMC.`nev file` '...
'INNER JOIN `estimates_te` egMC '...
'ON egMC.`id` = fMC.`id` '...
'INNER JOIN `fits` fBC '...
'ON et.`1DBCrecording` = fBC.`nev file` '...
'INNER JOIN `estimates_te` egBC '...
'ON egBC.`id` = fBC.`id` '...
'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id']));

teMC = cell2mat(teMCBC.Data(:,5));
teBC = cell2mat(teMCBC.Data(:,6));
tuningtype = cell2mat(teMCBC.Data(:,7));

devconstMC = cell2mat(teMCBC.Data(:,7));
devconstBC = cell2mat(teMCBC.Data(:,8));
normteMC = 100*teMC./devconstMC;
normteBC = 100*teBC./devconstBC;

unrot1 = tuningtype == 5;
rot1 = (tuningtype == 1 | tuningtype == 3| tuningtype == 4);
untuned1 = tuningtype == 4;

teMCMC2 = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, fconstMC.dev, fconstBC.dev, et.`tuning_type` FROM `experiment_tuning` et '...
'INNER JOIN `fits` fMC '...
'ON et.`manualrecording` = fMC.`nev file` '...
'INNER JOIN `estimates_te` egMC '...
'ON egMC.`id` = fMC.`id` '...
'INNER JOIN `fits` fBC '...
'ON et.`manualrecordingafter` = fBC.`nev file` '...
'INNER JOIN `estimates_te` egBC '...
'ON egBC.`id` = fBC.`id` '...
'INNER JOIN `fits` fconstBC '...
'ON fconstBC.`nev file` = et.`1DBCrecording` AND fconstBC.unit = fMC.unit '...
'INNER JOIN `fits` fconstMC '...
'ON fconstMC.`nev file` = et.`manualrecording` AND fconstMC.unit = fMC.unit '...
'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id '...
'AND fconstBC.modelID = 31 AND fconstMC.modelID = 31'])); 

teMCb = cell2mat(teMCMC2.Data(:,5));
teMC2 = cell2mat(teMCMC2.Data(:,6));
devconstMCb = cell2mat(teMCMC2.Data(:,7));
devconstMC2 = cell2mat(teMCMC2.Data(:,8));
tuningtype = cell2mat(teMCMC2.Data(:,9));
normteMCb = teMCb./devconstMCb;
normteMC2 = teMC2./devconstMC2;

unrot2 = tuningtype == 5;
rot2 = (tuningtype == 1 | tuningtype == 3| tuningtype == 4);
untuned2 = tuningtype == 4;

teMCDC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, fconstMC.dev, fconstBC.dev, et.`tuning_type` FROM `experiment_tuning` et '...
'INNER JOIN `fits` fMC '...
'ON et.`manualrecording` = fMC.`nev file` '...
'INNER JOIN `estimates_te` egMC '...
'ON egMC.`id` = fMC.`id` '...
'INNER JOIN `fits` fBC '...
'ON et.`dualrecording` = fBC.`nev file` '...
'INNER JOIN `estimates_te` egBC '...
'ON egBC.`id` = fBC.`id` '...
'INNER JOIN `fits` fconstBC '...
'ON fconstBC.`nev file` = et.`1DBCrecording` AND fconstBC.unit = fMC.unit '...
'INNER JOIN `fits` fconstMC '...
'ON fconstMC.`nev file` = et.`manualrecording` AND fconstMC.unit = fMC.unit '...
'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id'...
' AND fconstBC.modelID = 31 AND fconstMC.modelID = 31']));

teMCc = cell2mat(teMCDC.Data(:,5));
teDC = cell2mat(teMCDC.Data(:,6));
devconstMCc = cell2mat(teMCDC.Data(:,7));
devconstDC = cell2mat(teMCDC.Data(:,8));
tuningtype = cell2mat(teMCDC.Data(:,9));
normteMCc = teMCc./devconstMCc;
normteDC = teDC./devconstDC;

unrot3 = tuningtype == 5;
rot3 = (tuningtype == 1 | tuningtype == 3| tuningtype == 4);
untuned3 = tuningtype == 4;

teBCDC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, fconstMC.dev, fconstBC.dev, et.`tuning_type` FROM `experiment_tuning` et '...
'INNER JOIN `fits` fMC '...
'ON et.`1DBCrecording` = fMC.`nev file` '...
'INNER JOIN `estimates_te` egMC '...
'ON egMC.`id` = fMC.`id` '...
'INNER JOIN `fits` fBC '...
'ON et.`dualrecording` = fBC.`nev file` '...
'INNER JOIN `estimates_te` egBC '...
'ON egBC.`id` = fBC.`id` '...
'INNER JOIN `fits` fconstBC '...
'ON fconstBC.`nev file` = et.`1DBCrecording` AND fconstBC.unit = fMC.unit '...
'INNER JOIN `fits` fconstMC '...
'ON fconstMC.`nev file` = et.`manualrecording` AND fconstMC.unit = fMC.unit '...
'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id '...
'AND fconstBC.modelID = 31 AND fconstMC.modelID = 31']));

teBCb = cell2mat(teBCDC.Data(:,5));
teDC = cell2mat(teBCDC.Data(:,6));
devconstBCb = cell2mat(teBCDC.Data(:,7));
devconstDC = cell2mat(teBCDC.Data(:,8));
tuningtype = cell2mat(teBCDC.Data(:,9));

unrot4 = tuningtype == 5;
rot4 = (tuningtype == 1 | tuningtype == 3| tuningtype == 4);
untuned4 = tuningtype == 4;

normteBCb = teBCb./devconstBCb;
normteDC = teDC./devconstDC;

corrs(1) = corr(teMC, teBC);
corrs(2) = corr(teMCb, teMC2);
corrs(3) = corr(teMCc, teDC);
corrs(4) = corr(teBCb, teDC);

corrsrotated(1) = corr(teMC(rot1), teBC(rot1));
corrsrotated(2) = corr(teMCb(rot2), teMC2(rot2));
corrsrotated(3) = corr(teMCc(rot3), teDC(rot3));
corrsrotated(4) = corr(teBCb(rot4), teDC(rot4));

% corrsunrotated(1) = corr(teMC(unrot1), teBC(unrot1));
% corrsunrotated(2) = corr(teMCb(unrot2), teMC2(unrot2));
% corrsunrotated(3) = corr(teMCc(unrot3), teDC(unrot3));
% corrsunrotated(4) = corr(teBCb(unrot4), teDC(unrot4));

clf
% subplot(2,2,1)
% plot(teMC, teBC, '.')
% xlabel('MC')
% ylabel('BC')
% title(['corr rotated: ' num2str(corrsrotated(1)) ' corr unrotated: ' num2str(corrsunrotated(1))])
% subplot(2,2,2)
% plot(teMCb, teMC2, '.')
% xlabel('MC1')
% ylabel('MC2')
% title(['corr rotated: ' num2str(corrsrotated(2)) ' corr unrotated: ' num2str(corrsunrotated(2))])
% subplot(2,2,3)
% plot(teMCc, teDC, '.')
% xlabel('MC')
% ylabel('DC')
% title(['corr rotated: ' num2str(corrsrotated(3)) ' corr unrotated: ' num2str(corrsunrotated(3))])
% subplot(2,2,4)
% plot(teBCb, teDC, '.')
% xlabel('BC')
% ylabel('DC')
% title(['corr rotated: ' num2str(corrsrotated(4)) ' corr unrotated: ' num2str(corrsunrotated(4))])
% saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tecondcompare.eps')

normcorrs(1) = corr(normteMC, normteBC);
normcorrs(2) = corr(normteMCb, normteMC2);
normcorrs(3) = corr(normteMCc, normteDC);
normcorrs(4) = corr(normteBCb, normteDC);

normcorrsrotated(1) = corr(normteMC(rot1), normteBC(rot1));
normcorrsrotated(2) = corr(normteMCb(rot2), normteMC2(rot2));
normcorrsrotated(3) = corr(normteMCc(rot3), normteDC(rot3));
normcorrsrotated(4) = corr(normteBCb(rot4), normteDC(rot4));

% normcorrsunrotated(1) = corr(normteMC(unrot1), normteBC(unrot1));
% normcorrsunrotated(2) = corr(normteMCb(unrot2), normteMC2(unrot2));
% normcorrsunrotated(3) = corr(normteMCc(unrot3), normteDC(unrot3));
% normcorrsunrotated(4) = corr(normteBCb(unrot4), normteDC(unrot4));

clf
subplot(2,2,1)
plot(normteMC, normteBC, '.')
xlabel('MC')
ylabel('BC')
title(['Corr: ' num2str(normcorrs(1))])
subplot(2,2,2)
plot(normteMCb, normteMC2, '.')
xlabel('MC1')
ylabel('MC2')
title(['Corr: ' num2str(normcorrs(2))])
subplot(2,2,3)
plot(normteMCc, normteDC, '.')
xlabel('MC')
ylabel('DC')
title(['Corr: ' num2str(normcorrs(3))])
subplot(2,2,4)
plot(normteBCb, normteDC, '.')
xlabel('BC')
ylabel('DC')
title(['Corr: ' num2str(normcorrs(4))])
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/normtecondcompare.eps')


%For individual recordings
mcrec = fetch(exec(conn, ['SELECT et.`manualrecording`, et.`1DBCrecording` FROM experiment_tuning et']));
mcrec = mcrec.Data;
nR = size(mcrec,1);

corrsMCBC = [];
corrsMCMC2 = [];
corrsMCDC = [];
corrsBCDC = [];
tuningtype = [];
performanceBC = [];
performanceDC = [];
performanceBCDC = [];

for idx = 1:nR
	mcfile = mcrec{idx,1};
	bcfile = mcrec{idx,2};
	teMCBC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
	' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, et.`tuning_type`, rec.successrate FROM `experiment_tuning` et '...
	'INNER JOIN `fits` fMC '...
	'ON et.`manualrecording` = fMC.`nev file` '...
	'INNER JOIN `estimates_te` egMC '...
	'ON egMC.`id` = fMC.`id` '...
	'INNER JOIN `fits` fBC '...
	'ON et.`1DBCrecording` = fBC.`nev file` '...
	'INNER JOIN `estimates_te` egBC '...
	'ON egBC.`id` = fBC.`id` '...
	'INNER JOIN `recordings` rec '...
	'ON rec.`nev file` = et.`1DBCrecording` '...
	'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id AND fMC.`nev file` = "' mcfile '"']));
	if length(teMCBC.Data) > 1
		teMC = cell2mat(teMCBC.Data(:,5));
		teBC = cell2mat(teMCBC.Data(:,6));
		corrsMCBC(idx) = corr(teMC, teBC);
		tuningtype(idx) = cell2mat(teMCBC.Data(1,7));
		performanceBC(idx) = cell2mat(teMCBC.Data(1,8));
	end
	teMCMC2 = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
	' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, et.`tuning_type`, rec.successrate FROM `experiment_tuning` et '...
	'INNER JOIN `fits` fMC '...
	'ON et.`manualrecording` = fMC.`nev file` '...
	'INNER JOIN `estimates_te` egMC '...
	'ON egMC.`id` = fMC.`id` '...
	'INNER JOIN `fits` fBC '...
	'ON et.`manualrecordingafter` = fBC.`nev file` '...
	'INNER JOIN `estimates_te` egBC '...
	'ON egBC.`id` = fBC.`id` '...
	'INNER JOIN `recordings` rec '...
	'ON rec.`nev file` = et.`1DBCrecording` '...
	'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id AND fMC.`nev file` = "' mcfile '"']));
	if length(teMCMC2.Data) > 1
		teMCb = cell2mat(teMCMC2.Data(:,5));
		teMC2 = cell2mat(teMCMC2.Data(:,6));
		corrsMCMC2(idx) = corr(teMCb, teMC2);
		tuningtype(idx) = cell2mat(teMCMC2.Data(1,7));
	end
	
	teMCDC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
	' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, et.`tuning_type`, rec.successrate FROM `experiment_tuning` et '...
	'INNER JOIN `fits` fMC '...
	'ON et.`manualrecording` = fMC.`nev file` '...
	'INNER JOIN `estimates_te` egMC '...
	'ON egMC.`id` = fMC.`id` '...
	'INNER JOIN `fits` fBC '...
	'ON et.`dualrecording` = fBC.`nev file` '...
	'INNER JOIN `estimates_te` egBC '...
	'ON egBC.`id` = fBC.`id` '...
	'INNER JOIN `recordings` rec '...
	'ON rec.`nev file` = et.`dualrecording` '...
	'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id AND fMC.`nev file` = "' mcfile '"']));
	if length(teMCDC.Data) > 1
		teMCc = cell2mat(teMCDC.Data(:,5));
		teDC = cell2mat(teMCDC.Data(:,6));
		corrsMCDC(idx) = corr(teMCc, teDC);
		tuningtype(idx) = cell2mat(teMCDC.Data(1,7));
		performanceDC(idx) = cell2mat(teMCDC.Data(1,8));
	end
	teBCDC = fetch(exec(conn, ['SELECT fBC.analyses_id, fMC.`nev file`, fMC.unit tounit, '...
	' egMC.fromunit, egMC.score egMCscore, egBC.score egBCscore, et.`tuning_type`, rec1.successrate, rec2.successrate FROM `experiment_tuning` et '...
	'INNER JOIN `fits` fMC '...
	'ON et.`1DBCrecording` = fMC.`nev file` '...
	'INNER JOIN `estimates_te` egMC '...
	'ON egMC.`id` = fMC.`id` '...
	'INNER JOIN `fits` fBC '...
	'ON et.`dualrecording` = fBC.`nev file` '...
	'INNER JOIN `estimates_te` egBC '...
	'ON egBC.`id` = fBC.`id` '...
	'INNER JOIN `recordings` rec1 '...
	'ON rec1.`nev file` = et.`1DBCrecording` '...
	'INNER JOIN `recordings` rec2 '...
	'ON rec2.`nev file` = et.`dualrecording` '...
	'WHERE fMC.unit = fBC.unit AND egMC.fromunit = egBC.fromunit AND fMC.modelID = 37 AND fBC.modelID = 37 AND fMC.analyses_id = fBC.analyses_id AND fMC.`nev file` = "' bcfile '"']));
	if length(teBCDC.Data) > 1
		teBCb = cell2mat(teBCDC.Data(:,5));
		teDC = cell2mat(teBCDC.Data(:,6));
		corrsBCDC(idx) = corr(teBCb, teDC);
		tuningtype(idx) = cell2mat(teBCDC.Data(1,7));
		performanceBCDC(idx,1:2) = cell2mat(teBCDC.Data(1,8:9));
	end
end

plot(corrsMCBC, performanceBC, '.')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/teMCBC_performance.eps')

plot(corrsMCDC, performanceDC, '.')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/teMCDC_performance.eps')

plot(corrsBCDC, performanceBCDC, '.')

plot(performanceBCDC(:,1), performanceBCDC(:,2))

rot = tuningtype < 5;
unrot = tuningtype == 5;

% subplot(3,4,1)
% hist(corrsMCBC(corrsMCBC~=0))
% xlabel('Corr MCBC')
% xlim([0 1])
% subplot(3,4,2)
% hist(corrsMCMC2(corrsMCMC2~=0))
% xlabel('Corr MCMC')
% xlim([0 1])
% subplot(3,4,3)
% hist(corrsMCDC(corrsMCDC~=0))
% xlabel('Corr MCDC')
% xlim([0 1])
% subplot(3,4,4)
% hist(corrsBCDC(corrsBCDC~=0))
% xlabel('Corr BCDC')
% xlim([0 1])
% 
% subplot(3,4,5)
% hist(corrsMCBC(corrsMCBC~=0 & unrot))
% xlabel('Unrotated Corr MCBC')
% xlim([0 1])
% subplot(3,4,6)
% hist(corrsMCMC2(corrsMCMC2~=0 & unrot))
% xlabel('Unrotated Corr MCMC')
% xlim([0 1])
% subplot(3,4,7)
% hist(corrsMCDC(corrsMCDC~=0 & unrot))
% xlabel('Unrotated Corr MCDC')
% xlim([0 1])
% subplot(3,4,8)
% hist(corrsBCDC(corrsBCDC~=0 & unrot))
% xlabel('Unrotated Corr BCDC')
% xlim([0 1])
% 
% subplot(3,4,9)
% hist(corrsMCBC(corrsMCBC~=0 & rot))
% xlabel('Rotated Corr MCBC')
% xlim([0 1])
% subplot(3,4,10)
% hist(corrsMCMC2(corrsMCMC2~=0 & rot))
% xlabel('Rotated Corr MCMC')
% xlim([0 1])
% subplot(3,4,11)
% hist(corrsMCDC(corrsMCDC~=0 & rot))
% xlabel('Rotated Corr MCDC')
% xlim([0 1])
% subplot(3,4,12)
% hist(corrsBCDC(corrsBCDC~=0 & rot))
% xlabel('Rotated Corr BCDC')
% xlim([0 1])
% saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tecondcompare_perfile.eps', 'eps', [10 10])