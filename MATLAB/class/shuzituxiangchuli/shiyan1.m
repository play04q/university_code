clc;clf;clear;close all;addpath("img\")
%% 灰度
sy1=imread('shiyan1.jpg');sy1=im2gray(sy1);
sy2=imread('shiyan2.jpg');sy2=im2gray(sy2);
sy3=imread('shiyan3.jpg');sy3=im2gray(sy3);
sy4=imread('shiyan4.jpg');sy4=im2gray(sy4);
%% 进行二维傅里叶变换，画出原始频谱图和原点移到中心频谱
figure;
subplot(4,3,1);
imshow(sy1);title('原始图像');
Y=log(abs(fft2(sy1)));
subplot(4,3,2);imshow(Y,[]);title('无平移傅里叶变换');
Z=fftshift(Y);subplot(4,3,3);
imshow(Z,[]);title('原点移到中心傅里叶变换');

subplot(4,3,4);
imshow(sy2);title('原始图像');
Y=log(abs(fft2(sy2)));
subplot(4,3,5);imshow(Y,[]);title('无平移傅里叶变换');
Z=fftshift(Y);subplot(4,3,6);
imshow(Z,[]);title('原点移到中心傅里叶变换');

subplot(4,3,7);
imshow(sy3);title('原始图像');
Y=log(abs(fft2(sy3)));
subplot(4,3,8);imshow(Y,[]);title('无平移傅里叶变换');
Z=fftshift(Y);subplot(4,3,9);
imshow(Z,[]);title('原点移到中心傅里叶变换');

subplot(4,3,10);
imshow(sy4);title('原始图像');
Y=log(abs(fft2(sy4)));
subplot(4,3,11);imshow(Y,[]);title('无平移傅里叶变换');
Z=fftshift(Y);subplot(4,3,12);
imshow(Z,[]);title('原点移到中心傅里叶变换');

%% 直方图均衡化
figure;
subplot(4,4,1);imshow(sy1);%展示图象
title('原始图像');%图像命名
J=histeq(sy1);
subplot(4,4,2);imshow(sy1);%展示图象
title('均衡后的图片');%图像命名
subplot(4,4,3);imhist(sy1,64);%定义图象
title('原始图像的直方图');%图像命名
subplot(4,4,4);imhist(J);%定义图象
title('均衡后图像的直方图');%图像命名

subplot(4,4,5);imshow(sy2);%展示图象
title('原始图像');%图像命名
J=histeq(sy2);
subplot(4,4,6);imshow(sy2);%展示图象
title('均衡后的图片');%图像命名
subplot(4,4,7);imhist(sy2,64);%定义图象
title('原始图像的直方图');%图像命名
subplot(4,4,8);imhist(J);%定义图象
title('均衡后图像的直方图');%图像命名 

% subplot(4,4,9);imshow(sy3);%展示图象
% title('原始图像');%图像命名
% J=histeq(sy3);
% subplot(4,4,10);imshow(sy3);%展示图象
% title('均衡后的图片');%图像命名
% subplot(4,4,11);imhist(sy3,64);%定义图象
% title('原始图像的直方图');%图像命名
% subplot(4,4,12);imhist(J);%定义图象
% title('均衡后图像的直方图');%图像命名
% 
% subplot(4,4,13);imshow(sy4);%展示图象
% title('原始图像');%图像命名
% J=histeq(sy1);
% subplot(4,4,14);imshow(sy4);%展示图象
% title('均衡后的图片');%图像命名
% subplot(4,4,15);imhist(sy4,64);%定义图象
% title('原始图像的直方图');%图像命名
% subplot(4,4,16);imhist(J);%定义图象
% title('均衡后图像的直方图');%图像命名
% 
% %% 线性增加亮度的图像和直方图
% figure;
% subplot(4,4,1);
% I1=im2double(sy1);
% I3=I1+55/255;
% imshow(I1);%展示图象
% subplot(4,4,2);
% imshow(I3);
% title('线性增加亮度图像');%图像命名
% subplot(4,4,3);imhist(I1,64);%定义图象
% title('I1直方图');%图像命名
% subplot(4,4,4);imhist(I3,64);%定义图象
% title('I3直方图');%图像命名
% 
% subplot(4,4,5);
% I1=im2double(sy2);
% I3=I1+55/255;
% imshow(I1);%展示图象
% subplot(4,4,6);
% imshow(I3);
% title('线性增加亮度图像');%图像命名
% subplot(4,4,7);imhist(I1,64);%定义图象
% title('I1直方图');%图像命名
% subplot(4,4,8);imhist(I3,64);%定义图象
% title('I3直方图');%图像命名

subplot(4,4,9);
I1=im2double(sy3);
I3=I1+55/255;
imshow(I1);%展示图象
subplot(4,4,10);
imshow(I3);
title('线性增加亮度图像');%图像命名
subplot(4,4,11);imhist(I1,64);%定义图象
title('I1直方图');%图像命名
subplot(4,4,12);imhist(I3,64);%定义图象
title('I3直方图');%图像命名

subplot(4,4,13);
I1=im2double(sy4);
I3=I1+55/255;
imshow(I1);%展示图象
subplot(4,4,14);
imshow(I3);
title('线性增加亮度图像');%图像命名
subplot(4,4,15);imhist(I1,64);%定义图象
title('I1直方图');%图像命名
subplot(4,4,16);imhist(I3,64);%定义图象
title('I3直方图');%图像命名
