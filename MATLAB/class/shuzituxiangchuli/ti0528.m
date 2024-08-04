clc;clf;clear;close all;addpath('img\');
%% 图像均值
% 均值反映了图像的亮度,均值越大说明图像亮度越大,反之越小
I=imread('125.png');
J=rgb2gray(I);
% 当定义一个MATLAB函数,中间一行代码如果结尾不加分号,MATLAB会把这行代码的值直接输出到命令行窗口
% 对于灰度图像(二维矩阵),mean2()函数计算图像的平均灰度值
gary=mean2(J);
% 对于彩色图像(三维矩阵),mean2()可以得到所有颜色值的平均值(即(r+g+b)/3)
rgb=mean2(I);
% 可以使用mean2(I(:,:,1))、mean2(I(:,:,2))、mean2(I(:,:,3))分别计算彩色图像每种颜色的平均值
r=mean2(I(:,:,1));
g=mean2(I(:,:,2));
b=mean2(I(:,:,3));
figure;
subplot(121),imshow(I);
subplot(122),imshow(J);
disp(['gary=',num2str(gary)]);
disp(['rgb=',num2str(rgb)]);
disp(['r=',num2str(r)]);
disp(['g=',num2str(g)]);
disp(['b=',num2str(b)]);

%% 方差
% std()可计算向量的标准差,std2()可计算矩阵的标准差,标准差的平方是方差
I=imread('125.png');
s1=(std2(I))^2;
J=histeq(I);
s2=(std2(J))^2;
% 注意s2>s1,标准差反映了图像像素值与均值的离散程度,标准差越大说明图像的质量越好
figure;
subplot(221),imshow(I);
subplot(222),imshow(J);
subplot(223),imhist(I);
title('原图的灰度直方图');
subplot(224),imhist(J);
title('均衡化后的灰度直方图');
disp(['s1=',num2str(s1)]);
disp(['s2=',num2str(s2)]);

%% 图像峰度
% 读取图像
I = imread('125.png'); 
% 如果图像是灰度图像，先转换成双精度类型
if size(I, 3) == 1
    I = double(I);
else
    % 如果图像是彩色图像，先转换成灰度图像
    I = rgb2gray(I);
end 
% 计算梯度
[Gx, Gy] = imgradient(I); 
% 计算峰度特征
peaks = sqrt(Gx.^2 + Gy.^2); 
% 如果需要可视化峰度特征，可以使用imshow显示
figure;
imshow(peaks, []);
colorbar; 
% 如果需要输出最大峰度值
[maxPeak, ~] = max(peaks(:));
disp(['maxPeak=',num2str(maxPeak)]);

%% 熵 
clc;clf;close all;clear;warning off;%清除变量
% 读取图像
lena_img = imread('125.png'); 
% 如果是彩色图像，则转换为灰度图像
if size(lena_img, 3) == 3
    lena_img = rgb2gray(lena_img);
end
% 计算灰度直方图
[counts, gray_levels] = imhist(lena_img); 
% 计算每个灰度级的概率
total_pixels = sum(counts);
probabilities = counts / total_pixels; 
% 计算信息熵
entropy = 0;
for i = 1:length(probabilities)
    if probabilities(i) > 0
        entropy = entropy - probabilities(i) * log2(probabilities(i));
    end
end 
% 显示信息熵
disp(['信息熵为: ', num2str(entropy)]); 
% 显示原图和加密后的图像
figure;
subplot(1, 2, 1);
imshow(uint8(lena_img));
title('原图');
subplot(1, 2, 2);
imhist(lena_img);
title('灰度直方图');

%% 纹理特征
%提取图像的lbp特征值--普通
r=1;
picture=rgb2gray(imread('126.bmp'));
x=size(picture,1);
y=size(picture,2);
texture=uint8(zeros(x,y));
for i=2:1:x-1
    for j=2:1:y-1
        neighbor=uint8(zeros(1,8));
        neighbor(1,1)=picture(i-1,j);
        neighbor(1,2)=picture(i-1,j+1);
        neighbor(1,3)=picture(i,j+1);
        neighbor(1,4)=picture(i+1,j+1);
        neighbor(1,5)=picture(i+1,j);
        neighbor(1,6)=picture(i+1,j-1);
        neighbor(1,7)=picture(i,j-1);
         neighbor(1,8)=picture(i-1,j-1);
        center=picture(i,j);
        temp=uint8(0);
        for k=1:r:8
             temp =temp+ (neighbor(1,k) >= center)* 2^(k-1);
        end
        texture(i,j)=temp;  
    end
end
figure;
subplot(1,2,1);imshow(picture);title('原图');
subplot(1,2,2);imshow(texture);title('纹理后图');

