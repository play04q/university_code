clc;clf;clear;close all;addpath('img\');
%% 模拟运动图像(模糊)
I=imread('126.jpg');% 读入图像
figure;
subplot(1,2,1);imshow(I);
title('原始图像');
LEN =30;%模糊长度
THETA =10;%模糊角度
PSF =fspecial('motion',LEN,THETA);% 生成点扩散函数染 
Blurred =imfilter(I,PSF,'circular','conv');%图像卷积计算
subplot(1,2,2);imshow(Blurred);
title('图像卷积运算效果');

%% 维纳滤波进行图像复原
clear;
I=im2double(imread('126.jpg'));
figure;
subplot(2,2,1);imshow(I);
title('Original lmage');
LEN = 20;THETA =10;%设置模糊长度为20，模糊角度为10
PSF =fspecial('motion', LEN, THETA);%产生点扩散函数
blurred =imfilter(I, PSF,'conv','circular');%得到模拟运动图像
subplot(2,2,2), imshow(blurred); title('blurred lmage');
noise_mean=0;noise_var= 0.0001;%设置噪声的均值为0，方差为0.0001
blurred_noisy= imnoise(blurred, 'gaussian',noise_mean,noise_var);%运动图像加噪
subplot(2,2,3);imshow(blurred_noisy);
title('Simulate Blur and Noise');
estimated_nsr= noise_var /var(I(:));%估计噪声功率谱比（NSR）
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);%使用维纳滤波对添加了噪声的模糊图像进行复原
subplot(2,2,4),imshow(wnr3);
title('Noisylmage Using Estimated NSR');

%% 最大值滤波，最小值滤波
clc;clear;close all;
J=imread('125.png');
J=im2gray(J);
subplot(1,3,1);
imshow(J,[]);title('原图像');
N=3;
J2=ordfilt2(J,N*N,true(N));% 最大值滤波
subplot(1,3,2);
imshow(J2,[]);title('最大值滤波图像');
J3=ordfilt2(J,1,true(N));
subplot(1,3,3)
imshow(J3,[]);title('最小值滤波图像');

%% 加噪声，最大值滤波，最小值滤波，中值滤波
clc;clear;close all;
J=imread('126.jpg');
J=im2gray(J);
J=imnoise(J,'salt & pepper',0.01);
figure;
subplot(221);imshow(J,[]);
title('椒盐噪声图像');
N=3;
J1=medfilt2(J,[N,N]);
subplot(222);imshow(J1,[]);
title('中值滤波');
subplot(223)
J2=ordfilt2(J,N*N,true(N));% 最大值滤波
imshow(J2,[]);title('最大值滤波图像');
subplot(224)
J3=ordfilt2(J,1,true(N));
imshow(J3,[]);title('最小值滤波图像');
