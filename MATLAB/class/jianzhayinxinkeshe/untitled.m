N=2^10;
ssf=(0:N/2-1)/((1e-9)*N);
fw=abs(fft(sing(100*N:101*N)));
plot(ssf,fw(1:N/2))
% sim={simout,signals,valuse};

%% 

clc;clear;clf;close all;
%赋初值

Vm=300;                                   %弹速
Vt=240;                                   %目标速度
l=5000;                                   %初始弹目相对水平距离
h=1500;                                   %初始弹目相对垂直高度
beit=150/180*pi;                          %弹目交会角
f0=100e6;                                 %载波频率
Ut=10;                                    %幅度
fai=pi/18;                                %初相位
omig0=2*pi*f0;                            %角频率
c=3e8;                                    %光速

%计算

Vr=sqrt(Vm^2+Vt^2-2*Vm*Vt*cos(beit));     %弹目相对速度
a=asin(Vt/Vr*sin(beit));                  %弹速矢量与相对速度矢量的夹角
t=1e-4:1e-4:10;                           %仿真时间
t1=1e-9:1e-9:1e-4;                        %用于模拟回波信号的压缩时间
l1=l-Vm.*t*cos(30/180*pi)-Vt.*t;          %t时刻弹目相对水平距离
l2=h-Vm.*t*sin(30/180*pi);                %t时刻弹目相对垂直高度
R=sqrt(l1.^2+l2.^2);                      %弹目距离
gama=atan(l2./l1);
sit=30/180*pi-a-gama;                     %弹目连线与相对弹道的夹角
VR=Vr.*cos(sit);                          %弹目接近速度
ut=Ut.*cos(omig0.*t+fai);                 %发射信号
lanmt0=c/f0;                              %波长
Fd=2.*VR/lanmt0;                          %多普勒频率
omigd=2*pi.*Fd;                           %角频率
u=Ut./(R.^2).*cos((omig0+omigd).*t1+fai); %回波信号

% figure;plot(t,u);
huibo=[t1;u]';

% %绘图
% 
% figure(1);
% plot(t,R);
% title(' ');
% xlabel('t(s)');
% ylabel('R(m)');
% figure(2);
% plot(t,Fd);
% title(' ');
% xlabel('t(s)');
% ylabel('fd(Hz)');
% axis([9.8 10 330 350]);
% figure(3);
% XT=l-Vt.*t;                 %目标水平位置
% YT=h.*ones(length(t),1);       %目标垂直位置
% VL=Vm.*cos(pi-beit);         %弹丸水平速度
% VH=Vm.*sin(pi-beit);         %弹丸垂直速度
% XM=VL.*t;                  %弹丸水平位置
% YM=VH.*t;                  %弹丸垂直位置
% plot(XT,YT,'--',XM,YM,'-');
% title(' ');
% xlabel('X(m)');
% ylabel('Y(m)');
% hleg1=legend('目标', '导弹', 'Location', 'Best');
% axis([0 7000 0 2000]);
% grid on
