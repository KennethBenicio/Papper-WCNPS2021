%% WCNPS 2021: Channel Estimation and Joint Beamforming for Multi-IRS MIMO Systems

%% Author : Kenneth Brenner dos Anjos Benício
%% Github : https://github.com/KennethBenicio
%% Contact: Kennethbrenner4242@gmail.com
%% Abstract: In this algorithm we obtain the plot for the proposed scenarios considering the
%% total number of IRSs in the system.

clc
clear
close all

%% Parameters
Mr = 4;
Mt = 4;
N  = 32;
K  = N * Mt;
snr    = 0:5:30; %dB

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

%% Loading data files

load ADR_PA_c4.mat 
load ADR_RS_c4.mat 
load ADR_PA_no_IRS_c4.mat 

%% ADR plot
figure('DefaultAxesFontSize',12)

txt = ['PA, P = ' num2str(sys_par_c4(4))];
plot(snr,ADR_PA_c4,'-d','color', 'blue', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, P = ' num2str(sys_par_c4(4))];
plot(snr,ADR_RS_c4,'--o','color', 'red', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['No IRS, L = 4'];
plot(snr,ADR_PA_no_IRS_c4,'-^','color', 'black', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold off

title(['Perfect Absorbers vs. Regular Scatterers: N = ' num2str(N), ', M_R = ' num2str(Mr), ', M_T = ' num2str(Mt)],"fontsize", 10)
xlabel('SNR in dB',"fontsize", 12)
ylabel('ADR in bps/Hz',"fontsize", 12)

legend_copy = legend("location", "northwest");
set (legend_copy, "fontsize", 18);

grid on;

print -depsc pa_vs_rs_case_1.eps