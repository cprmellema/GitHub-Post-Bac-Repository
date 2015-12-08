function [x_p_IN x_IN y_IN spikes_IN I_n_PYIN d_n_PYIN I_hp_IN]= IN_rulkov(n_PY, n_IN, M_PYIN, x_pp_IN, x_p_IN, y_IN, spikes_PY, I_hp_IN, I_n_PYIN, d_n_PYIN)

%% constants
alpha=3.8*ones(n_IN^2,1);
sigma=-0.0175*ones(n_IN^2,1);
B_e=.1;
B_hp=.5;
gamma_PYIN=.6;
gamma_hp=.6;
g_syn_PYIN=.1;
g_hp=.5;
mu=.002;
sigma_e=1.0;
x_rp_ampa=0;
eta_ampa=.5;
rho_ampa=.01;

%%

%% before the spike, calculate B_n and sigma_n for use in the main section
B_n_PYIN=B_e*I_n_PYIN;

sum_B_n=sum(B_n_PYIN)';

sum_B_n(sum_B_n>1)=1;
sum_B_n(sum_B_n<-.0001)=-.0001;

u=y_IN+sum_B_n;

sigma_n_PYIN=sigma_e*I_n_PYIN;
sum_sigma_n=sum(sigma_n_PYIN)';

%% main section update x and y
x_1=x_p_IN<=0;
x_2= (x_p_IN>0&x_p_IN<alpha+u)&(x_pp_IN<=0);
x_3= (x_p_IN>=alpha+u);
y_IN=y_IN-mu*(x_p_IN+1)+mu*sigma+mu*sum_sigma_n;
x_IN=x_1.*(alpha./(1-x_p_IN)+u) + x_2.*(alpha+u) + x_3*(-1);

%% calculate the spikes generated and the current due to the spike
spikes_IN=(x_IN>=(alpha+u));
spikes_sq_PYIN=spikes_PY(:,ones(1,n_IN^2));
x_sq_IN=x_IN(:,ones(1,n_PY^2))';

I_n_PYIN=gamma_PYIN*I_n_PYIN-M_PYIN.*spikes_sq_PYIN*g_syn_PYIN.*d_n_PYIN.*(x_sq_IN-x_rp_ampa);
d_n_PYIN=spikes_sq_PYIN.*(1-eta_ampa).*d_n_PYIN +~spikes_sq_PYIN.*(1-(1-rho_ampa)*(1-d_n_PYIN));
I_hp_IN=gamma_hp*I_hp_IN-spikes_IN*g_hp;