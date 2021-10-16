%% WCNPS 2021: Channel Estimation and Joint Beamforming for Multi-IRS MIMO Systems

%% Author : Kenneth Brenner dos Anjos Benício
%% Github : https://github.com/KennethBenicio
%% Contact: Kennethbrenner4242@gmail.com
%% Abstract: In this algorithm we obtain the data for the proposed scenarios considering that
%% the total number of reflective elements in the system remains constant.

clc
clear
close all
pkg load communications

%% Parameters

Mr = 4;
Mt = 4;
N  = 32;
betairs = 0.25;

MCC    = 1000;
snr    = 0:5:30; %dB
snr_tr = 25;  
SNR    = 10.^(snr/10); %linear
SNR_TR = 10.^(snr_tr/10);

%% CASE 1
sys_par_c1    = zeros(5,1);
sys_par_c1(1) = Mr;
sys_par_c1(2) = Mt;
sys_par_c1(3) = N;
sys_par_c1(4) = 1;
sys_par_c1(5) = N*Mt;

%% CASE 2
sys_par_c2    = zeros(5,1);
sys_par_c2(1) = Mr;
sys_par_c2(2) = Mt;
sys_par_c2(3) = N;
sys_par_c2(4) = 2;
sys_par_c2(5) = N*Mt;

%% CASE 3
sys_par_c3    = zeros(5,1);
sys_par_c3(1) = Mr;
sys_par_c3(2) = Mt;
sys_par_c3(3) = N;
sys_par_c3(4) = 3;
sys_par_c3(5) = N*Mt;

%% CASE 4
sys_par_c4    = zeros(5,1);
sys_par_c4(1) = Mr;
sys_par_c4(2) = Mt;
sys_par_c4(3) = N;
sys_par_c4(4) = 4;
sys_par_c4(5) = N*Mt;



%%----- Perferct Absorbers -----%%

ADR_no_IRS_c1  = zeros(length(SNR),MCC);
ADR_propos_c1  = zeros(length(SNR),MCC);
ADR_no_IRS_c2  = zeros(length(SNR),MCC);
ADR_propos_c2  = zeros(length(SNR),MCC);
ADR_no_IRS_c3  = zeros(length(SNR),MCC);
ADR_propos_c3  = zeros(length(SNR),MCC);
ADR_no_IRS_c4  = zeros(length(SNR),MCC);
ADR_propos_c4  = zeros(length(SNR),MCC);

for jj = 1:length(SNR)
    jj
    tic
    for mc = 1:MCC
        %% CASE 1 
        [ADR_propos_c1(jj,mc),ADR_no_IRS_c1(jj,mc),~,~,~,] = wcnps_channel_estimation_for_perfect_absorbers(sys_par_c1,SNR(jj),SNR_TR);
        
        %% CASE 2
        [ADR_propos_c2(jj,mc),ADR_no_IRS_c2(jj,mc),~,~,~,] = wcnps_channel_estimation_for_perfect_absorbers(sys_par_c2,SNR(jj),SNR_TR);
        
        %% CASE 3
        [ADR_propos_c3(jj,mc),ADR_no_IRS_c3(jj,mc),~,~,~,] = wcnps_channel_estimation_for_perfect_absorbers(sys_par_c3,SNR(jj),SNR_TR);
        
        %% CASE 4
        [ADR_propos_c4(jj,mc),ADR_no_IRS_c4(jj,mc),~,~,~,] = wcnps_channel_estimation_for_perfect_absorbers(sys_par_c4,SNR(jj),SNR_TR);   
    end
    toc
end

ADR_PA_no_IRS_c1  = mean(ADR_no_IRS_c1,2);
ADR_PA_c1  = mean(ADR_propos_c1,2);

ADR_PA_no_IRS_c2  = mean(ADR_no_IRS_c2,2);
ADR_PA_c2  = mean(ADR_propos_c2,2);

ADR_PA_no_IRS_c3  = mean(ADR_no_IRS_c3,2);
ADR_PA_c3  = mean(ADR_propos_c3,2);

ADR_PA_no_IRS_c4  = mean(ADR_no_IRS_c4,2);
ADR_PA_c4  = mean(ADR_propos_c4,2);

%% Saving data files

save ADR_PA_no_IRS_c1.mat ADR_PA_no_IRS_c1
save ADR_PA_no_IRS_c2.mat ADR_PA_no_IRS_c2
save ADR_PA_no_IRS_c3.mat ADR_PA_no_IRS_c3
save ADR_PA_no_IRS_c4.mat ADR_PA_no_IRS_c4

save ADR_PA_c1.mat ADR_PA_c1
save ADR_PA_c2.mat ADR_PA_c2
save ADR_PA_c3.mat ADR_PA_c3
save ADR_PA_c4.mat ADR_PA_c4

%%----- Regular Scatterers -----%%

ADR_no_IRS_c1  = zeros(length(SNR),MCC);
ADR_propos_c1  = zeros(length(SNR),MCC);
ADR_no_IRS_c2  = zeros(length(SNR),MCC);
ADR_propos_c2  = zeros(length(SNR),MCC);
ADR_no_IRS_c3  = zeros(length(SNR),MCC);
ADR_propos_c3  = zeros(length(SNR),MCC);
ADR_no_IRS_c4  = zeros(length(SNR),MCC);
ADR_propos_c4  = zeros(length(SNR),MCC);

for jj = 1:length(SNR)
    jj
    tic
    for mc = 1:MCC
        %% CASE 1 
        [ADR_propos_c1(jj,mc),ADR_no_IRS_c1(jj,mc),~,~,~,] = wcnps_channel_estimation_for_regular_scatterers_1(sys_par_c1,SNR(jj),SNR_TR,betairs);
        
        %% CASE 2
        [ADR_propos_c2(jj,mc),ADR_no_IRS_c2(jj,mc),~,~,~,] = wcnps_channel_estimation_for_regular_scatterers_1(sys_par_c2,SNR(jj),SNR_TR,betairs);
        
        %% CASE 3
        [ADR_propos_c3(jj,mc),ADR_no_IRS_c3(jj,mc),~,~,~,] = wcnps_channel_estimation_for_regular_scatterers_1(sys_par_c3,SNR(jj),SNR_TR,betairs);
        
        %% CASE 4
        [ADR_propos_c4(jj,mc),ADR_no_IRS_c4(jj,mc),~,~,~,] = wcnps_channel_estimation_for_regular_scatterers_1(sys_par_c4,SNR(jj),SNR_TR,betairs);   
    end
    toc
end

ADR_RS_no_IRS_c1  = mean(ADR_no_IRS_c1,2);
ADR_RS_c1  = mean(ADR_propos_c1,2);

ADR_RS_no_IRS_c2  = mean(ADR_no_IRS_c2,2);
ADR_RS_c2  = mean(ADR_propos_c2,2);

ADR_RS_no_IRS_c3  = mean(ADR_no_IRS_c3,2);
ADR_RS_c3  = mean(ADR_propos_c3,2);

ADR_RS_no_IRS_c4  = mean(ADR_no_IRS_c4,2);
ADR_RS_c4  = mean(ADR_propos_c4,2);

%% Saving data files

save ADR_RS_no_IRS_c1.mat ADR_RS_no_IRS_c1
save ADR_RS_no_IRS_c2.mat ADR_RS_no_IRS_c2
save ADR_RS_no_IRS_c3.mat ADR_RS_no_IRS_c3
save ADR_RS_no_IRS_c4.mat ADR_RS_no_IRS_c4

save ADR_RS_c1.mat ADR_RS_c1
save ADR_RS_c2.mat ADR_RS_c2
save ADR_RS_c3.mat ADR_RS_c3
save ADR_RS_c4.mat ADR_RS_c4