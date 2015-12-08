function [x_p_PY x_PY y_PY spikes_PY I_n_PYPY d_n_PYPY I_hp_PY I_n_INPY d_n_INPY]=PY_rulkov(n_PY, n_IN, M_PYPY, M_INPY, x_pp_PY, x_p_PY, y_PY, spikes_PY, spikes_IN, I_n_PYPY, d_n_PYPY, I_hp_PY, I_n_INPY, d_n_INPY)

%% constants
alpha=3.65*ones(n_PY^2,1);
sigma=0.06*ones(n_PY^2,1);
B_e=.133;
B_hp=.5;
gamma_PYPY=.6;
gamma_hp=.6;
g_syn_PYPY=.1;
g_hp=.5;
mu=.0005;
sigma_e=1.0;
x_rp_ampa=0;
eta_ampa=.5;
rho_ampa=.01;

gamma_INPY=.6;
g_syn_INPY=.2;
x_rp_gaba=-1.1;
eta_gaba=.5;
rho_gaba=.01;

%%

%% before the spike, calculate B_n and sigma_n for use in the main section
B_n_PYPY=B_e*I_n_PYPY;
B_n_INPY=B_e*I_n_INPY;

sum_B_n=sum(B_n_PYPY)' + sum(B_n_INPY)' +B_hp*I_hp_PY;

sum_B_n(sum_B_n>1)=1;
sum_B_n(sum_B_n<-.0001)=-.0001;

u=y_PY+sum_B_n;

sigma_n_PYPY=sigma_e*I_n_PYPY;
sigma_n_INPY=sigma_e*I_n_INPY;
sum_sigma_n=sum(sigma_n_PYPY)'+sum(sigma_n_INPY)';

%% main section update x and y
x_1=x_p_PY<=0;
x_2= (x_p_PY>0&x_p_PY<alpha+u)&(x_pp_PY<=0);
x_3= (x_p_PY>=alpha+u);
y_PY=y_PY-mu*(x_p_PY+1)+mu*sigma+mu*sum_sigma_n;
x_PY=x_1.*(alpha./(1-x_p_PY)+u) + x_2.*(alpha+u) + x_3*(-1);

%% calculate the spikes generated and the current due to the spike
spikes_PY=sparse((x_PY>=(alpha+u)));
spikes_sq_PY=spikes_PY(:,ones(1,n_PY^2)); 

x_sq_PY=spalloc(n_PY^2,n_PY^2,sum(sum(M_PYPY)));

% for counter=1:n_PY^2
%     x_sq_PY(counter,:)=x_PY'.*M_PYPY(counter,:);
%     counter
% end
x_sq_PY=x_PY(:,ones(1,n_PY^2))'; % needs to be sparse

I_n_PYPY=gamma_PYPY*I_n_PYPY-M_PYPY.*spikes_sq_PY*g_syn_PYPY.*d_n_PYPY.*(x_sq_PY-x_rp_ampa);
d_n_PYPY=spikes_sq_PY.*(1-eta_ampa).*d_n_PYPY +~spikes_sq_PY.*(1-(1-rho_ampa)*(1-d_n_PYPY));
I_hp_PY=gamma_hp*I_hp_PY-spikes_PY*g_hp;

spikes_sq_IN=spikes_IN(:,ones(1,n_PY^2));
x_sq_IN=x_PY(:,ones(1,n_IN^2))';
I_n_INPY= gamma_INPY*I_n_INPY-M_INPY.*spikes_sq_IN*g_syn_INPY.*d_n_INPY.*(x_sq_IN-x_rp_gaba); %the currents are calculated by the postsynaptic neuron using information from the presyaptic neuron
d_n_INPY= spikes_sq_IN.*(1-eta_gaba).*d_n_INPY +~spikes_sq_IN.*(1-(1-rho_gaba)*(1-d_n_INPY));
