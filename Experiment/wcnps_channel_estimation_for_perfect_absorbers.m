%% WCNPS 2021: Channel Estimation and Joint Beamforming for Multi-IRS MIMO Systems

%% Author : Kenneth Brenner dos Anjos Benício
%% Github : https://github.com/KennethBenicio
%% Contact: Kennethbrenner4242@gmail.com
%% Abstract: In this algorithm we show a simulation implementation of a Multi-IRS MIMO Systems where
%% the Intelligent Reflective Surfaces (IRSs) are considered to behave as metasurfaces capable of
%% perfectily absorber impinging eletromagnetic waves (Perfect Absorbers). In this algorithm there is not a pilot processing
%% step at the estimation process since we will directly use the received pilots signals.



function [ADR_prop,ADR_no_IRS,W_opt,Q_opt,S_opt] = wcnps_channel_estimation_for_perfect_absorbers(sys_par,SNR,SNR_training)



    %%----- System parameters -----%%

    %% Number of antennas at the receiver, number of antennas at the transmitter, number of IRSs elements, 
    %% number of IRSs, training overhead K defined as N*P, number of natural scatterers at the system. 
    Mr = sys_par(1);
    Mt = sys_par(2);
    N  = sys_par(3);
    P  = sys_par(4);
    K  = sys_par(5);
    L  = P;
   
    %% Since the IRS is a 2D panel, it is necessary to divide the total number of elements following an 
    %% Uniform Rectangular Array (URA) array.
    Nx = N/4;
    Ny = 4;



    %%----- Generating the channels -----%%

    %%  Angle of Departure (AoD), at the Transmitter (TX), and Angle of Arrival (AoA), at the Receiver (RX), respectively.
    theta_Tx = 2*pi*rand(1,L) - pi; 
    theta_Rx = 2*pi*rand(1,L) - pi; 

    %% Steering vectors TX-IRS and IRS-RX, respectively.
    B_tx  = 1/sqrt(1) * exp(1i*pi*(0:Mt-1).'*cos(theta_Tx));
    A_rx  = 1/sqrt(1) * exp(1i*pi*(0:Mr-1).'*cos(theta_Rx));

    %%  AoA horizontal and AoA vertical at the IRS, respectively.
    theta_IRS_AOA_x  = 2*pi*randn(1,P) - pi; 
    theta_IRS_AOA_y  = 2*pi*randn(1,P) - pi; 

    %%  AoD horizontal and AoA vertical at the IRS, respectively.
    theta_IRS_AOD_x  = 2*pi*randn(1,P) - pi;
    theta_IRS_AOD_y  = 2*pi*randn(1,P) - pi;
    
    %% Steering vectors AOA horizontal and vertical, respectively. 
    b_irs_x = 1/sqrt(1) * exp(1i*pi*((0:Nx-1).'*(cos(theta_IRS_AOA_x).*sin(theta_IRS_AOA_y))));
    b_irs_y = 1/sqrt(1) * exp(1i*pi*((0:Ny-1).'*cos(theta_IRS_AOA_y)));
    B_irs   = kr(b_irs_y,b_irs_x); % NxNy x L

    %% Steering vectors AOD horizontal and vertical, respectively. 
    a_irs_x = 1/1 * exp(1i*pi*((0:Nx-1).'*(cos(theta_IRS_AOD_x).*sin(theta_IRS_AOD_y))));
    a_irs_y = 1/1 * exp(1i*pi*((0:Ny-1).'*cos(theta_IRS_AOD_y)));
    A_irs   = kr(a_irs_y,a_irs_x); % NxNy x L

    %% Path gains
    alpha_pl =  1/sqrt(2) * (randn(L,1) + 1i*randn(L,1));
    beta_pl  =  1/sqrt(2) * (randn(L,1) + 1i*randn(L,1));

    %% Transmitted pilots signal are generated from the columns of a hadamard matrix, 
    %% since this way we obtain an orthogonal space of pilot signals. 
    x_pilots = hadamard(K);
    x_pilots = x_pilots(:,1:Mt);



    %%----- Received pilot signals -----%%

    %% Generating the AWGN component with zero mean and variance defined as 1/SNR_training
    %% for the noise vector.
    es_pilots = mean(abs(x_pilots(:)).^2); %% Energy symbol.
    var_noise = es_pilots .*  1 /SNR_training; %% variance of the AWGN component.
    noise_pilots = sqrt(var_noise/2) * (randn(Mr,K,P) + 1i*randn(Mr,K,P)); %% AWGN noise vector.

    %% IRS phase-shift matrix initialization as a DFT matrix.
    S = dftmtx(K);
    S = S(1:N,:); %% It is necessary to obtain the phase-shift matrix with the dimensions of NxK.

    %% Pilot signals for each IRS P.
    y_pilots = zeros(Mr,K,P);
    for k =1:K
        for p =1:P
            y_pilots(:,k,p) = A_rx(:,p)*alpha_pl(p)*A_irs(:,p).'*diag(S(:,k))*B_irs(:,p)*beta_pl(p)*B_tx(:,p).'*x_pilots(k,:).' + noise_pilots(:,k,p);
        end
    end

    %%  Processing the pilot signals to obtain the vector of received pilot signal for each IRS P. 
    yp = tens2mat(y_pilots,3).'; %  MrK x P

    %% Known matrix C defined as S \Khatrirao X \Kronecker Imr. It is the same matrix for each IRS.
    C  = kron(kr(S,x_pilots.').', eye(Mr));  %MrK x MrMtN



    %%----- Channel Estimation and Passive Beamforming (IRS Optimization) -----%%
   
    %% Creating empty arrays to store the estimations of the steering vectors
    %% from IRS-RX, TX-IRS and the IRS, respectively. 
    A_rx_hat = zeros(Mr,P);
    B_tx_hat =  zeros(Mt,P);
    rp = zeros(N,P);

    %% Creating empty arrays to store the optimum IRS phase-shift and path loss 
    %% estimations, respectively.
    S_opt = zeros(N,P);
    sc_ab = zeros(P,1);

    %% In this loop we do the channel estimation and passive beamforming.
    for p =1:P
        %% Obtain the estimation for the vector zp that represents the unknown elements to the estimation process. 
        %% This vector is defined as zp \approx path_loss_p_component * vec((bp_tx \Kronecker ap_rx) (bp_irs.' \Khatrirao ap_irs.')).  
        zp  = pinv(C) * yp(:,p); 
        
        %% Calculating the SVD of unvec(zp).
        Zp           = reshape(zp,Mr*Mt,N);
        [Up,Sp,Vp]   = svd(Zp);



        %%----- Passive Beamforming -----%%

        %% In this step we rescale and normalize the estimated steering vectors from the IRS.
        rp(:,p) = -1 * conj(Vp(:,1));
        sc      = B_irs(1,p) .* A_irs(1,p); 
        rp_sc   = sc(1)/rp(1,p);
        rp(:,p) = rp_sc * rp(:,p);
        rp(:,p) = rp(:,p)./abs(rp(:,p));
        
        %% IRS phase-shift optimization.
        S_opt(:,p) = exp(-1i*angle(rp(:,p)./abs(rp(:,p))));



        %%----- Channel Estimation -----%%
    
        %% In this step we rescale and normalize the estimated steering vectors from the channel.
        fp    = Up(:,1) * Sp(1,1);
        fp_sc = -1;  
        fp    = fp * fp_sc;
        
        %% Obtaining Fp \approx ap_rx * bp_tx.' from fp.
        Fp = reshape(fp,Mr,Mt);
        
        %% Estimating the channels.
        [Ux,Sx,Vx] = svd(Fp);
        A_rx_hat(:,p) = 1*Ux(:,1)*sqrt(Sx(1,1));
        B_tx_hat(:,p) = 1*conj(Vx(:,1))*sqrt(Sx(1,1));



        %%----- Path Loss Estimation -----%%        
        
        %% Estimating the individual path losses from TX-IRS and IRS-TX, respectively.
        %% This is possible since the first element of the steering vector are equal to one.
        %% This way, we can recover the path loss scale and obtain an estimation from zp.
        alpha_sc      = 1./A_rx_hat(1,p); % first Element of A_rx is equal to 1 since exp(1i*0*cos(a))
        A_rx_hat(:,p) = A_rx_hat(:,p) * alpha_sc;
        beta_sc       = 1./B_tx_hat(1,p); % first Element of B_tx is equal to 1 since exp(1i*0*cos(b))
        B_tx_hat(:,p) = B_tx_hat(:,p) * beta_sc;
        
        %% Path loss.
        scx       = zp./( 1 *  vec(kron(B_tx_hat(:,p),A_rx_hat(:,p) ) * rp(:,p).'));
        sc_ab(p)  = mean(scx);
    end

    %% IRS gain.
    IRS_gain     = zeros(P,1);
    for p=1:P
        IRS_gain(p) = A_irs(:,p).'*diag(S_opt(:,p))*B_irs(:,p); % True channels
    end



    %%----- Active Beamforming -----%%

    %% Estimated channel matrix.
    Heff_hat = A_rx_hat * diag(sc_ab)*B_tx_hat.';

    %% Active beamforming.
    [W_opt,~,Q_opt] = svd(Heff_hat);
    W_opt = 1/sqrt(P) * W_opt(:,1:P);
    Q_opt = 1/sqrt(P) * Q_opt(:,1:P);

    %% Retransmission and effective channel for the IRS and without IRS scenarios, respectively.
    Heq         = W_opt'*A_rx * diag(sc_ab) * diag(IRS_gain) * B_tx.'*Q_opt;
    Heq_no_IRS  = W_opt'*A_rx * diag(sc_ab) * B_tx.'*Q_opt;

    %% Achiavable Data Rate (ADR) for the proposed scenarios.
    ADR_prop    =   log2(real( det( eye(P) + (Heq*Heq')/(1/SNR) ) ) );
    ADR_no_IRS  =   log2(real( det( eye(P) + (Heq_no_IRS*Heq_no_IRS')/(1/SNR) ) ) );
    