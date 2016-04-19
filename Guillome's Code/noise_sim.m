%Script to implement the 2 neuron groups model as in Gilson et al., Biol
%Cybernietics 2009 (IV)

%Here two pools of external neurons (of size M/2 each) fed in separate
%groups of neurons (each of size N/2).

%The input pools are uncorrelated across pools but may have correlations
%within pools

%STDP is implemented as an exponentially decaying rule based on pre-post
%ISI and rate-based terms as well.

%This script simulates networks and compares to analytics

%NEW IN V4: Carrying over spikes from previous batches so ISI dostributions
%are better resolved


%--------------

%PARAMETERS

%simulation parameters
p.filename='testage_sin_BCI_N100_1';
p.file_output='./output_V4/';
online_plot_flag=1;
p.stim_switch=1;
p.load_groups_switch=1; %THIS now controls an architecture load
p.load_path='./data.mat'; %must contain a structure "arch' with initial connectivity matrices J0,K0, J and K
p.T_total=90;%seconds ' length of total sim
p.T_batch_size=2;%seconds ' record things at every batch end
p.dt=0.5; %(ms) temporal rez
p.num_batch=p.T_total/p.T_batch_size;
p.num_batch_steps=p.T_batch_size*1000/p.dt;
p.ref_t=0; %refractory period (ms) (for spike generation.

%Stimulation switch
p.stim_del=10; %delay for stimulation (ms)
p.num_del_steps=p.stim_del/p.dt;
p.stim_size=10000; %Amount to rize rate of stimulated cells 
p.rec_neuron=1; %neuron to trigger stimulation
p.cols={'k','r','b'}; %colors for group-related plots

%both numbers below need to be divisible by 3 for groups and pools
p.N=120; %total number of neurons in net MUST BE DIVISIBLE BY 3

%Correlogram parameters (to ba sampled from spiking)
p.Plast_bin_center=-250:250; %resolution for building histograms of delta t's

%EXTERNAL RATE PARAMS
p.net_rate=15; %(Hz) background rates for groups of neurons in network

%EXTERNAL RATE FUNCTIONS (SINE)
% p.stim_type=0; %2=NOISE 1=BOUTS 0=SINE
% p.baseline=0; %(Hz)
% p.ext_freq=[2,2,2]; %envelope frequencies (Hz);
% p.ext_amplitude=[100,100,100]; %amplitude of envelope (Hz);
% p.ext_offset=[0,2*pi/3,4*pi/3];

%EXTERNAL RATE FUNCTIONS (BOUTS)
% p.stim_type=1; %1=BOUTS 0=SINE
% p.baseline1=0; %(Hz) baseline firing rate --> Now see p.net_rate
% p.peaks1=[0.05,100]; %(Hz) minimum and maximum height of peaks
% p.peak_dur1=[5,100]; %(ms) minimum and maximum of peak width
% p.bout_dur1=[900,4000]; %(ms) minimum and maximum duration of activation bouts (ie duration of consecutive peaks)
% p.bout_freq1=0.13; %bouts / second (poisson distributed)
% p.ramp_dur=400; %ms
% p.ramp_ends=[0.1,5];

%EXTERNAL RATE FUNCTIONS (SINE)
p.stim_type=2; %2=NOISE 1=BOUTS 0=SINE

%SYNAPSES
p.tau_syn=5; %(ms) decay-time of synapse 
p.net_del=1; % (ms) mean of network synaptic delay
p.net_del_sig=1; %(ms) spread of network delays
p.dendrite_del=5; %(ms)

%STDP PARAMS
p.eta=0;%5e-7; %learning rate time scale
p.w_in=0;%4;
p.w_out=0;%-0.5;
p.w_min=0;
p.w_max=0.02; %0.01
p.gamma=0.1;
% p.W=@STDPexp_del; %STDP rule
p.W=@(x,y)STDPJ(x,y,p.w_max,p.gamma);


%CONNECTIVITY MATRICES
p.net_connect_prob=.3; %prob of connection in network
p.net_w_init=0.005;%0.015;%0.01, 0.015;

%GENERATING VARIABLES-------------------------------
%generating connectivity matrices
p.J0=double(rand(p.N)<p.net_connect_prob);
for i=1:p.N; p.J0(i,i)=0; end; %removing autapses
p.n_net=sum(sum(p.J0));
J=p.net_w_init*p.J0;

%_-_-_-_-_-_-_-_-_
% %Artificial assemblies
if p.load_groups_switch==1
%     load(p.load_path);
%     p.J0=arch.J0;
%     J=arch.J;
    %to make artificial groups, uncomment below
    J(1:p.N/3,1:p.N/3)=p.J0(1:p.N/3,1:p.N/3)*0.0125;
    J(p.N/3+1:2*p.N/3,p.N/3+1:2*p.N/3)=p.J0(p.N/3+1:2*p.N/3,p.N/3+1:2*p.N/3)*0.0125;
    J(2*p.N/3+1:end,2*p.N/3+1:end)=p.J0(2*p.N/3+1:end,2*p.N/3+1:end)*0.0125;
end
J=J2;
%_-_-_-_-_-_-_-_-_

%generating delays
a=p.net_del-p.net_del_sig;
b=p.net_del+p.net_del_sig;
p.net_d=a + (b-a).*rand(p.N);
p.net_d=p.net_d.*p.J0;

%useful reference vector
ref_net=1:p.N;
p.group_ind={1:p.N/3,p.N/3+1:2*p.N/3,2*p.N/3+1:p.N};
p.back_buffer=p.Plast_bin_center(end); %time buffer for which to keep spikes from previous batches

%CONTAINERS
%Initialising containers -----------*
Jtraj=zeros(p.N,p.N,p.num_batch+1);
Jtraj(:,:,1)=J; %storing initial matrix
time=[0:p.num_batch]*p.T_batch_size; %time container
Rates=zeros(p.N,p.num_batch+1);
ISI_counts=zeros(3,3,length(p.Plast_bin_center),p.num_batch);
mean_ext_rates=zeros(3,p.num_batch);
RATES_array=zeros(3,p.num_batch_steps,p.num_batch);


%Synaptic spike queues and rolling containers
net_queu_len=round(max(max(p.net_d))/p.dt+5);
net_syn_queue=p.T_batch_size*1000*10* ones(p.N,p.N,net_queu_len);
net_syn_entry=zeros(p.N,p.N,1);
net_syn_exit=zeros(p.N,p.N,1);
s=zeros(p.N,1); %synapses
r=zeros(p.N,1); %rates

%% Generating rates all at once
%container for full-length rates
num_total_t_steps=p.T_total*1000/p.dt;
Xtime=p.dt:p.dt:p.T_total*1000;
Xrates=zeros(3,num_total_t_steps);

%FOR SINE
if p.stim_type==0    
    for t=1:length(Xtime)
        x=ones(3,1)*t*p.dt/1000;
        Xrates(:,t)=(sin(2*pi*p.ext_freq'.*x+p.ext_offset')-4/5)*5;
        Xrates(:,t)=Xrates(:,t).*p.ext_amplitude';
        Xrates(:,t)=max(p.baseline*ones(3,1),Xrates(:,t));
    end 
end

%for BOUTS
if p.stim_type==1 
    for g=1:3 %loop over groups
        bout_starts=[];
        dur=0;
        t_stamp=0;
        tic
        while t_stamp<=p.T_total*1000 

            %drawing start of next bout
            delay1=exprnd(1000/p.bout_freq1);
            if isempty(bout_starts)
                bout_starts=[delay1];
            else
                bout_starts=[bout_starts bout_starts(end)+delay1+dur];
            end


            %drawing duration of next bout
            dur= p.bout_dur1(1) + (p.bout_dur1(2)-p.bout_dur1(1)).*rand;
            Sindex=find(Xtime>=bout_starts(end),1); %starting index
            Findex=Sindex; %finishing index
            GSindex=Sindex;
            while Findex*p.dt<=bout_starts(end)+dur
                peak_dur= p.peak_dur1(1) + (p.peak_dur1(2)-p.peak_dur1(1)).*rand;
                peak_height= p.peaks1(1) + (p.peaks1(2)-p.peaks1(1)).*rand;
                Findex=find(Xtime>=Xtime(Sindex)+peak_dur,1);
                Xrates(g,Sindex:Findex)=peak_height;
                Sindex=Findex+1;
            end
            t_stamp=bout_starts(end)+dur;

            %Working in ramps
            %up ramp
            ramp_index=GSindex:GSindex+p.ramp_dur/p.dt;
            Xrates(g,ramp_index)=(ramp_index-GSindex)*(p.ramp_ends(end)-p.ramp_ends(1))/(p.ramp_dur/p.dt)+p.ramp_ends(1);
            %down ramp
            ramp_index=Findex-p.ramp_dur/p.dt:Findex;
            Xrates(g,ramp_index)=(ramp_index-Findex)*(p.ramp_ends(1)-p.ramp_ends(end))/(p.ramp_dur/p.dt)+p.ramp_ends(1);
        end
        toc
    end

    
%FOR NOISE
if p.stim_type==2
   t=length(Xtime);
   signal=5*ones(1,t); %background input
   sigma=0.5; %noise sd
   for g=1:3 %loop over groups
       noisy=5+5*mean(mean(p.ext_amplitude))*signal+sigma(randn(size(signal))); %noisy signal
       Xrates(:,g)= noisy;
   end
end

    Xrates=Xrates(:,1:num_total_t_steps);
    display('Done generating rates')
end

%test plot
if online_plot_flag==1
    figure;
    set(gca,'FontSize',15)
    hold all
    for g=1:3
        plot(Xtime/1000,Xrates(g,:))
    end
    hold all
    xlabel 'time (sec)'
    title 'External Rates'
    ylabel Hz
end

% rapackaging rates
for b=1:p.num_batch
    RATES_array(:,:,b)=Xrates(:,(b-1)*p.num_batch_steps+1:b*p.num_batch_steps);
    mean_ext_rates(:,b)=mean(Xrates,2);
end

%clearing rate-generation things
clear('Xrates','Xtime')
%% SIMULATION
if online_plot_flag==1
    figure('Position', [100, 100, 1049, 895]);
    subplot(3,2,1)
    set(gca,'FontSize',20)
    pcolor(squeeze(Jtraj(:,:,1)))
    xlabel 'presyn'
    ylabel 'postsyn'
    title 'Initial J'
    caxis([p.w_min,p.w_max])
    pause(0.5)
end

for batch=1:p.num_batch
    display(['Processing batch # ' num2str(batch) '/' num2str(p.num_batch)])
    tic

    %-_-_-_-____-----_____-_-_-_
    %Pulling external rates from RATES_array
    %Generating random rates for this batch
    RATES=squeeze(RATES_array(:,:,batch));
    %containers for  BCI stim
    next_stim=[];
    %--------------

         
    %INITIATING LOCAL CONTAINERS-------
    %Spike arrays for network
    if batch>1
        past_spikes=spikes-p.T_batch_size*1000; %shifting spikes
        past_spike_entry=spike_entry;
    end
    spikes=zeros(p.N,100);%array of spikes with dealys added 
    spike_entry=ones(1,p.N);
    if batch>1
        for n=1:p.N
            spik=past_spikes(n,1:past_spike_entry(n)-1);
            spik=spik(spik>-p.back_buffer);
            spikes(n,1:length(spik))=spik;
            spike_entry(n)=length(spik)+1;
        end
    end
    
     %Synaptic spike queues and rolling containers
     if batch==1
        net_syn_queue=p.T_batch_size*1000*10* ones(p.N,p.N,net_queu_len);
        net_syn_entry=zeros(p.N,p.N,1);
        net_syn_exit=zeros(p.N,p.N,1);
     else
         net_syn_queue=net_syn_queue-p.T_batch_size*1000;
     end
    %----------------------------------
    
    %TEMPORARY___________________________
    r_temp=zeros(p.N,p.num_batch_steps);
    s_temp=zeros(p.N,p.num_batch_steps);
    %______________________________________
    
    %--------------
    %NET SIMULATION
    disp=0;
    for t=1:p.num_batch_steps
        t_now=t*p.dt;
        
        %progress display
        if 100*(t_now/1000/p.T_batch_size)-disp>10;
            disp=disp+10;
            display(['Processing batch # ' num2str(batch) '/' num2str(p.num_batch) '-->' num2str(disp) '% complete'])
        end
        
        %looping over net neurons and updating their weights according to
        %arriving spikes
        for n=1:p.N %loop over post-cells in net
            post_g=floor(3*(n-1)/p.N)+1; %group assignment
            %bianry spiking vectors
            net_spk_vect=zeros(p.N,1);
            
            %NET-------------
            pre_ind=ref_net(logical(p.J0(n,:))); %finding presyn neurons
            latest_spk=net_syn_queue(sub2ind(... %extracting latest spikes of pre cells
                size(net_syn_queue),...
                n*ones(size(pre_ind)),...
                pre_ind,...
                mod(net_syn_exit(n,pre_ind),net_queu_len)+1));
            spk_now_ind=pre_ind(latest_spk<=t_now); %index of pre cells that are spiking now
            if ~isempty(spk_now_ind)
                net_syn_queue(sub2ind(... %extracting latest spikes of pre cells
                size(net_syn_queue),...
                n*ones(size(spk_now_ind)),...
                spk_now_ind,...
                mod(net_syn_exit(n,spk_now_ind),net_queu_len)+1))...
                =p.T_batch_size*1000*10; %resetting old spikes
                net_spk_vect(spk_now_ind)=1; %storing spiking cells
                net_syn_exit(n,spk_now_ind)=net_syn_exit(n,spk_now_ind)+1;
            end
            %----------------
            
            %UPDATING SYNAPTIC VARIABLES
            s(n)=s(n)+J(n,:)*net_spk_vect/p.tau_syn;
            
            %$$$$$$$$$$$$$$$$$$$$$$$
            %PLASTICITY RATE-BASED
            %$$$$$$$$$$$$$$$$$$$$$$$
            %UPDATING J MATRIX with incoming spike rule
            if p.w_in~=0
                J(n,spk_now_ind)=J(n,spk_now_ind)+p.eta*p.w_in;
            end
            %$$$$$$$$$$$$$$$$$$$$$$$
             %$$$$$$$$$$$$$$$$$$$$$$$
             %$$$$$$$$$$$$$$$$$$$$$$$
             %$$$$$$$$$$$$$$$$$$$$$$$
             %STDP NOW !!!!!!!
            if spike_entry(n)>1 %check if current post-synaptic cell spiked at all in the past (otherwise there is no spike pair)
                %Post-synaptic spike train (all of it, adding dendritic delays)
                post_spk=spikes(n,1:spike_entry(n)-1)+p.dendrite_del; 
                %$$$$$$$$$$$$$$$$$
                %DEPRESSION
                %STDP rule: running over PRESYN spikes from network
                for pre=spk_now_ind
                    pre_g=floor(3*(pre-1)/p.N)+1; %group assignment for current presynaptic cell
                    delta_t=t_now+p.dt/2-post_spk;
                    delta_t=delta_t(delta_t>0);
                    J(n,pre)=max(J(n,pre)+p.eta*sum(p.W(delta_t,J(n,pre))),p.w_min);
                    h=hist(delta_t,p.Plast_bin_center)';
                        h(1)=0;
                        h(end)=0;
                    ISI_counts(post_g,pre_g,:,batch)=squeeze(ISI_counts(post_g,pre_g,:,batch))+h;
                end
                %$$$$$$$$$$$$$$$$$
                
                %$$$$$$$$$$$$$$$$$
                %POTENTIATION
                %Checking if cell n (post) is spiking NOW after dendritic
                %delay
                spike_flag=0;
                postime=-1000;
                tik=length(post_spk);
                while tik>0 && post_spk(tik)>t_now-p.dt
                    if post_spk(tik)<=t_now && post_spk(tik)>t_now-p.dt
                        spike_flag=1;
                        postime=post_spk(tik);
                        break
                    end
                    tik=tik-1;
                end
                %Actual potentiation
                if spike_flag==1
                    for pre=pre_ind
                        pre_g=floor(3*(pre-1)/p.N)+1; %group assignment
                        del=p.net_d(n,pre);
                        pre_spk=spikes(pre,1:spike_entry(pre)-1)+del;
                        delta_t=pre_spk-postime; %creating delta t vector
                        delta_t=delta_t(delta_t<=0);
                        J(n,pre)=max(J(n,pre)+p.eta*sum(p.W(delta_t, J(n,pre))),p.w_min);
                        h=hist(delta_t,p.Plast_bin_center)';
                        h(1)=0;
                        h(end)=0;
                        ISI_counts(post_g,pre_g,:,batch)=squeeze(ISI_counts(post_g,pre_g,:,batch))+h;
                    end
                end
                %$$$$$$$$$$$$$$$$$
            end
            %$$$$$$$$$$$$$$$$$$$$$$$
            %$$$$$$$$$$$$$$$$$$$$$$$
            %$$$$$$$$$$$$$$$$$$$$$$$
        end %loop over post net neurons n
        
        %UPDATING NETWORK POISSON RATES---------------
        s=s-1/p.tau_syn*s*p.dt ; %synaptic decay
        ext=zeros(size(r)); %external rates
        ext(p.group_ind{1})=RATES(1,t)/1000;
        ext(p.group_ind{2})=RATES(2,t)/1000;
        ext(p.group_ind{3})=RATES(3,t)/1000;
        r=p.net_rate/1000+s+ext; %UPDATE
        %---------------------------------------------
        %Triggered Stim---------------------------------
        if p.stim_switch==1 && ~isempty(next_stim) && t_now>=next_stim(1)
            r(p.N/3+1:2*p.N/3)=r(p.N/3+1:2*p.N/3)+p.stim_size;
            if length(next_stim)>1
                next_stim=next_stim(2:end);
            else
                next_stim=[];
            end
        end
         %---------------------------------------------
        
        %ROLLING THE DIE TO SEE WHO SPIKES IN NET (and adding then to
        %queues)
        ind=ref_net(rand(p.N,1)<=r*p.dt); %indices of spiking cells
        if ~isempty(ind)
            
            %saving spike times now
            spikes(sub2ind(size(spikes),ind,spike_entry(ind)))=t_now+p.dt/2; %storing spikes
            spike_entry(ind)=spike_entry(ind)+1; %updating entry indices
            %resizing 'spikes' if too small
            if max(spike_entry)>size(spikes,2)
                spikes=[spikes,zeros(p.N,100)];
            end

            for n=ind %running over spiking cells now and storing spikes with according delays
                post_g=floor(3*(n-1)/p.N)+1; %group assignment
                
                Ntak=ref_net(logical(p.J0(:,n))); %post-syn indices
                Pretak=ref_net(logical(p.J0(n,:)));
                
                %UPDATING SYNAPTIC QUEUES
                net_syn_queue(sub2ind(size(net_syn_queue),Ntak,n*ones(size(Ntak)),...
                    mod(net_syn_entry(Ntak,n)',net_queu_len)+1))=t_now+p.dt/2+p.net_d(Ntak,n)';
                net_syn_entry(Ntak,n)=net_syn_entry(Ntak,n)+1;
            end  %loop over spiking cells index

            %$$$$$$$$$$$$$$$$$$$$
            %PLASTICITY
            %UPDATING J MATRIX WITH OUTGOING SPIKE RULE
            if p.w_out~=0
                J(ind,:)=J(ind,:)+p.eta*p.w_out;
                J=J.*p.J0;
            end
            %$$$$$$$$$$$$$$$$$$$$
            
            %Chec rec cell for triggered stim------------------
            if ismember(p.rec_neuron,ind) %checking if REC neuron fires now
                next_stim=[next_stim t_now+p.dt/2+p.stim_del];
            end
            %------------------------------
        end
        
        %PLASTICITY $$$$$$$$
        % Apply J bounds
        J=min(J,p.w_max*ones(size(J)));
        J=max(J,p.w_min*ones(size(J)));
        %$$$$$$$$$$$$$$$$$$$$$
        
        %TEMPORARY STORING_______________
        r_temp(:,t)=r;
        s_temp(:,t)=s;
        %_____________________________________

        
    end %time loop for net simulation (batch)
    
    %Saving things from this batch
    Jtraj(:,:,batch+1)=J;
    %$$$--------------$$$
    
    %trimming spikes array
    spikes=spikes(:,1:max(spike_entry)-1);
    Rates(:,batch+1)=(spike_entry-1)/p.T_batch_size;
    
    toc
    
    %PLOTS for this batch+++++++++++++
    if online_plot_flag==1
        subplot(3,2,3)
        set(gca,'FontSize',20)
        pcolor(J)
        xlabel 'presyn'
        ylabel 'postsyn'
        title 'J'
        caxis([p.w_min,p.w_max])

        subplot(3,2,2)
        set(gca,'FontSize',20)
        hold all
        for it=1:3
            plot(linspace(time(batch),time(batch+1),p.num_batch_steps),RATES(it,:),p.cols{it})
        end
        hold off
        axis([(batch-1)*p.T_batch_size,batch*p.T_batch_size 0 max(max(RATES))+1])
        xlabel 'time (s)'
        ylabel 'Ext rate (Hz)'
        title(['External drive Raster ; BATCH#' num2str(batch) '/' num2str(p.num_batch)])

        subplot(3,2,4)
        set(gca,'FontSize',20)
        for n=1:p.N/3
            plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
                n*ones(spike_entry(n)-1,1),[p.cols{1} '.'])
            hold on
            if p.stim_switch==1 && n==p.rec_neuron
                plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
                n*ones(spike_entry(n)-1,1),'ro')
            end
        end
        for n=p.N/3+1:2*p.N/3
            plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
                n*ones(spike_entry(n)-1,1),['.',p.cols{2}])
            hold on
        end
        for n=2*p.N/3+1:p.N
            plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
                n*ones(spike_entry(n)-1,1),['.',p.cols{3}])
            hold on
        end

        hold off
        axis([(batch-1)*p.T_batch_size,batch*p.T_batch_size 0 p.N+1])
        xlabel 'time (s)'
        ylabel 'neuron #'
        title 'Network Raster'

        subplot(3,2,5)
        set(gca,'FontSize',20)
        for n=1:p.N/3
            plot(time(1:batch+1),Rates(n,1:batch+1),'k--')
            hold on
        end
        plot(time(1:batch+1),mean(Rates(1:p.N/3,1:batch+1),1),'k','LineWidth',2)
         for n=p.N/3+1:2*p.N/3
            plot(time(1:batch+1),Rates(n,1:batch+1),'r--')
            hold on
         end
         plot(time(1:batch+1),mean(Rates(p.N/3+1:2*p.N/3,1:batch+1),1),'r','LineWidth',2)
         for n=2*p.N/3+1:p.N
            plot(time(1:batch+1),Rates(n,1:batch+1),'m--')
            hold on
         end
        plot(time(1:batch+1),mean(Rates(2*p.N/3+1:end,1:batch+1),1),'r','LineWidth',2)
        hold off
        xlabel 'Time (s)'
        ylabel 'Firing Rate (Hz)'
        title(['Averaged firing rates'])  
        axis([0 p.T_total 0 100])

        subplot(3,2,6)
        set(gca,'FontSize',20)
        for n=1:p.N/3
            Ptak=ref_net(logical(p.J0(:,n)));
            for m=Ptak
                if m<=p.N/3
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'k')
                else
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
                end
                hold on
            end
        end
        for n=p.N/3+1:2*p.N/3
            Ptak=ref_net(logical(p.J0(:,n)));
            for m=Ptak
                if m<=p.N/3
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
                elseif m>2*p.N/3
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
                else
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'r')
                end
                hold on
            end
        end
        for n=2*p.N/3+1:p.N
            Ptak=ref_net(logical(p.J0(:,n)));
            for m=Ptak
                if m>2*p.N/3
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'m')
                else
                    plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
                end
                hold on
            end
        end
        hold off
        xlabel 'Time (s)'
        ylabel 'J_{ij}'
        title(['Synaptic weigths'])  
        axis([0 p.T_total p.w_min p.w_max])

        pause(0.5)
    end
    
    %saving things
    save([p.file_output, p.filename], 'p', 'Jtraj','time','Rates','spikes','batch','spike_entry','ISI_counts','mean_ext_rates','RATES_array')
end %batch loop

%% Final run plots below

%some vars
J=squeeze(Jtraj(:,:,batch+1));
RATES=squeeze(RATES_array(:,:,batch));
ref_net=1:p.N;

%xcorr from ISIs prep
mean_ISI_counts=mean(ISI_counts(:,:,:,1:batch),4);
num_connects=zeros(3,3);
for g_pre=1:3
    for g_post=1:3
        num_connects(g_post,g_pre)=sum(sum(p.J0(p.group_ind{g_post},p.group_ind{g_pre})));
    end
end

%xcorr from Rates prep
maxlags=p.Plast_bin_center(end)/p.dt;
rate_lags=p.Plast_bin_center(1):p.dt:p.Plast_bin_center(end);
Xrates=reshape(RATES_array,[size(RATES_array,1),size(RATES_array,2)*size(RATES_array,3)])+p.net_rate;
ext_xcorr=zeros(3,3,length(rate_lags)); %xcorr of external rates
C_ext_xcorr=zeros(3,3,length(rate_lags)); 

figure;
for g1=1:3
    for g2=1:3
        %computing xcorr of external rates
        ext_xcorr(g1,g2,:)=xcorr(Xrates(g2,:)/1000,Xrates(g1,:)/1000,maxlags,'none');
        
        %plots
        subplot(3,3,sub2ind([3,3],g1,g2))
        set(gca,'FontSize',13)
        
        %from ISI
        plot(p.Plast_bin_center,squeeze(mean_ISI_counts(g1,g2,:))/num_connects(g1,g2),'k.')
        hold on
        
        %from Rates
        plot(rate_lags,squeeze(ext_xcorr(g1,g2,:))*p.dt/p.num_batch,'r')
        
        plot([0,0],[0,1],'k--')
        hold off
        title([num2str(g2) '-->' num2str(g1)])
        xlabel 'ISI(ms)'
        ylabel 'mean count'
%         axis([p.Plast_bin_center(1) p.Plast_bin_center(end) 0 300])%max(max(max(mean_ISI_counts)))])
    end
end

%
% full shinanigns plots
figure('Position', [100, 100, 1049, 895]);
subplot(3,2,1)
set(gca,'FontSize',20)
pcolor(squeeze(Jtraj(:,:,1)))
xlabel 'presyn'
ylabel 'postsyn'
title 'Initial J'
caxis([p.w_min,p.w_max])

subplot(3,2,3)
set(gca,'FontSize',20)
pcolor(J)
xlabel 'presyn'
ylabel 'postsyn'
title 'J'
caxis([p.w_min,p.w_max])

subplot(3,2,2)
set(gca,'FontSize',20)
hold all
for it=1:3
    plot(linspace(time(batch),time(batch+1),p.num_batch_steps),RATES(it,:),p.cols{it})
end
hold off
axis([(batch-1)*p.T_batch_size,batch*p.T_batch_size 0 max(max(max(RATES_array)))+1])
xlabel 'time (s)'
ylabel 'Ext rate (Hz)'
title(['External drive Raster ; BATCH#' num2str(batch) '/' num2str(p.num_batch)])

subplot(3,2,4)
set(gca,'FontSize',20)
for n=1:p.N/3
    plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
        n*ones(spike_entry(n)-1,1),'k.')
    hold on
    if p.stim_switch==1 && n==p.rec_neuron
        plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
        n*ones(spike_entry(n)-1,1),'ro')
    end
end
for n=p.N/3+1:2*p.N/3
    plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
        n*ones(spike_entry(n)-1,1),'r.')
    hold on
end
for n=2*p.N/3+1:p.N
    plot(spikes(n,1:spike_entry(n)-1)/1000+(batch-1)*p.T_batch_size,...
        n*ones(spike_entry(n)-1,1),'m.')
    hold on
end
hold off
axis([(batch-1)*p.T_batch_size,batch*p.T_batch_size 0 p.N+1])
xlabel 'time (s)'
ylabel 'neuron #'
title 'Network Raster'

subplot(3,2,5)
set(gca,'FontSize',20)
for n=1:p.N/3
    plot(time(1:batch+1),Rates(n,1:batch+1),'k--')
    hold on
end
plot(time(1:batch+1),mean(Rates(1:p.N/3,1:batch+1),1),'k','LineWidth',2)
 for n=p.N/3+1:2*p.N/3
    plot(time(1:batch+1),Rates(n,1:batch+1),'r--')
    hold on
 end
 plot(time(1:batch+1),mean(Rates(p.N/3+1:2*p.N/3,1:batch+1),1),'r','LineWidth',2)
 for n=2*p.N/3+1:p.N
    plot(time(1:batch+1),Rates(n,1:batch+1),'m--')
    hold on
 end
plot(time(1:batch+1),mean(Rates(2*p.N/3+1:end,1:batch+1),1),'r','LineWidth',2)
hold off
xlabel 'Time (s)'
ylabel 'Firing Rate (Hz)'
title(['Averaged firing rates'])  
axis([0 p.T_total 0 75])

subplot(3,2,6)
set(gca,'FontSize',20)
for n=1:p.N/3
    Ptak=ref_net(logical(p.J0(:,n)));
    for m=Ptak
        if m<=p.N/3
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'k')
        else
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
        end
        hold on
    end
end
for n=p.N/3+1:2*p.N/3
    Ptak=ref_net(logical(p.J0(:,n)));
    for m=Ptak
        if m<=p.N/3
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
        elseif m>2*p.N/3
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
        else
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'r')
        end
        hold on
    end
end
for n=2*p.N/3+1:p.N
    Ptak=ref_net(logical(p.J0(:,n)));
    for m=Ptak
        if m>2*p.N/3
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'m')
        else
            plot(time(1:batch+1),squeeze(Jtraj(m,n,1:batch+1)),'b')
        end
        hold on
    end
end
hold off
xlabel 'Time (s)'
ylabel 'J_{ij}'
title(['Synaptic weigths'])  
axis([0 p.T_total p.w_min p.w_max])



%% Temporary plots
timz=linspace(0,p.T_batch_size,p.num_batch_steps);
cell_choice=p.N/3;
pre_net=ref_net(logical(p.J0(cell_choice,:)));


figure;
set(gca,'FontSize',20)
plot(timz,r_temp(cell_choice,:))
hold on
plot(timz,s_temp(cell_choice,:),'r')
plot(spikes(cell_choice,1:spike_entry(cell_choice)-1)/1000,0.001*mean(r_temp(cell_choice,:))*ones(spike_entry(cell_choice)-1,1),'k.')
for m=pre_net
    if m<=p.N/3
        plot((spikes(m,1:spike_entry(m)-1)+p.net_d(m))/1000,m/1000*ones(1,spike_entry(m)-1),'k+')
    elseif m>=2*p.N/3+1
        plot((spikes(m,1:spike_entry(m)-1)+p.net_d(m))/1000,m/1000*ones(1,spike_entry(m)-1),'b+')
    else
        plot((spikes(m,1:spike_entry(m)-1)+p.net_d(m))/1000,m/1000*ones(1,spike_entry(m)-1),'r+')
    end            
end
if p.stim_switch==1
    plot(spikes(p.rec_neuron,1:spike_entry(p.rec_neuron)-1)/1000,0.2*ones(1,spike_entry(p.rec_neuron)-1),'r.')
end
hold off
xlabel 'time (s))'
ylabel 'rate'
axis([0 timz(end) 0 max(r_temp(cell_choice,:))])

% figure;
% set(gca,'FontSize',20)
% plot(timz,squeeze(J_temp(cell_choice,:,:)),'b.-')
% hold on
% plot(timz,squeeze(J_temp(:,cell_choice,:)),'r')
% plot(spikes(cell_choice,1:spike_entry(cell_choice)-1)/1000,0.002*ones(spike_entry(cell_choice)-1,1),'k.')
% hold off
% xlabel 'time (s)'
% ylabel 'J_{ij}'

% figure;
% for t=1:5:p.num_batch_steps
%     pcolor(squeeze(J_temp(:,:,t)))
%     caxis([p.w_min,p.w_max])
%     title(['Time=' num2str(timz(t)) ' sec'])
%     pause(0.1)
% end

beep
