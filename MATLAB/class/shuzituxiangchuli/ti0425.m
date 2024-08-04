addpath("img\");
%% 调整RGB图像对比度
clear;clc;clf;close all%清屏
RGB1 = imread('125.png');
RGB2 = imadjust(RGB1,[.2 .3 0; .6 .7 1],[ ]);
figure; imshow(RGB1);
figure; imshow(RGB2);

%% 图像求反
I=imread('123.bmp');%读图
J=imadjust(I,[0 1],[1 0]);
figure;
subplot(121);imshow(I);%展示图像
title('原始图像');%图像命名
subplot(122);imshow(J);%展示图像

%% 直方图均衡化
clear;clc;clf;%清屏
X=imread('123.png');%读图
I=rgb2gray(X);
subplot(2,2,1);imshow(I);%展示图象
title('原始图像');%图像命名
J=histeq(I);
subplot(2,2,2);imshow(I);%展示图象
title('均衡后的图片');%图像命名
subplot(2,2,3);imhist(I,64);%定义图象
title('原始图像的直方图');%图像命名
subplot(2,2,4);imhist(J);%定义图象
title('均衡后图像的直方图');%图像命名

%% 归一化直方图
I=imread('123.png');
figure;
[M,N]=size(I);
[counts,x]=imhist(I,32);
counts=counts/M/N;
stem(x, counts);

%% 线性增加亮度的图像和直方图
clear;clc;clf;%清屏
X=imread('125.png');%读图
I=rgb2gray(X);
subplot(2,2,1);
I1=im2double(I);
I3=I1+55/255;
imshow(I1);%展示图象
subplot(2,2,2);
imshow(I3);
title('线性增加亮度图像');%图像命名
subplot(2,2,3);imhist(I1,64);%定义图象
title('I1直方图');%图像命名
subplot(2,2,4);imhist(I3,64);%定义图象
title('I3直方图');%图像命名
