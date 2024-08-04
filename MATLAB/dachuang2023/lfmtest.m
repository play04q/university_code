%%  当信号的中心频率为F_0=0时
close all;
clear all;
clc; 
%%调用LFM_signal函数，观察结果
A=1;                  %发射信号的振幅
Phi0=0;               %发射信号的随机初相
T=10e-6;              %信号时宽
B=30e6;               %信号带宽
F0=0;                 %中频频率，即载频频率
[st1,st2]=LFM_signal(A,Phi0,T,B,F0);

%%  当信号的中心频率为F_0=5MHz时
close all;
clear all;
clc; 
%%调用LFM_signal函数，观察结果
A=1;                  %发射信号的振幅
Phi0=0;               %发射信号的随机初相
T=10e-6;              %信号时宽
B=30e6;               %信号带宽
F0=5e6;               %中频频率，即载频频率
[st1,st2]=LFM_signal(A,Phi0,T,B,F0);
