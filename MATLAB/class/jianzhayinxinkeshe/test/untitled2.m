% 假设您已经有一个名为signal的信号变量
Fs = 1000;          % 采样频率
t = 0:1/Fs:1-1/Fs;  % 时间向量
 
% 生成一个示例正弦波信号
signal = 0.7*sin(2*pi*50*t) + 0.3*sin(2*pi*120*t);
 
% 计算信号的快速傅立叶变换（FFT）
Y = fft(signal);
 
% 计算频率轴
N = length(Y);
f = (0:N-1)*(Fs/N);
 
% 绘制单边频谱图
spectrogram(signal, 128, 120, 128, Fs);
 
% 标题和轴标签
title('信号频谱图');
xlabel('时间 (秒)');
ylabel('频率 (Hz)');