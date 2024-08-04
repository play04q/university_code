clc;clf;clear;close all;addpath('img\');
%% 为图像添加噪声
clear;clc;clf;
I=imread('126.jpg');
figure(1);imshow(I);%展示图像
title("原图");%图像命名
I1=imnoise(I,'gaussian',0.02);
figure(2);imshow(I1);%展示图象
title("高斯噪声");%图像命名
I2=imnoise(I,'salt & pepper',0.02);
figure(3);
imshow(I2);%展示图象
title("椒盐噪声");%图像命名
I3=imnoise(I,'poisson');
figure(4);
imshow(I3);%展示图象
title('泊松噪声');%图像命名

%% 平滑之平均模板法
clear,clc;
I=imread('126.jpg');
figure;
subplot(221);
imshow(I);%展示图象
title('原图');%图像命名
h=fspecial('average',3);
I1=imfilter(I,h,'corr','replicate');
subplot(222);
imshow(I1);
title('3*3');
h=fspecial('average',5);
I2=imfilter(I,h,'corr','replicate');
subplot(223)
imshow(I2);
title('5*5');
h=fspecial('average',7);
I3=imfilter(I,h,'corr','replicate');
subplot(224);
imshow(I3);
title('7*7');