%% WCNPS 2021: Channel Estimation and Joint Beamforming for Multi-IRS MIMO Systems

%% Author : Kenneth Brenner dos Anjos Benício
%% Github : https://github.com/KennethBenicio
%% Contact: Kennethbrenner4242@gmail.com
%% Abstract: In this algorithm we obtain the plot for the proposed scenarios considering that
%% the total number of reflective elements in the system remains constant and we analyze two types
%% of IRS's deployment: centralized and descentralized.

clc
clear
close all

Mr = 4;
Mt = 4;
K = 64;

%% Parameters
snr    = 0:5:30; %dB

%% CASE 1
sys_par_c1    = zeros(5,1);
sys_par_c1(1) = Mr;
sys_par_c1(2) = Mt;
sys_par_c1(3) = 64;
sys_par_c1(4) = 1;
sys_par_c1(5) = 64*Mt;

%% CASE 2
sys_par_c2    = zeros(5,1);
sys_par_c2(1) = Mr;
sys_par_c2(2) = Mt;
sys_par_c2(3) = 32;
sys_par_c2(4) = 2;
sys_par_c2(5) = 32*Mt;

%% CASE 3
sys_par_c3    = zeros(5,1);
sys_par_c3(1) = Mr;
sys_par_c3(2) = Mt;
sys_par_c3(3) = 16;
sys_par_c3(4) = 4;
sys_par_c3(5) = 16*Mt;

%% Loading data files

load ADR_PA_c3.mat
load ADR_RS_c1.mat 
load ADR_RS_c2.mat 
load ADR_RS_c3.mat


load ADR_PA_no_IRS_c3.mat

%% ADR plot
figure('DefaultAxesFontSize',12)

txt = ['PA, N = ', num2str(sys_par_c3(3)),', P = ' num2str(sys_par_c3(4))];
plot(snr,ADR_PA_c3,'-d','color', 'blue', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ', num2str(sys_par_c1(3)),', P = ' num2str(sys_par_c1(4))]; 
plot(snr,ADR_RS_c1,'--s','color', 'yellow', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ', num2str(sys_par_c2(3)),', P = ' num2str(sys_par_c2(4))]; 
plot(snr,ADR_RS_c2,'--*','color', 'green', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ', num2str(sys_par_c3(3)),', P = ' num2str(sys_par_c3(4))]; 
plot(snr,ADR_RS_c3,'--o','color', 'red', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold off

title(['Perfect Absorbers vs. Regular Scatterers: K = ' num2str(K), ', M_R = ' num2str(Mr), ', M_T = ' num2str(Mt)],"fontsize", 10)
xlabel('SNR in dB',"fontsize", 12)
ylabel('ADR in bps/Hz',"fontsize", 12)

legend_copy = legend("location", "northwest");
set (legend_copy, "fontsize", 16);

grid on;

print -depsc pa_vs_rs_case_3.eps