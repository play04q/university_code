%LFM画图
%% 
%---时域---
figure
id = find(mod == "LFM",x);
Fs = 2000e6;Ncc=length(wav{id(x)});
t =0:1/Fs:(Ncc-1)/Fs;
plot(t,wav{id(x)})
ylabel('幅值');xlabel('时间/s')
title('LFM')

%% 
%---频域---
figure
% 对信号进行FFT变换
L=Ncc;
X = fft(wav{id(x)});
P2 = abs(X / L).^2; % 功率谱密度估计
P1 = P2(1:L/2+1); % 只保留前半部分结果
P1(2:end-1) = 2 * P1(2:end-1); % 将单边频谱转化为双边频谱
frequencies = Fs*(0:(L/2))/(L); % 计算相应的频率值
plot(frequencies, P1);% 绘制频域图像
title('LFM');xlabel('频率');ylabel('功率谱密度');

%% 
%---STFT---
figure
spectrogram(wav{id(x)},hamming(128),120,2048,2000e6,'yaxis');
ylabel('频率/GHz');xlabel('时间/ns')
axis square; colorbar off; title('LFM')

%% 
%---CWT---
figure
[cfs, frq]= cwt(real(wav{id(x)}),'Morse',1000e6);
tms = (0:numel(wav{id(x)})-1)/1000e6;  %时间序列
image('XData',tms,'YData',frq,'CData',abs(cfs),'CDataMapping','scaled')
axis tight          %自动调整坐标轴范围
shading flat        %将幅度谱图像以平面形式显示
xlabel('时间/s');ylabel('频率/Hz');title('LFM')

%% 
%---WVD---
figure
wvd(wav{id(x)},2000e6,'smoothedPseudo');
axis square; colorbar off; title('LFM')
