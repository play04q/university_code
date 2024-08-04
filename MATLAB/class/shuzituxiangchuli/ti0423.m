addpath("img\");
%% 原图为1000*1000大小黑色，中间为300*50白色区域:
% 读图，画出傅里叶变换结果，并将原点移到中心点;
% 2将原图平移，观察频谱图，验证平移性
clear;clc;clf;
X=zeros(1000,1000);
K=300;L=50;
R=150;%向右平移距离
X([(1000-K)/2:(1000-K)/2+K-1],[(1000-L)/2:(1000-L)/2+L-1])=1;
subplot(221);imshow(X);title('原图');
Y=fftshift(abs(fft2(X)));
subplot(222);imshow(Y);title('原图傅里叶变换');
X=zeros(1000,1000);
X([(1000-K)/2:(1000-K)/2+K-1],[(1000-L)/2+R:(1000-L)/2+L-1+R])=1;
subplot(223);imshow(X);title('原图向右米平移');
subplot(224);imshow(fftshift(abs(fft2(X))));title('向右平移傅里叶变换');

%% L=?同上
clear;clc;clf;
X=zeros(1000,1000);
K=300;L=300;
R=150;%向右平移距离农
X([(1000-K)/2:(1000-K)/2+K-1],[(1000-L)/2:(1000-L)/2+L-1])=1;
subplot(221);imshow(X);title('原图');
Y=fftshift(abs(fft2(X)));
subplot(222);imshow(Y);title('原图傅里叶变换');
X=zeros(1000,1000);
X([(1000-K)/2:(1000-K)/2+K-1],[(1000-L)/2+R:(1000-L)/2+L-1+R])=1;
subplot(223);imshow(X);title('原图向右米平移');
subplot(224);imshow(fftshift(abs(fft2(X))));title('向右平移傅里叶变换');

%% 读彩图，变灰度图，离散余弦变换，将小于0.1点置零，离散余弦逆，重构.
clc;clear;clf;
X1=imread('125.png');
figure(1);
imshow(X1);
X=rgb2gray(X1);
figure(2);
imshow(X);title('原图像');
D=dct2(X);
Y=log(abs(D));
figure(3);
imshow(Y);title('离散余弦变换结果');
D(abs(D)<0.1)=0;
I=idct2(D)/255;
figure(4);
imshow(I);title('压缩后图像');

%% 小波分析练习1 压缩图像
clear;clc;clf;%清屏
X1=imread('125.png');%读图
subplot(221);
imshow(X1);%展示图象
title('原图像')%图像命名
X=rgb2gray(X1);
subplot(222)
imshow(X);%展示图象
title('灰度图像')%图像命名
axis square;
disp('压缩图像x的大小');
whos('X');
[c,s]=wavedec2(X,2,'bior3.7');% 对图像用小波进行层分解
ca1=appcoef2(c,s,'bior3.7');% 提取小波分解结构中的一层的低频系数和高频系数
ch1=detcoef2('h',c,s,1);%水平方向
cv1=detcoef2('v',c,s,1);%垂直方向
cd1=detcoef2('d',c,s,1);%斜线方向
subplot(223);
imshow(X);%展示图象
title('压缩图像');%图像命名

%% 附加1L=?画圆
clear; clc; clf;% 初始化一个全零矩阵
X = zeros(1000, 1000);% 圆的参数
radius = 250; % 圆的半径
center_x = 500; % 圆心的 x 坐标
center_y = 500; % 圆心的 y 坐标
% 使用圆的参数方程填充矩阵中圆的区域
for i = 1:1000
    for j = 1:1000
        if sqrt((i - center_x)^2 + (j - center_y)^2) <= radius
            X(i,j) = 1;
        end
    end
end
% 显示结果
subplot(221);
imshow(X);
title('圆形图案');
Y=fftshift(abs(fft2(X)));
subplot(222);imshow(Y);title('原图傅里叶变换');
% %%%平移
X1 = zeros(1000, 1000);
radius = 250; % 圆的半径
center_x2 = 750; % 圆心的 x 坐标
center_y = 500; % 圆心的 y 坐标
for i = 1:1000
    for j = 1:1000
        if sqrt((i - center_x2)^2 + (j - center_y)^2) <= radius
            X1(i,j) = 1;
        end
    end
end
% 显示结果
subplot(223);
imshow(X1);
title('圆形图案');
Y=fftshift(abs(fft2(X)));
subplot(224);imshow(Y);title('原图傅里叶变换');

%% 附加2 一层套一层
untitled
