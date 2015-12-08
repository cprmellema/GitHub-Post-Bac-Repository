function [] = main_rulkov_looper(savename,steps1, n_PY, n_IN, r_PY, r_IN)

% % example parameters
% n_PY=50; % 50 x 50 square of excitatory pyramidal neurons.  
% n_IN=25; % 25 x 25 square of inhibitory neurons
% r_PY=8;  % excitatory neurons are connected within a radius of 8
% r_IN=2;  % inhibitory neurons are connected within a radius of 2
% steps1=30; % number of miliseconds to simulate. 1 step = 1 ms

%% run the connection matrix generators ***Cooper: here is where you can change the connection matrices for your application***
M_PYPY=connection_matrix_sparse(n_PY, n_PY, r_PY, 0); % Connection matrix from PY neurons to PY neurons
M_PYIN=connection_matrix_sparse(n_PY, n_IN, r_PY, 1); % Matrix from PY neurons to Inhbitory neurons
M_INPY=connection_matrix_sparse(n_IN, n_PY, r_IN, 1); % Matrix from inhibitory neurons to inhibitory neurons
                                                      % inhbitory neurons do not connecto to inhibitory neurons                                                     
figure(1)
subplot(1,3,1)
spy(M_PYPY)
subplot(1,3,2)
spy(M_PYIN)
subplot(1,3,3)
spy(M_INPY)

drawnow
pause(1)

%% initial conditions
x_p_PY=-.94*ones(n_PY^2,1); % x_p is the fast variable for the PY neurons on the previous time step.  Initial conditions start at -.94.  This is like resting membrane potential
x_pp_PY=-.94*ones(n_PY^2,1); % x_pp is the fast variable for the PY neurons two time steps ago.
y_PY=-2.82144329896905*ones(n_PY^2,1); % y is the slow variable for the PY neurons

x_p_IN=-1.01750030625697*ones(n_IN^2,1); % fast variable for the inhibitory neurons, previous time step
x_pp_IN=-1.01750030625697*ones(n_IN^2,1);% two time steps ago
y_IN=-2.90101919903795*ones(n_IN^2,1);   % slow variable

spikes_PY=logical(zeros(n_PY^2,1)); % matrix of whether a PY neuron spike on the current time step
spikes_IN=logical(zeros(n_IN^2,1)); % matrix of whether an inhbitory neuron spiked on the ucrrent time step
I_n_PYPY=spalloc(n_PY^2, n_PY^2,sum(sum(M_PYPY))); % preallocate a sparse array of synaptic currents from PY to PY neurons
d_n_PYPY=double(M_PYPY); % preallocate this matrix (can't remember, but I think it is related to synapses). 
I_hp_PY=zeros(n_PY^2, 1); % hyperpolarization current following a spike for PY neurons
I_n_INPY=spalloc(n_IN^2, n_PY^2,sum(sum(M_INPY))); % preallocate a sparse array of synaptic currents
d_n_INPY=double(M_INPY); % preallocate this matrix (can't remember, but I think it is related to synapses).

I_n_PYIN=spalloc(n_PY^2, n_IN^2,sum(sum(M_PYIN))); % preallocate a sparse array of synaptic currents from PY to Inhibitory neurons
d_n_PYIN=double(M_PYIN);
I_hp_IN=zeros(n_IN^2, 1);

x_vec_PY=zeros(n_PY.^2,steps1); % preallocate an array that is PY_neuron_index fast variable by time steps
y_vec_PY=zeros(n_PY.^2,steps1); % preallocate an array that is PY_neuron_index slow by time steps

x_vec_IN=zeros(n_IN.^2,steps1); % preallocate an array that is IN_neuron_index fast variable by time steps
y_vec_IN=zeros(n_IN.^2,steps1); % preallocate an array that is IN_neuron_index slow by time steps

for t=1:steps1
    if mod(t,10)==0
        disp(t) % print to screen the current time step
    end
    
    if t==10 % after 10 ms, stimulate a set of PY neurons by raising their slow variable
        y_PY(floor(end/2)+3:floor(end/2)+15)=y_PY(floor(end/2)+3:floor(end/2)+15)+.04;
    end
    
    [x_p_PY x_PY y_PY spikes_PY I_n_PYPY d_n_PYPY I_hp_PY I_n_INPY d_n_INPY]= PY_rulkov(n_PY, n_IN, M_PYPY, M_INPY, x_pp_PY, x_p_PY, y_PY, spikes_PY, spikes_IN, I_n_PYPY, d_n_PYPY, I_hp_PY, I_n_INPY, d_n_INPY);
    
    [x_p_IN x_IN y_IN spikes_IN I_n_PYIN d_n_PYIN I_hp_IN]= IN_rulkov(n_PY, n_IN, M_PYIN, x_pp_IN, x_p_IN, y_IN, spikes_PY, I_hp_IN, I_n_PYIN, d_n_PYIN);
    
    x_vec_PY(:,t)=x_PY; % record the state of the PY neurons' fast varaible.
    y_vec_PY(:,t)=y_PY; % record the state of the PY neurons' slow varaible.
        
    x_vec_IN(:,t)=x_IN; % record the state of the IN neurons' fast varaible.
    y_vec_IN(:,t)=y_IN; % record the state of the IN neurons' slow varaible.
    
    x_pp_PY=x_p_PY; % the previous step x_value is now two time steps ago
    x_p_PY=x_PY;    % the current step x_value is one time steps ago
    
    x_pp_IN=x_p_IN; % the previous step x_value is now two time steps ago
    x_p_IN=x_IN;    % the current step x_value is one time steps ago
end

%% Save the results of the simulation
save([savename '.mat'], 'n_PY', 'n_IN', 'M_PYPY', 'M_PYIN', 'M_INPY', 'x_p_PY', 'x_p_IN', 'x_pp_PY', 'x_pp_IN', 'y_PY', 'y_IN', 'spikes_PY', 'spikes_IN', 'I_n_PYPY', 'I_n_PYIN', 'I_n_INPY', 'I_hp_PY', 'I_hp_IN', 'd_n_PYPY', 'd_n_PYIN', 'd_n_INPY')

%% make a movie
x_slides_PY=zeros(n_PY,n_PY,steps1);
y_slides_PY=zeros(n_PY,n_PY,steps1);
for t=1:(steps1)
    x_slides_PY(:,:,t)=reshape(x_vec_PY(:,t),n_PY,n_PY);
    y_slides_PY(:,:,t)=reshape(y_vec_PY(:,t),n_PY,n_PY);
end

beep
pause(4)

figure(2)
aviobj = avifile(['IC_run_' savename '.avi'],'compression','none');

for t=1:(steps1)
    imagesc(x_slides_PY(:,:,t),[-1 1])
    title(['T = ', num2str(t)])
    colormap(hot(32));
    frame = getframe;
    aviobj = addframe(aviobj,frame);
end

aviobj = close(aviobj);
close 2

