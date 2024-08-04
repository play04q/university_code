c=3e8; %光速
f0=100e6; %
lamda=c/f0; %
% 发射信号
T=20e-6;
t=0:2e-9:20*T;
x=(square(2*(1/T)*pi*t,50)+1)./2;
figure;
subplot(3,1,1);plot(t,x)
x1=100*sin(2*pi*f0*t);
subplot(3,1,2);plot(t,x1)
x2=x.*x1;%发射信号
subplot(3,1,3);plot(t,x2)

%% AA
Vm=300;Vt=200;
V=Vm-Vt; %
fd=2*V/lamda; %
l=1000;
t=0:1E-6:l/V;
Ri=l-V.*t;
tao=2.*Ri./c;
a=lamda./(Ri.^2);
a1=100.*sin(2*pi*(f0+fd).*t);
x11=a.*a1;%回波连续
x0=(square(2*(1/T)*pi.*(t-tao),50)+1)./2;%回波脉冲延时
% figure;plot(t,x11);
% figure;plot(t,x0);
x21=x11.*x0;%脉冲回波
% figure;plot(t,x21);
x=(square(2*(1/T)*pi*t,50)+1)./2;
x1=100*sin(2*pi*f0*t);
x2=x.*x1;
x3=x21.*x2;%混频后的信号
figure;plot(t,x3);
%频谱图
% fs  = 50e6; 
% n = 0:2047; 
% fx21=1e6;
% fx2=5e6;
% fft_out = fft(x3, 2048);
% fft_abs = abs(fft_out);
% [~, idx] = maxk(fft_abs, 2);
% f_x21 = idx(1) * fs / 2048;  
% f_x2 = idx(2) * fs / 2048;  
% disp(['Frequency component 1 after mixing：', num2str(f_x21), ' Hz']);
% disp(['Frequency component 2 after mixing：', num2str(f_x2), ' Hz']);
% frequencies = linspace(-fs/2, fs/2, 2048);
% figure;plot(frequencies, fftshift(fft_abs));
% xlabel('frequency (Hz)');
% ylabel('amplitude');
% title('Spectrogram of the signal after mixing');
% grid on;
% low_cutoff_freq = 1e6;
% [b, a] = butter(6, low_cutoff_freq/(fs/2));
% x3_time_domain = ifft(fft_out);
% x3_real = real(x3_time_domain);
% x3_filtered_real = real(x3_time_domain);
% figure;
% plot(n, x3_filtered_real);
% xlabel('Sample serial number');
% ylabel('amplitude');
% title('A time-domain representation of the filtered signal x3');
% grid on;
% x3_demodulated = abs(x3_filtered_real);
% figure;
% plot(n, x3_demodulated);
% xlabel('Sample serial number');
% ylabel('amplitude');
% title('A time-domain representation of the detected signal x3');
% grid on;

%% AG

%% 画图
% figure;
% subplot(6,1,1);plot(t,x);
% subplot(6,1,2);plot(t,x1);
% subplot(6,1,3);plot(t,x2);
% y1=x1.*x0;
% subplot(6,1,4);plot(t,y1);
% y2=y1.*x2;
% subplot(6,1,5);plot(t,y2);
% y3=sin(2*pi.*fd.*t-pi);
% subplot(6,1,6);plot(t,y3);

%% 
% 方波参数
T = 20e-6; % 周期
f = 1/T; % 频率
t = 0:1e-5:10; % 时间向量，采样间隔为0.001秒
% 初始化信号向量
y = zeros(size(t));
% 使用if语句生成方波
for i = 1:length(t)
    if mod(t(i), T) < T/2
        y(i) = 1; % 方波的高电平
    else
        y(i) = 0; % 方波的低电平
    end
end
% 绘制方波信号
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Square Wave Signal');
grid on;


%% 
clf;fs=1e9; %采样频率
Ndata=1e5; %数据长度
N=1024; %FFT的数据长度
n=0:Ndata-1;t=n/fs; %数据对应的时间序列
% x=(Ut./(R.^2).*cos((omig0+omigd).*t+fai)).*(Ut*cos(omig0.*t+fai)); %时间域信号
x=Ut.*Ut./(R.^2).*(cos((2*omig0+omigd).*t+2.*fai)+cos(omigd.*t+fai));
y=fft(x,N); %信号的Fourier变换
mag=abs(y); %求取振幅
f=(0:N-1)*fs/N; %真实频率
plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前的振幅
xlabel('频率/Hz');ylabel('振幅');

%% 
env = abs(hilbert(x));
plot(t,env)