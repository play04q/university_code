clc;clear;close all;
x = 1:0.5:20;
y1 = exp(sin(x)+cos(x));
y2 = sin(x)+cos(x);
y3 = sin(cos(x));
% 获取figure句柄，fig只是变量名，可任意定义
fig = figure;
plot(x,y1,x,y2,x,y3);
xlabel('X Axis');
ylabel('Y Axis');
title('plotHub TEST');
% 将figure句柄传递给PlotHub
plotHub(fig);