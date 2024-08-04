%%-----------------------------------------------------------------------------------------------------------%%
%%说明：调用此函数可以输出线性调频信号余弦表达式下的信号波形图及频谱图；以及复数表达式下的信号波形图的实部、虚部及频谱图%%
%%-----------------------------------------------------------------------------------------------------------%%
function [st1,st2] = LFM_signal(A,Phi0,T,B,F0)
%* st1:线性调频信号的复数表达式 **%
%* st2:线性调频信号的余弦表达式 **%
%*** A:信号的振幅 ***************%
% Phi0:信号的随机初相 ***********%
%*** T:信号时宽 *****************%
%*** B:信号带宽 *****************%
%** F0:信号的中频频率，即载频频率 %

%%%%% 信号的参数设置 %%%%%
K=B/T;         %调频斜率
Fs=2*B;        %采样频率
Ts=1/Fs;       %采样周期
N=T/Ts;        %采样点数

%%%%% 线性调频信号的两种表达方式 %%%%%
t=linspace(-T/2,T/2,N);
st1=A*exp(1j*(2*pi*F0*t+pi*K*t.^2+Phi0));  %线性调频信号的复数表达式
st2=A*cos(2*pi*F0*t+pi*K*t.^2+Phi0);       %线性调频信号的余弦表达式
                                     
figure(1);
subplot(3,1,1);
plot(t*1e6,real(st1));
xlabel('时间/us');
ylabel('实部')
title('线性调频信号的实部');
grid on;
axis tight;
 
subplot(3,1,2);
plot(t*1e6,imag(st1));
xlabel('时间/us');
ylabel('虚部')
title('线性调频信号的虚部');
grid on;
axis tight;
 
subplot(3,1,3);
freq=linspace(-Fs/2,Fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(st1))));  %先对st做傅里叶变换得到频谱，然后取幅度值，再将其移动到频谱中心
xlabel('频率/MHz');
ylabel('幅度谱')
title('线性调频信号的频谱');
grid on;
axis tight;
 
figure(2);
subplot(2,1,1);
plot(t*1e6,real(st2));
xlabel('时间/us');
ylabel('实部')
title('线性调频信号的实部');
grid on;
axis tight;
 
subplot(2,1,2);
freq=linspace(-Fs/2,Fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(st2))));   %先对st做傅里叶变换得到频谱，然后取幅度值，再将其移动到频谱中心
xlabel('频率/MHz');
ylabel('幅度谱')
title('线性调频信号的频谱');
grid on;
axis tight;
end