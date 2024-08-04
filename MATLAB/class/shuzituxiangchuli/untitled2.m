%画骨架
I = imread('123.bmp');
I=im2gray(I);%图像灰度化
figure;imshow(I)
title('原始图像')
%骨架化二值图像：为了使原始图像适合于骨架化，对图像进行反转，以使对象变亮而背景变暗。 然后，将结果图像二值化。
Icomplement = imcomplement(I);
BW = imbinarize(Icomplement);
figure;imshow(BW)
title('二值图像');
out = bwskel(BW);
figure;imshow(out)
title('骨架图像1');
out2 = bwskel(BW,'MinBranchLength',50);
figure;imshow(out2)
title('骨架图像2','FontSize',14);
bw_skel=bwmorph(BW,'skel',Inf);
figure;imshow(bw_skel)
title('骨架图像3','FontSize',14);
% result1 = bwmorph(BW,'thin',10);
result2 = bwmorph(BW,'thin',Inf);
figure;
imshow(result2)
title('骨架图像4','FontSize',14)