%% WCNPS 2021: Channel Estimation and Joint Beamforming for Multi-IRS MIMO Systems

%% Author : Kenneth Brenner dos Anjos Benício
%% Github : https://github.com/KennethBenicio
%% Contact: Kennethbrenner4242@gmail.com
%% Abstract: In this algorithm we obtain the plot for the proposed scenarios considering the
%% total number of reflective elements in the system.

clc
clear
close all

Mr = 4;
Mt = 4;
P  = 2;

%% Parameters
snr    = 0:5:30; %dB

%% CASE 1
sys_par_c1    = zeros(5,1);
sys_par_c1(1) = Mr;
sys_par_c1(2) = Mt;
sys_par_c1(3) = 8;
sys_par_c1(4) = P;
sys_par_c1(5) = 8*Mt;

%% CASE 2
sys_par_c2    = zeros(5,1);
sys_par_c2(1) = Mr;
sys_par_c2(2) = Mt;
sys_par_c2(3) = 16;
sys_par_c2(4) = P;
sys_par_c2(5) = 16*Mt;

%% CASE 3
sys_par_c3    = zeros(5,1);
sys_par_c3(1) = Mr;
sys_par_c3(2) = Mt;
sys_par_c3(3) = 32;
sys_par_c3(4) = P;
sys_par_c3(5) = 32*Mt;

%% CASE 4
sys_par_c4    = zeros(5,1);
sys_par_c4(1) = Mr;
sys_par_c4(2) = Mt;
sys_par_c4(3) = 64;
sys_par_c4(4) = P;
sys_par_c4(5) = 64*Mt;

load ADR_PA_c1.mat 
load ADR_PA_c2.mat 
load ADR_PA_c3.mat
load ADR_RS_c1.mat 
load ADR_RS_c2.mat 
load ADR_RS_c3.mat

%% ADR plot
figure('DefaultAxesFontSize',12)

txt = ['PA, N = ' num2str(sys_par_c1(3))]; 
plot(snr,ADR_PA_c1,'-*','color', 'green', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['PA, N = ' num2str(sys_par_c2(3))];
plot(snr,ADR_PA_c2,'-o','color', 'red', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['PA, N = ' num2str(sys_par_c3(3))];
plot(snr,ADR_PA_c3,'-d','color', 'blue', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ' num2str(sys_par_c1(3))]; 
plot(snr,ADR_RS_c1,'--*','color', 'green', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ' num2str(sys_par_c2(3))];
plot(snr,ADR_RS_c2,'--o','color', 'red', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold on

txt = ['RS, N = ' num2str(sys_par_c3(3))];
plot(snr,ADR_RS_c3,'--d','color', 'blue', "linewidth", 3, "markersize", 12, "DisplayName", txt);
hold off

title(['Perfect Absorbers vs. Regular Scatterers: P = ' num2str(P), ', M_R = ' num2str(Mr), ', M_T = ' num2str(Mt)],"fontsize", 10)
xlabel('SNR in dB',"fontsize", 12)
ylabel('ADR in bps/Hz',"fontsize", 12)

legend_copy = legend("location", "northwest");
set (legend_copy, "fontsize", 16);

grid on;

print -depsc pa_vs_rs_case_2.eps