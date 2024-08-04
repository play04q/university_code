clear;clc;clf;close all;
%% 交汇
T=20e-6;%脉冲周期
t=10e-5:10e-5:10;%时间向量
Vm=300;%弹速
Vt=240;%目标速度
l=5000;%相对距离
h=1500;%相对高度
beit=150/180*pi;%弹幕交会角
f0=100e6;%载波频率
Ut=100;%振幅
fai=pi/18;%初始相位
omig0=2*pi*f0;
c=3e8;%光速
Vr=sqrt(Vm^2+Vt^2-2*Vm*Vt*cos(beit));%相对速度
a=asin(Vt/Vr*sin(beit));
l1=l-Vm.*t*cos(30/180*pi)-Vt*t;
l2=h-Vm.*t*sin(30/180*pi);
R=sqrt(l1.^2+l2.^2);%弹目距离
gama=atan(l2/l1);
sit=30/180*pi-a-gama;
VR=Vr*cos(sit);
ut=Ut*cos(omig0.*t+fai);%发射信号
T=20e-3;x=(square(2*(1/T)*pi*t,50)+1)./2;
ut=ut.*x;
lanmt0=c/f0;
Fd=2.*VR/lanmt0;%多普勒频率
omigd=2*pi.*Fd;%回波信号
ur=Ut./(R.^2).*cos((omig0+omigd).*t+fai);
x=(square(2*(1/T)*pi*(t-5e-3),50)+1)./2;
ur=ur.*x;
figure;plot(t,R);title('弹目距离');
% figure;plot();
figure;plot(t,ur);title('回波信号');
xlim([9 10]);
ux=ur.*ut;
figure;plot(t,ux);title('混频信号');
xlim([9.8 10]);

%% 频谱
fs=1e9; %采样频率
Ndata=1e5; %数据长度
N=1024; %FFT的数据长度
n=0:Ndata-1;t=n/fs; %数据对应的时间序列
x1=Ut*cos(omig0.*t+fai);
x2=Ut./(R.^2).*cos((omig0+omigd).*t+fai);
x3=x1.*x2; %时间域信号

y=fft(x1,N); %信号的Fourier变换
mag=abs(y); %求取振幅
f=(0:N-1)*fs/N; %真实频率
figure;
plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前的振幅
xlabel('频率/Hz');ylabel('振幅');title('发射频谱');

y=fft(x2,N); %信号的Fourier变换
mag=abs(y); %求取振幅
f=(0:N-1)*fs/N; %真实频率
figure;
plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前的振幅
xlabel('频率/Hz');ylabel('振幅');title('回波频谱');

y=fft(x3,N); %信号的Fourier变换
mag=abs(y); %求取振幅
f=(0:N-1)*fs/N; %真实频率
figure;
plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前的振幅
xlabel('频率/Hz');ylabel('振幅');title('混频频谱');

%% 包络检波
t=10e-5:10e-5:10;
env = -abs(hilbert(ux));
env = -abs(hilbert(env));
env = -abs(hilbert(env));
env = -abs(hilbert(env));
env = -abs(hilbert(env));
figure;plot(t,env);title('包络检波')
xlim([9 10]);

%% 执行级启动 
i=1:length(R);
out=double(R(i)<=30);
figure;plot(t,out);title('执行启动门限');
xlim([9 10]);
Uo=min(out.*ux);
disp(['启动幅值',num2str(Uo)]);
