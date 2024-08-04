%% 
%七种信号Sin，LFM，NLFM，BPSK，QPSK，BFSK，QFSK
clc;clf;clear;close all;
Fs=2000e6;%采样频率2000MHz
x=10;%画图，每种x张
snr=1000;%信噪比（dB）
[wav,mod]=gaiGenerateRadarWaveforms(x,snr);
disp('all OK')

%% 
id= find(mod == "BPSK",x);
spectrogram(wav{id(524)},hamming(128),120,2048,2000e6,'yaxis');
% ylabel('频率/GHz');xlabel('时间/ns');title('QFSK')
axis square; colorbar off; 

%% 
% load('net1.1857.mat');
qianyiwangluo('untitled2.png')
