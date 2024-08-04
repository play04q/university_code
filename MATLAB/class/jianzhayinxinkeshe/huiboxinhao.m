clear;
T=20e-6;
t=9:1e-5:10;
Vm=300;
Vt=240;
l=5000;
h=1500;
beit=150/180*pi;
f0=100e6;
Ut=100;
fai=pi/18;
omig0=2*pi*f0;
c=3e8;
Vr=sqrt(Vm^2+Vt^2-2*Vm*Vt*cos(beit));
a=asin(Vt/Vr*sin(beit));
l1=l-Vm.*t*cos(30/180*pi)-Vt*t;
l2=h-Vm.*t*sin(30/180*pi);
R=sqrt(l1.^2+l2.^2);
gama=atan(l2/l1);
sit=30/180*pi-a-gama;
VR=Vr*cos(sit);
ut=Ut*cos(omig0.*t+fai);%发射信号
x=(square(2*(1/T)*pi*t,50)+1)./2;
ut=ut.*x;
lanmt0=c/f0;
Fd=2.*VR/lanmt0;%多普勒频率
omigd=2*pi.*Fd;%回波信号
ur=Ut./(R.^2).*cos((omig0+omigd).*t+fai);
% x=(square(2*(1/T)*pi*(t-5e-3),50)+1)./2;
% ur=ur.*x;
% % figure;plot(t,R);title('弹目距离');
% figure;plot(t,ur);title('回波信号');
% % xlim([9 10]);
% ux=ur.*ut;
% figure;plot(t,ux);title('混频信号');
% % xlim([9 10]);
ts=[0:1e-9:1e-4];
huibo=[ts;ur]';
