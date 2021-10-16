%%Number of IRSs

clc
clear
close all
pkg load communications

betairs = 0.25;

P  = 2;
Mr = 4;
Mt = 4;
N  = 8;
K  = N * Mt;

MCC    = 1;
snr    = 0:10:30; %dB
snr_tr = 25;  
SNR    = 10.^(snr/10); %linear
SNR_TR = 10.^(snr_tr/10);

%% Parameters
ADR_no_IRS_c1  = zeros(length(SNR),MCC);
ADR_propos_c1  = zeros(length(SNR),MCC);

ADR_no_IRS_c2  = zeros(length(SNR),MCC);
ADR_propos_c2  = zeros(length(SNR),MCC);

ADR_no_IRS_c3  = zeros(length(SNR),MCC);
ADR_propos_c3  = zeros(length(SNR),MCC);

%% CASE 1
sys_par    = zeros(5,1);
sys_par(1) = Mr;
sys_par(2) = Mt;
sys_par(3) = N;
sys_par(4) = P;
sys_par(5) = N*Mt;

for jj = 1:length(SNR)
    jj
    for mc = 1:MCC
        mc;
        %% CASE 1 
        [ADR_propos_c1(jj,mc),ADR_no_IRS_c1(jj,mc),~,~,~,] = wcnps_pilot_sig_beam_opt_w_opt(sys_par,4,SNR(jj),SNR_TR,betairs);
        
        %% CASE 2 
        [ADR_propos_c2(jj,mc),ADR_no_IRS_c2(jj,mc),~,~,~,] = wcnps_pilot_sig_beam_opt_general(sys_par,4,SNR(jj),SNR_TR,betairs);
 
        %% CASE 3 
        [ADR_propos_c3(jj,mc),ADR_no_IRS_c3(jj,mc),~,~,~,] = wcnps_pilot_sig_beam_opt_specific(sys_par,4,SNR(jj),SNR_TR);

    end
end

ADR_no_IRS_c1  = mean(ADR_no_IRS_c1,2);
ADR_propos_c1  = mean(ADR_propos_c1,2);

ADR_no_IRS_c2  = mean(ADR_no_IRS_c2,2);
ADR_propos_c2  = mean(ADR_propos_c2,2);

ADR_no_IRS_c3  = mean(ADR_no_IRS_c3,2);
ADR_propos_c3  = mean(ADR_propos_c3,2);

printf("\nADR in WCNPS:\n")
ADR_propos_c1
printf("\nADR General:\n")
ADR_propos_c2
printf("\nADR in TCC Specific:\n")
ADR_propos_c3

%% ADR plot
figure('DefaultAxesFontSize',12)

txt = ['RS (Kbar = K/2)']; 
plot(snr,ADR_propos_c1,'-s','color', [0.8 0.1  1.0 ], "linewidth", 3, "markersize", 8, "DisplayName", txt);
hold on

txt = ['RS (Kbar = K - 1)'];
plot(snr,ADR_propos_c2,'-+','color', [0.75 0.25  0 ], "linewidth", 3, "markersize", 8, "DisplayName", txt);
hold on

txt = ['PA'];
plot(snr,ADR_propos_c3,'-x','color', [0.15 1  0.45 ], "linewidth", 3, "markersize", 8, "DisplayName", txt);
hold on

title(['Multi-IRS MIMO System with N = ' num2str(N), ', M_R = ' num2str(Mr), ', M_T = ' num2str(Mt), ' P = ' num2str(P)])
xlabel('SNR in dB')
ylabel('ADR in bps/Hz')

legend_copy = legend("location", "northwest");
set (legend_copy, "fontsize", 16);

grid on;

%% Saving data files

% save ADR_no_IRS_c1.mat ADR_no_IRS_c1
% save ADR_no_IRS_c2.mat ADR_no_IRS_c2
% save ADR_no_IRS_c3.mat ADR_no_IRS_c3

% save ADR_propos_c1.mat ADR_propos_c1
% save ADR_propos_c2.mat ADR_propos_c2
% save ADR_propos_c3.mat ADR_propos_c3