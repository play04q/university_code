addpath("img\");
%% 灰度
img=imread('123.png');
img2=rgb2gray(img);
imwrite(img2,'123.bmp');

%% 1.读图，进行二维傅里叶变换，画出原始频谱图
clear;clc;clf;
X=imread('123.bmp');
subplot(121)
imshow(X);
title('原始图像');
Y=log(abs(fft2(X)));
subplot(122);
imshow(Y,[0 14]);
title('无平移傅里叶变换');

%% 2.读图，进行二维傅里叶变换，画出原始频谱图和原点移到中心频谱(原图较柔和)
clear;clc;clf;
X=imread('123.bmp');
subplot(131);
imshow(X);title('原始图像');
Y=log(abs(fft2(X)));
subplot(132);imshow(Y,[]);title('无平移傅里叶变换');
Z=fftshift(Y);subplot(133);
imshow(Z,[]);title('原点移到中心傅里叶变换');

%% 第二章1
clear;clc;clf;
x='124.bmp';
fid=fopen(x);
m=512; n=256;
y=fread(fid,[m,n]);
y=rot90(y);
imagesc(y(:,[60:310]))
colormap(gray);

%% 第二章2
clear;clc;clf;
X='124.bmp';
fid=fopen(X);
m=512;n=256;
y=fread(fid,[m,n]);
fclose(fid);
imagesc(y)


%% 第二章3
clear;clc;clf;
x='124.bmp';
fid=fopen(x);
m=512; n=256;
y=fread(fid,[m,n]);
fclose(fid);
imagesc(y);

