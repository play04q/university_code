% 定义原始信号
fs = 1000; % 采样率
t = 0:1/fs:1-1/fs; % 时间序列
x = sin(2*pi*50*t) + sin(2*pi*300*t); % 带有两个正弦波的信号

% 对信号进行希尔伯特变换
xhilbert = hilbert(x);

% 计算解析信号的幅度谱和相位谱
xamp = abs(xhilbert);
xphase = angle(xhilbert);

% 绘制原始信号和解析信号的幅度谱和相位谱
f = (0:length(x)-1)*fs/length(x);
figure;
subplot(2,3,1);
plot(t, x);
title('原始信号');

subplot(2,3,3);
plot(f, abs(fft(x)));
title('原始信号的幅度谱');

subplot(2,3,4);
plot(f, unwrap(angle(fft(x))));
title('原始信号的相位谱');

subplot(2,3,2);
plot(t, xamp);
title('解析信号的幅度谱');

subplot(2,3,5);
plot(f, abs(fft(xamp)));
title('解析信号的幅度谱');

subplot(2,3,6);
plot(f, unwrap(xphase));
title('解析信号的相位谱');
