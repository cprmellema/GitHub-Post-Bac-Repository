conn = database('','root','Fairbanks1!','com.mysql.jdbc.Driver', ...
	'jdbc:mysql://fairbanks.amath.washington.edu:3306/spanky_db');

size_thresh = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gather data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MC_data = fetch(exec(conn, ['SELECT ge.score, fl1.dir, fl2.dir, MOD(fl1.dir- fl2.dir, 2*PI()), flin1.`nev file`, ge.`fromunit`, flin1.`unit` FROM `fits` fte '...
'INNER JOIN `fits` flin1 '...
'ON flin1.`nev file` = fte.`nev file` AND flin1.`unit` = fte.`unit` '...
'INNER JOIN `estimates_te` ge '...
'ON fte.id = ge.id '...
'INNER JOIN `fits` flin2 '...
'ON flin2.`nev file` = fte.`nev file` AND flin2.`unit` = ge.`fromunit` '...
'INNER JOIN `fits_linear` fl1 '...
'ON flin1.id = fl1.id '...
'INNER JOIN `fits_linear` fl2 '...
'ON flin2.id = fl2.id '...
'INNER JOIN `experiment_tuning` et '...
'ON et.`manualrecording` = flin1.`nev file` '...
'WHERE flin1.modelID = 1 AND flin2.modelID = 1 AND fte.modelID = 2 AND fl1.size > ' num2str(size_thresh) ' AND fl2.size > ' num2str(size_thresh)]));
MC_d = cell2mat(MC_data.Data(:,1:4));

BC_data = fetch(exec(conn, ['SELECT ge.score, fl1.dir, fl2.dir, MOD(fl1.dir- fl2.dir, 2*PI()), flin1.`nev file`, ge.`fromunit`, flin1.`unit` FROM `fits` fte '...
'INNER JOIN `fits` flin1 '...
'ON flin1.`nev file` = fte.`nev file` AND flin1.`unit` = fte.`unit` '...
'INNER JOIN `estimates_te` ge '...
'ON fte.id = ge.id '...
'INNER JOIN `fits` flin2 '...
'ON flin2.`nev file` = fte.`nev file` AND flin2.`unit` = ge.`fromunit` '...
'INNER JOIN `fits_linear` fl1 '...
'ON flin1.id = fl1.id '...
'INNER JOIN `fits_linear` fl2 '...
'ON flin2.id = fl2.id '...
'INNER JOIN `experiment_tuning` et '...
'ON et.`1DBCrecording` = flin1.`nev file` '...
'WHERE flin1.modelID = 1 AND flin2.modelID = 1 AND fte.modelID = 2 AND fl1.size > ' num2str(size_thresh) ' AND fl2.size > ' num2str(size_thresh)]));
BC_d = cell2mat(BC_data.Data(:,1:4));

[MC_angle_scores, MC_angle_stdscores, MC_angle_propabove, MC_overlap_scores, MC_overlap_stdscores, MC_overlap_propabove, MC_proptuned, MC_proptuned_sem, MC_overlap_gcthresh, MC_stdoverlap_gcthresh, MC_nabove, MC_propbothru, MC_propbothfe, MC_propneitherferu] = binoverlap(MC_d);
[MC_CC_angle_scores, MC_CC_angle_stdscores, MC_CC_angle_propabove, MC_CC_overlap_scores, MC_CC_overlap_stdscores, MC_CC_overlap_propabove, MC_CC_proptuned, MC_CC_proptuned_sem, MC_CC_overlap_gcthresh, MC_CC_stdoverlap_gcthresh, MC_CC_nabove, MC_CC_propbothru, MC_CC_propbothfe, MC_CC_propneitherferu] = binoverlap(MC_CC_d);
[MC_CI_angle_scores, MC_CI_angle_stdscores, MC_CI_angle_propabove, MC_CI_overlap_scores, MC_CI_overlap_stdscores, MC_CI_overlap_propabove, MC_CI_proptuned, MC_CI_proptuned_sem, MC_CI_overlap_gcthresh, MC_CI_stdoverlap_gcthresh, MC_CI_nabove, MC_CI_propbothru, MC_CI_propbothfe, MC_CI_propneitherferu] = binoverlap(MC_CI_d);
[MC_IC_angle_scores, MC_IC_angle_stdscores, MC_IC_angle_propabove, MC_IC_overlap_scores, MC_IC_overlap_stdscores, MC_IC_overlap_propabove, MC_IC_proptuned, MC_IC_proptuned_sem, MC_IC_overlap_gcthresh, MC_IC_stdoverlap_gcthresh, MC_IC_nabove, MC_IC_propbothru, MC_IC_propbothfe, MC_IC_propneitherferu] = binoverlap(MC_IC_d);
[MC_II_angle_scores, MC_II_angle_stdscores, MC_II_angle_propabove, MC_II_overlap_scores, MC_II_overlap_stdscores, MC_II_overlap_propabove, MC_II_proptuned, MC_II_proptuned_sem, MC_II_overlap_gcthresh, MC_II_stdoverlap_gcthresh, MC_II_nabove, MC_II_propbothru, MC_II_propbothfe, MC_II_propneitherferu] = binoverlap(MC_II_d);
[BC_angle_scores, BC_angle_stdscores, BC_angle_propabove, BC_overlap_scores, BC_overlap_stdscores, BC_overlap_propabove, BC_proptuned, BC_proptuned_sem, BC_overlap_gcthresh, BC_stdoverlap_gcthresh, BC_nabove, BC_propbothru, BC_propbothfe, BC_propneitherferu] = binoverlap(BC_d);
[BC_CC_angle_scores, BC_CC_angle_stdscores, BC_CC_angle_propabove, BC_CC_overlap_scores, BC_CC_overlap_stdscores, BC_CC_overlap_propabove, BC_CC_proptuned, BC_CC_proptuned_sem, BC_CC_overlap_gcthresh, BC_CC_stdoverlap_gcthresh, BC_CC_nabove, BC_CC_propbothru, BC_CC_propbothfe, BC_CC_propneitherferu] = binoverlap(BC_CC_d);
[BC_CI_angle_scores, BC_CI_angle_stdscores, BC_CI_angle_propabove, BC_CI_overlap_scores, BC_CI_overlap_stdscores, BC_CI_overlap_propabove, BC_CI_proptuned, BC_CI_proptuned_sem, BC_CI_overlap_gcthresh, BC_CI_stdoverlap_gcthresh, BC_CI_nabove, BC_CI_propbothru, BC_CI_propbothfe, BC_CI_propneitherferu] = binoverlap(BC_CI_d);
[BC_IC_angle_scores, BC_IC_angle_stdscores, BC_IC_angle_propabove, BC_IC_overlap_scores, BC_IC_overlap_stdscores, BC_IC_overlap_propabove, BC_IC_proptuned, BC_IC_proptuned_sem, BC_IC_overlap_gcthresh, BC_IC_stdoverlap_gcthresh, BC_IC_nabove, BC_IC_propbothru, BC_IC_propbothfe, BC_IC_propneitherferu] = binoverlap(BC_IC_d);
[BC_II_angle_scores, BC_II_angle_stdscores, BC_II_angle_propabove, BC_II_overlap_scores, BC_II_overlap_stdscores, BC_II_overlap_propabove, BC_II_proptuned, BC_II_proptuned_sem, BC_II_overlap_gcthresh, BC_II_stdoverlap_gcthresh, BC_II_nabove, BC_II_propbothru, BC_II_propbothfe, BC_II_propneitherferu] = binoverlap(BC_II_d);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tuning vs average te score%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nK_sp = 6;
sigthresh = 22.35; %Because: 1-chi2cdf(22.35, nK_sp) = 0.001;
nbins = 100;

angles = linspace(-pi, pi, nbins)/pi*180;
f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.01;
sp = csaps(angles, MC_angle_scores, p);
smooth_mc = fnval(sp, angles);
sp = csaps(angles, BC_angle_scores, p);
smooth_bc = fnval(sp, angles);
hold on
h1=plot(angles, MC_angle_scores, '.', 'Color', [.7 0.3 0.3])
h2=plot(angles, smooth_mc, 'Color', [1 0 0])
h3=plot(angles, BC_angle_scores, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_bc, 'Color', [0 0 1])
plot([-180, 180], [sigthresh, sigthresh], ':k')
xlabel('$\theta_j-\theta_i$')
ylabel('$\mathcal{G}_{y^j \to y^i}$')
xlim([-180 180])
ylim([0 30])
legend([h1, h3], 'manual control', 'brain control')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tevtuning_MC_BC_data_thresh_tuningsize_0_2.jpg')

angles = linspace(-pi, pi, nbins)/pi*180;
f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.005;
sp = csaps(angles, MC_CC_angle_scores, p);
smooth_mc_cc = fnval(sp, angles);
sp = csaps(angles, MC_CI_angle_scores, p);
smooth_mc_ci = fnval(sp, angles);
sp = csaps(angles, MC_IC_angle_scores, p);
smooth_mc_ic = fnval(sp, angles);
hold on
h1=plot(angles, MC_CC_angle_scores, '.', 'Color', [.7 .3 .3])
h2=plot(angles, smooth_mc_cc, 'Color', [1 0 0])
h3=plot(angles, MC_CI_angle_scores, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_mc_ci, 'Color', [0 0 .8])
%h5=plot(angles, MC_IC_angle_scores, '.', 'Color', [0.3 0.5 0.3])
%h6=plot(angles, smooth_mc_ic, 'Color', [0 1 0])
plot([-180, 180], [sigthresh, sigthresh], ':k')
xlabel('$\theta_j-\theta_i$')
ylabel('$\mathcal{G}_{y^j \to y^i}$')
xlim([-180 180])
ylim([0 30])
legend([h1, h3], 'contra-contra', 'contra-ipsi')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tevtuning_MC_hemispheres_data_thresh_tuningsize_0_2.jpg')

angles = linspace(-pi, pi, nbins)/pi*180;
f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.005;
sp = csaps(angles, BC_CC_angle_scores, p);
smooth_bc_cc = fnval(sp, angles);
sp = csaps(angles, BC_CI_angle_scores, p);
smooth_bc_ci = fnval(sp, angles);
sp = csaps(angles, BC_IC_angle_scores, p);
smooth_bc_ic = fnval(sp, angles);
hold on
h1=plot(angles, BC_CC_angle_scores, '.', 'Color', [.7 .3 .3])
h2=plot(angles, smooth_bc_cc, 'Color', [1 0 0])
h3=plot(angles, BC_CI_angle_scores, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_bc_ci, 'Color', [0 0 .8])
%h5=plot(angles, BC_IC_angle_scores, '.', 'Color', [0.3 0.5 0.3])
%h6=plot(angles, smooth_bc_ic, 'Color', [0 1 0])
plot([-180, 180], [sigthresh, sigthresh], ':k')
xlabel('$\theta_j-\theta_i$')
ylabel('$\mathcal{G}_{y^j \to y^i}$')
xlim([-180 180])
ylim([0 30])
legend([h1, h3], 'contra-contra', 'contra-ipsi')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tevtuning_BC_hemispheres_data_thresh_tuningsize_0_2.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tuning vs prop significant%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.005;
sp = csaps(angles, MC_angle_propabove, p);
smooth_mc = fnval(sp, angles);
sp = csaps(angles, BC_angle_propabove, p);
smooth_bc = fnval(sp, angles);
hold on
h1=plot(angles, MC_angle_propabove, '.', 'Color', [.7 .3 .3])
h2=plot(angles, smooth_mc, 'Color', [1 0 0])
h3=plot(angles, BC_angle_propabove, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_bc, 'Color', [0 0 .8])
ylabel('Proportion of significant connections. $\alpha$ = 0.001')
ylim([0 .2])
xlim([-180 180])
xlabel('$\theta_j-\theta_i$')
legend([h1, h3], 'manual control', 'brain control')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tuningvpropsig_MC_BC_data_thresh_tuningsize_0_2.jpg')

f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.005;
sp = csaps(angles, MC_CC_angle_propabove, p);
smooth_mc_cc = fnval(sp, angles);
sp = csaps(angles, MC_CI_angle_propabove, p);
smooth_mc_ci = fnval(sp, angles);
hold on
h1=plot(angles, MC_CC_angle_propabove, '.', 'Color', [.7 .3 .3])
h2=plot(angles, smooth_mc_cc, 'Color', [1 0 0])
h3=plot(angles, MC_CI_angle_propabove, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_mc_ci, 'Color', [0 0 .8])
ylabel('Proportion of significant connections. $\alpha$ = 0.001')
ylim([0 .2])
xlim([-180 180])
xlabel('$\theta_j-\theta_i$')
legend([h1, h3], 'contra->contra', 'contra->ipsi')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tuningvpropsig_MC_hemispheres_data_thresh_tuningsize_0_2.jpg')

f=figure 
set(f,'defaulttextinterpreter','latex');
p = 0.005;
sp = csaps(angles, BC_CC_angle_propabove, p);
smooth_bc_cc = fnval(sp, angles);
sp = csaps(angles, BC_CI_angle_propabove, p);
smooth_bc_ci = fnval(sp, angles);
hold on
h1=plot(angles, BC_CC_angle_propabove, '.', 'Color', [.7 .3 .3])
h2=plot(angles, smooth_bc_cc, 'Color', [1 0 0])
h3=plot(angles, BC_CI_angle_propabove, '.', 'Color', [0.3 0.3 0.7])
h4=plot(angles, smooth_bc_ci, 'Color', [0 0 .8])
ylabel('Proportion of significant connections. $\alpha$ = 0.001')
ylim([0 .2])
xlim([-180 180])
xlabel('$\theta_j-\theta_i$')
legend([h1, h3], 'contra->contra', 'contra->ipsi')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tuningvpropsig_BC_hemispheres_data_thresh_tuningsize_0_2.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%te score vs proportion sim. tuned%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%colormap(nabovecmap);
%MC_proptuned, MC_proptuned_sem, MC_overlap_tethresh, MC_stdoverlap_tethresh
figure
tethresholds = 0.1:5:200;
anglethreshs = [10]/180*pi;
ii = 1:find(MC_nabove(:)<30, 1);
hold on
h1 = plot(tethresholds(ii), MC_proptuned(ii), 'LineWidth', 2)
h2 = plot(tethresholds(ii), BC_proptuned(ii), 'r', 'LineWidth', 2)
h3 = plot(tethresholds(ii), MC_proptuned(ii)+MC_proptuned_sem(ii)', '--', tethresholds(ii), MC_proptuned(ii)-MC_proptuned_sem(ii)', '--', 'Color', [.5 .5 .9])
h4 = plot(tethresholds(ii), BC_proptuned(ii)+BC_proptuned_sem(ii)', '--', tethresholds(ii), BC_proptuned(ii)-BC_proptuned_sem(ii)', '--', 'Color', [.9 .5 .5])
plot(tethresholds(ii), ones(size(tethresholds(ii)))*(10/180), ':k')
%colorbar('south')
xlabel('te score')
ylabel('Proportion tuned within +/- 10 degrees')
legend('manual control', 'brain control', 'location', 'northwest')
ylim([0 .4])
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tescorevproptuned_MC_BC_thresh_tuningsize_0_2.jpg')


figure
tethresholds = 0.1:5:200;
anglethreshs = [10]/180*pi;
ii = 1:find(MC_CC_nabove(:)<30, 1);
hold on
h1 = plot(tethresholds(ii), MC_CC_proptuned(ii), 'LineWidth', 2, 'Color', [.2 .2 .9])
h2 = plot(tethresholds(ii), MC_CI_proptuned(ii), 'LineWidth', 2, 'Color', [.9 .2 .2])
h3 = plot(tethresholds(ii), MC_IC_proptuned(ii), 'LineWidth', 2, 'Color', [.2 .9 .2])
h4 = plot(tethresholds(ii), MC_CC_proptuned(ii)+MC_CC_proptuned_sem(ii)', '--', tethresholds(ii), MC_CC_proptuned(ii)-MC_CC_proptuned_sem(ii)', '--', 'Color', [.5 .5 .9])
h5 = plot(tethresholds(ii), MC_CI_proptuned(ii)+MC_CI_proptuned_sem(ii)', '--', tethresholds(ii), MC_CI_proptuned(ii)-MC_CI_proptuned_sem(ii)', '--', 'Color', [.9 .5 .5])
h6 = plot(tethresholds(ii), MC_IC_proptuned(ii)+MC_IC_proptuned_sem(ii)', '--', tethresholds(ii), MC_IC_proptuned(ii)-MC_IC_proptuned_sem(ii)', '--', 'Color', [.5 .9 .5])
plot(tethresholds(ii), ones(size(tethresholds(ii)))*(10/180), ':k')
%colorbar('south')
xlabel('te score')
ylabel('Proportion tuned within +/- 10 degrees')
legend('contra->contra', 'contra->ipsi', 'ipsi->contra', 'location', 'northeast')
ylim([0 .4])
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tescorevproptuned_MC_hemispheres_thresh_tuningsize_0_2.jpg')


figure
tethresholds = 0.1:5:200;
anglethreshs = [10]/180*pi;
ii = 1:find(BC_CC_nabove(:)<30, 1);
hold on
h1 = plot(tethresholds(ii), BC_CC_proptuned(ii), 'LineWidth', 2, 'Color', [.2 .2 .9])
h2 = plot(tethresholds(ii), BC_CI_proptuned(ii), 'LineWidth', 2, 'Color', [.9 .2 .2])
h3 = plot(tethresholds(ii), BC_IC_proptuned(ii), 'LineWidth', 2, 'Color', [.2 .9 .2])
h4 = plot(tethresholds(ii), BC_CC_proptuned(ii)+BC_CC_proptuned_sem(ii)', '--', tethresholds(ii), BC_CC_proptuned(ii)-BC_CC_proptuned_sem(ii)', '--', 'Color', [.5 .5 .9])
h5 = plot(tethresholds(ii), BC_CI_proptuned(ii)+BC_CI_proptuned_sem(ii)', '--', tethresholds(ii), BC_CI_proptuned(ii)-BC_CI_proptuned_sem(ii)', '--', 'Color', [.9 .5 .5])
h6 = plot(tethresholds(ii), BC_IC_proptuned(ii)+BC_IC_proptuned_sem(ii)', '--', tethresholds(ii), BC_IC_proptuned(ii)-BC_IC_proptuned_sem(ii)', '--', 'Color', [.5 .9 .5])
plot(tethresholds(ii), ones(size(tethresholds(ii)))*(10/180), ':k')
%colorbar('south')
xlabel('te score')
ylabel('Proportion tuned within +/- 10 degrees')
legend('contra->contra', 'contra->ipsi', 'ipsi->contra', 'location', 'northeast')
ylim([0 .4])
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tescorevproptuned_BC_hemispheres_thresh_tuningsize_0_2.jpg')


figure
ii = 1:find(MC_nabove(:)<400, 1);
plot(tethresholds(ii), MC_overlap_tethresh(ii), tethresholds(ii), MC_overlap_tethresh(ii)-MC_stdoverlap_tethresh(ii), 'r--', tethresholds(ii), MC_overlap_tethresh(ii)+MC_stdoverlap_tethresh(ii), 'r--')
xlabel('te score')
ylabel('Overlap between tuning angles')
title('Manual control. Ipsi+contra')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tescorevtuningoverlap_MC_thresh_tuningsize_0_2.jpg')

figure
ii = 1:find(BC_nabove(:)<400, 1);
plot(tethresholds(ii), BC_overlap_tethresh(ii), tethresholds(ii), BC_overlap_tethresh(ii)-BC_stdoverlap_tethresh(ii), 'r--', tethresholds(ii), BC_overlap_tethresh(ii)+BC_stdoverlap_tethresh(ii), 'r--')
xlabel('te score')
ylabel('Overlap between tuning angles')
title('Brain control. Ipsi+contra')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/tescorevtuningoverlap_BC_thresh_tuningsize_0_2.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tuning histograms%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Note the non-uniform distribution of preferred angles (even with the linear model)
hist(all_d(:,2)/pi*180, 50) 
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_all_thresh_tuningsize_0_2.jpg')
hist(MC_d(:,2)/pi*180, 50) 
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_MC_thresh_tuningsize_0_2.jpg')
hist(BC_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_BC_thresh_tuningsize_0_2.jpg')
hist(MC_CC_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_MC_CC_thresh_tuningsize_0_2.jpg')
hist(MC_CI_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_MC_CI_thresh_tuningsize_0_2.jpg')
hist(MC_IC_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_MC_IC_thresh_tuningsize_0_2.jpg')
hist(MC_II_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_MC_II_thresh_tuningsize_0_2.jpg')
hist(BC_IC_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_BC_IC_thresh_tuningsize_0_2.jpg')
hist(BC_II_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_BC_II_thresh_tuningsize_0_2.jpg')
hist(BC_CI_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_BC_CI_thresh_tuningsize_0_2.jpg')
hist(BC_CC_d(:,2)/pi*180, 50)
xlabel('angle')
ylabel('frequency')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/hist_tuning_BC_CC_thresh_tuningsize_0_2.jpg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Prop in each quadrant%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ii = 1:find(MC_nabove(:)<30, 1);
f=figure
set(f,'defaulttextinterpreter','latex');
hold on
h1=area(tethresholds(ii), ones(size(tethresholds(ii))));
h2=area(tethresholds(ii), MC_propbothru(ii)+MC_propbothfe(ii), 'FaceColor', [1 0 0])
h3=area(tethresholds(ii), MC_propbothfe(ii), 'FaceColor', [0 .8 0])
xlabel('$\mathcal{G}$ threshold')
xlim([0 tethresholds(ii(end))]);
legend('other', 'both tuned RU', 'both tuned FE', 'location', 'northwest')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/prop_fe_ru_MC_thresh_tuningsize_0_2.jpg')

ii = 1:find(BC_nabove(:)<30, 1);
f=figure
set(f,'defaulttextinterpreter','latex');
hold on
h1=area(tethresholds(ii), ones(size(tethresholds(ii))));
h2=area(tethresholds(ii), BC_propbothru(ii)+BC_propbothfe(ii), 'FaceColor', [1 0 0])
h3=area(tethresholds(ii), BC_propbothfe(ii), 'FaceColor', [0 .8 0])
xlabel('$\mathcal{G}$ threshold')
xlim([0 tethresholds(ii(end))]);
legend('other', 'both tuned RU', 'both tuned FE', 'location', 'northwest')
saveplot(gcf, './worksheets/2015_11_03-bcireportplots/prop_fe_ru_BC_thresh_tuningsize_0_2.jpg')