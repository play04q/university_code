%%  
clc;clf;clear;close all;

%%  2
P1=[1 2 4 0 5];
P2=[ 0 1 2];
P3=[1 2 3];
P=P1+conv(P2,P3)
r=roots(P)

%%   3
syms y(x)
x=-1:0.01:1;
z=dsolve('5*Dy+y=1','y(0)=1','x')

%%   5
syms x f(x) y g(y);
f(x)=(1+x.^2)/(1+x.^4);
x=0:0.01:2;
min1=fminbnd(f,0,2)

g(y)=sin(y)+cos(y.^2);
y=0:0.01:pi;
min2=fminsearch(g,pi)

