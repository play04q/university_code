% 定义信号参数
Fs = 1000; % 采样频率，假设为1000Hz
T = 1;     % 信号总时长，假设为1秒
t = 0:1/Fs:T-1/Fs; % 时间向量

% 创建信号
x = 0.5*sin(2*pi*15*t) + 2*sin(2*pi*40*t);

% 计算信号的快速傅里叶变换（FFT）
X = fft(x, length(t));
X = fftshift(X); % 移动FFT的零频分量至中间

% 设定阈值，滤除低频部分
threshold = 50; % 阈值，根据实际情况调整
if abs(X) < threshold
    X_low = X(abs(X) < threshold);
else
    X_low = 0;
end
% 逆FFT变换，恢复时域信号
xn = ifft(X_low);

% 绘制原始信号和滤波后的信号
figure;
subplot(2,1,1);
plot(t, x);
title('原始信号');
xlabel('时间 (秒)');
ylabel('幅度');

subplot(2,1,2);
plot(t, real(xn));
title('滤波后的信号');
xlabel('时间 (秒)');
ylabel('幅度');