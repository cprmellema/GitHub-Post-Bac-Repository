 	pre = load('test_preprocess_spline_short24.mat');
 	%Make 3x3 network for testing
 	p = pre.processed; p.binnedspikes = p.binnedspikes(:,1:3); p.unitnames = p.unitnames(1:3);
 	const = 'on';
 	nK_sp = 75; 
 	nK_pos = 6;
 	dt_sp = p.binsize;
 	dt_pos = 1/50;
 	data = filters_sp_pos_network(p, nK_sp, nK_pos, dt_sp, dt_pos);
 	model = MLE_glmfit_network(data, const);
 	trains = glmsim_network(p, model, data);