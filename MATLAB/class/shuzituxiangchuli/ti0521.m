clc;clf;clear;close all;addpath('img\');
%% 区域生长法
I=imread('129.jpeg');
if isinteger(I)
    I=im2double(I);
end
I=im2gray(I);
figure;
imshow(I)
[M,N]=size(I);
[y,x]=getpts;
x1=round(x);y1=round(y);
seed=I(x1,y1);
J=zeros(M,N);
J(x1,y1)=1;
count=1;
threshold=0.15;
while count>0
    count=0;
    for i=1:M
        for j=1:N
            if J(i,j)==1
                if(i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N
                    for u=-1:1
                        for v=-1:1
                            if J(i+u,j+v)==0&&abs(I(i+u,j+v)-seed)<=threshold
                                J(i+u,j+v)=1;
                                count=count+1;
                            end
                        end
                    end
                end
            end
        end
    end
end
subplot(1,2,1);
imshow(I);title('origimal image');
subplot(1,2,2);
imshow(J);title('segmented image');

%% 基于骨架描述
clc;clear;
I = imread('xhz.jpg');
I=im2gray(I);%图像灰度化
figure;
subplot(2,2,1);imshow(I)
title('原始图像')
%骨架化二值图像：为了使原始图像适合于骨架化，对图像进行反转，以使对象变亮而背景变暗。 然后，将结果图像二值化。
Icomplement = imcomplement(I);
BW = imbinarize(Icomplement);
subplot(2,2,2);imshow(BW)
title('二值图像');
%使用bwmorph的‘skel’参数进行二值图像的骨架化，可以看到有许多的毛刺
bw_skel=bwmorph(BW,'skel',Inf);
subplot(2,2,3);imshow(bw_skel)
title('skel骨架图像');
%使用bwmorph的‘thin’参数进行二值图像的骨架化
% result1 = bwmorph(BW,'thin',10);
result2 = bwmorph(BW,'thin',Inf);
subplot(2,2,4);imshow(result2)
title('thin骨架图像');
