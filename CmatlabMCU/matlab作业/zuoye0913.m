%% 
clear;clc;

%%  1
p1=[0,1,1];
p2=[1,-3,1];
he=p1+p2
cha=p1-p2
ji=conv(p1,p2)
[shan,yu]=deconv(p1,p2)
r1=roots(p1)
r2=roots(p2)

%%  6
syms x;
y=(x^2+x)^(1/2)-(x^2-x)^(1/2);
limit(y,inf)

%%  9
dsolve('D2y+4*Dy+4*y-e^(-2*x)=0','x')

%%  11
syms n x;
y=(-1)^(x+1)*(1/x);
symsum(y,x,1,n)
