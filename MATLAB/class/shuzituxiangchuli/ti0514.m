clc;clf;clear;close all;addpath('img\');
%% 区域分割法
I=imread('125.png'); %读取图片
subplot(221);imshow(I);title('原图');
f=im2double(I);%数据类型转换
T=0.5*(min(f(:))+max(f(:)));
done=false;
while ~done
    g=f>=T;
    Tn=0.5*(mean(f(g))+mean(f(~g)));
    done = abs(T-Tn)<0.1;
    T=Tn;
end
disp('Threshold(T)-Iterative');%显示文字
 T
 r=im2bw(f,T);
 subplot(222);imshow(r);title('全局阈值分割');
 Th=graythresh(f);%阈值
disp('Global Thresholding- Otsu''s Method');
Th
s=im2bw(f,Th);
se=strel('disk',10);
ft=imtophat(f,se);
Thr=graythresh(ft);
disp('Threshold(T)-Local Thresholding');
Thr
I1 = im2bw(ft,Thr);
subplot(223);imshow(I1);title('局部阈值分割');

%% 边缘检测
% 读取图像
I = imread('125.png'); 
% 转换为灰度图像
I1 = rgb2gray(I);
% 使用函数进行边缘检测
threshold = [0.1, 0.2]; % 阈值范围，自动计算
edgec = edge(I1, 'Canny', threshold);
edger = edge(I1, 'roberts');
edgel = edge(I1, 'log');
edgep = edge(I1, 'prewitt');
edges = edge(I1, 'sobel');
% 显示原图和边缘检测后的图像
figure;
subplot(3, 2, 1), imshow(I), title('Original Image');
subplot(3, 2, 2), imshow(edgec), title('Canny Edge Detection');
subplot(3, 2, 3), imshow(edger), title('roberts Edge Detection');
subplot(3, 2, 4), imshow(edgel), title('log Edge Detection');
subplot(3, 2, 5), imshow(edgep), title('prewitt Edge Detection');
subplot(3, 2, 6), imshow(edges), title('sobel Edge Detection');
%自己画的圈
I = imread('byjc.png'); 
I1 = rgb2gray(I);
threshold = [0.1, 0.2];
edgec = edge(I1, 'Canny', threshold);
edger = edge(I1, 'roberts');
edgel = edge(I1, 'log');
edgep = edge(I1, 'prewitt');
edges = edge(I1, 'sobel');
figure;
subplot(3, 2, 1), imshow(I), title('Original Image');
subplot(3, 2, 2), imshow(edgec), title('Canny Edge Detection');
subplot(3, 2, 3), imshow(edger), title('roberts Edge Detection');
subplot(3, 2, 4), imshow(edgel), title('log Edge Detection');
subplot(3, 2, 5), imshow(edgep), title('prewitt Edge Detection');
subplot(3, 2, 6), imshow(edges), title('sobel Edge Detection');

%% Hough
RGB = imread('125.png');
I  = im2gray(RGB);
BW = edge(I,'canny');
%计算霍夫变换
[H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89);
figure;
subplot(3,1,1);
imshow(RGB);
title('原图');
subplot(3,1,2);
imshow(imadjust(rescale(H)),'XData',T,'YData',R,'InitialMagnification','fit');
title('Hough变换后的图');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);
%计算有限角度范围内的霍夫变换
[H,T,R] = hough(BW,'Theta',44:0.5:46);
subplot(3,1,3);
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
   'InitialMagnification','fit');
title('Limited Theta Range Hough Transform of Gantrycrane Image');
xlabel('\theta')
ylabel('\rho');
axis on, axis normal;
colormap(gca,hot);

%% 一点一个不吱声
I=imread('126.jpg');
if isinteger(I)
I=im2double(I);
end
I = rgb2gray(I);
figure
imshow(I)
[M,N]=size(I);
[y,x]=getpts; %单击取点后，按enter结束
x1=round(x);
y1=round(y);
seed=I(x1,y1); %获取中心像素灰度值
J=zeros(M,N);
J(x1,y1)=1;
count=1; %待处理点个数
threshold=0.15;
while count>0
count=0;
for i=1:M %遍历整幅图像
for j=1:N
if J(i,j)==1 %点在“栈”内
if (i-1)>1&(i+1)<M&(j-1)>1&(j+1)<N %3*3邻域在图像范围内
for u=-1:1 %8-邻域生长
for v=-1:1
if J(i+u,j+v)==0&abs(I(i+u,j+v)-seed)<=threshold
J(i+u,j+v)=1;
count=count+1; %记录此次新生长的点个数
end
end
end
end
end
end
end
end
subplot(1,2,1),imshow(I);
title('original image');
subplot(1,2,2),imshow(J);
title('segmented image');
