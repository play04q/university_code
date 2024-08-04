%% 
clc;clf;clear;close all;

%% 
help sum

%% 
a=[1 2 3;4 5 6;7 8 9]
a1=[1:9]
a1(1,4,:)
a2=zeros(1,5)

A1=a(8)
a(8)=18
A2=a(2,3)
%% 
a=[2 1 5 1;1 -3 0 -6;0 2 -1 2;1 4 -7 6];
b=[8;9;-5;0];
x=a\b

%% 
a=[1 1 1 1;1 2 -1 4;2 -3 -1 -5;3 1 2 11];
b=[5;-2;-2;0];
x=a\b

%% 
a=[1 2 1 0;0 1 0 1;0 0 0 2;0 0 0 3];
b=[1 2 5 2;0 1 2 -4;0 0 -4 3;0 0 0 9];
x=a\b

%% 
a=[1 2;3 4];b=[1 0;1 0];
a1=a./b
a2=b.\a
a3=a.\b
a4=b./a

%% 
a=[1+i 2+2i 3+3i];
a1=real(a)
a2=imag(a)
a3=abs(a)
a4=angle(a)

%% 
b1=fix(0.1) ;
b2=fix(-0.1);
b3=fix(0.9);
b4=fix(-0.9);
b5=fix(2.01);
b6=fix(-2.01);
b7=ceil(0.1);
b8=ceil(-0.1);
b9=ceil(0.9);
b10=ceil(-0.9);
b11=ceil(2.01);
b12=ceil(-2.01);
b13=floor(0.1);
b14=floor(-0.1);
b15=floor(0.9);
b16=floor(-0.9);
b17=floor(2.01);
b18=floor(-2.01);
b19=round(0.1);
b20=round(-0.1);
b21=round(0.9);
b22=round(-0.9);
b23=round(2.01);
b24=round(-2.01);
B=[b1 b2 b3 b4 b5 b6;b7 b8 b9 b10 b11 b12;b13 b14 b15 b16 b17 b18;b19 b20 b21 b22 b23 b24]

%% 
c1=mod(-16,3)
c2=rem(-16,3)

%% 
t=(0:0.01:1)*2*pi;
y1=sin(t);
y2=sint(t).*sin(t);

%% 
a=exp(4)
b=pow2(10)
c=log10(10)

%% 
a=rand(1,10);
r1=(a>5)&(a<0.8);
r2=find((a>5)&(a<0.8));
r3=~r1;
x=all([1 1 0;1 0 0;1 1 0])
