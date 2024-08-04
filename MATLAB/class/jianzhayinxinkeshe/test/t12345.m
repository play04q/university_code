c = 3e8; % 光速
f0 = 100e6; % 基频
lambda = c / f0; % 波长
% 发射信号
T = 20e-6;
t = 0:2e-9:30 * T;
x = (square(2 * (1 / T) * pi * t, 50) + 1) ./ 2;
figure;
subplot(4, 1, 1); plot(t, x)
x1 = 100 * sin(2 * pi * f0 * t);
subplot(4, 1, 2); plot(t, x1)
fs = 2048;
x2 = x .* x1;
subplot(4, 1, 3); plot(t, x2)

% 参数设置
Vm = 300; Vt = 200;
V = Vm + Vt; % 总速度
fd = 2 * V / lambda; % 多普勒频移
l = 1000;
t = 1.9994:2e-9:l / V; 
Ri = l - V .* t;
tao = 2 .* Ri / c;
a = lambda ./ (Ri .^ 2);
a1 = 100 .* sin(2 * pi * (f0 + fd) .* t);
x11 = a .* a1; % 回波连续
% 确保 square 函数中的参数是整数
x0 = (square(2 * (1 / T) * pi * round(t - tao), 50) + 1) ./ 2;
x21 = x11 .* x0; % 脉冲回波
x3 = x21 .* x2; % 混频后的信号
figure; 
subplot(4, 1, 1); plot(t, x2);
subplot(4, 1, 2); plot(t, x21);
subplot(4, 1, 3); plot(t, x3);

N = length(t); % 信号长度
x3_fft = fft(x3); % 对混频信号进行 FFT
x3_fft = x3_fft / N; % 归一化
f = (0:N-1) * (fs / N); % 频率向量

% 对混频信号 x3 进行 FFT
x3_fft = fft(x3);
x3_fft = x3_fft / N; % 归一化

% 频率向量
f = (0:N-1) * (fs / N);

% 画出 x3 的频谱图
figure;
subplot(2, 1, 1);
plot(f, abs(x3_fft));
title('混频信号 x3 的频谱图');
xlabel('频率 (Hz)');
ylabel('幅度');
xlim([0 fs/2]); % 只显示正频率部分

% 找出上下边频率
[~, maxIdx] = max(abs(x3_fft(1:N/2))); % 找出正频率部分的最大值索引
upper_sideband_frequency = f(maxIdx); % 上边频率
lower_sideband_frequency = f(N/2 - maxIdx + 1); % 下边频率

% 显示上下边频率
disp(['上边频率: ', num2str(upper_sideband_frequency), ' Hz']);
disp(['下边频率: ', num2str(lower_sideband_frequency), ' Hz']);

% 标注上下边频率
subplot(2, 1, 1);
hold on;
plot(upper_sideband_frequency, abs(x3_fft(maxIdx)), 'ro');
plot(lower_sideband_frequency, abs(x3_fft(N/2 - maxIdx + 1)), 'ro');
hold off;

% 画出频谱图 (双边频谱)
subplot(2, 1, 2);
plot(f - fs/2, fftshift(abs(x3_fft)));
title('混频信号 x3 的双边频谱图');
xlabel('频率 (Hz)');
ylabel('幅度');
xlim([-fs/2 fs/2]); % 显示双边频谱
