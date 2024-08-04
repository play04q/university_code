clc;clf;clear;close all;addpath('img\');
%% jpg
% 假设您已经有一个名为image的变量，包含了要压缩的图像数据
image = imread('123.bmp'); %加载或生成图像数据
% 设置压缩质量，范围从0（最差质量）到100（最佳质量），通常默认值是95
quality = 95;
% 使用imwrite函数将图像保存为JPG格式，同时设置质量参数
filename = 'output.jpg'; % 输出文件名
imwrite(image, filename, 'Quality', quality);

%% 哈达玛变换
close all;
clear all;
clc;
I=imread('123.bmp');%图像大小1080×1080
% I=rgb2gray(I);       %彩色转灰度图
I=double(I)/255;     %图像为256级灰度图，对图像进行归一化操作
[M,N]=size(I);
%设置压缩比cr
cr=0.125;              %cr=0.5为2:1压缩，cr=0.125为8:1压缩
%对图像进行哈达玛变换
t=hadamard(8);          %产生8×8的哈达玛矩阵
htCoe=blkproc(I,[8 8],'P1*x*P2',t,t);
coevar=im2col(htCoe,[8 8],'distinct');
coe=coevar;
[y,ind]=sort(coevar);
[m,n]=size(coevar);
% 舍去不重要的系数
snum=64-64*cr;
for i=1:n
    coe(ind(1:snum),i)=0;       %将最小的snum个变换系数清零
end
b2=col2im(coe,[8 8],[M N],'distinct');%重新排列系数矩阵
%对截取后的变换系数进行哈达玛逆变换
I2=blkproc(b2,[8 8],'P1*x*P2',t,t);
I2=I2./(8*8);
%计算均方根误差erms
e=double(I)-double(I2);
[m,n]=size(e);
erms=sqrt(sum(e(:).^2)/(m*n));
figure;
subplot(121),imshow(I),title('原图');
subplot(122),imshow(I2),title('压缩比为8:1');

