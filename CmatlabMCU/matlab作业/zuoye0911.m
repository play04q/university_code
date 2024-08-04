%% 
clf;clear;clc;

%% 2
x=0:0.001:3;
y1=x.^2;
y2=x.^(1/3);
plot(x,y1,'b');
hold on;
plot(x,y2,'r');

%% 5
d=[9;12;15;25;8];
p=d/sum(d);
e=[0.2;0;0;0;0];
pie(p,e);

%% 7
x=rand(1000);
bar(x);
