%% 设置输入文件夹和输出文件夹的路径
inputDirectory = 'img\shendu\F18';
outputDirectory = 'img\shendusqu\F18';
% 获取输入文件夹下的所有图像文件
inputFiles = dir(fullfile(inputDirectory, '*.jpg')); % 可根据实际情况修改文件扩展名
% 定义目标大小
outputSize = [227, 227];
% 遍历每个图像文件并调整大小
for i = 1:numel(inputFiles)
    % 读取图像
    inputImage = imread(fullfile(inputDirectory, inputFiles(i).name));
    % 调整图像大小
    resizedImage = imresize(inputImage, outputSize);
    % 构造新文件名
    [~, baseFileName, ext] = fileparts(inputFiles(i).name);
    newFileName = [baseFileName, 'f18', ext];
    % 保存调整大小后的图像到输出文件夹
    imwrite(resizedImage, fullfile(outputDirectory, newFileName));
end

%% 
deepNetworkDesigner;%打开深度网络设计器，替换并修改最后一个学习层，替换输出层
%导入数据，设置参数，开始训练
%保存网络

%% 飞机
load('squ76.mat');%加载训练好的网络
I= imread("img\shibie1.jpeg");%加载识别的图片
I = imresize(I, [227 227]);%设置图片大小
[YPred,probs] = classify(trainedNetwork_1,I);%将图片放在网络中识别，并计算准确率
figure;imshow(I)%图窗打印图片
label = YPred;
title(string(label) + ", " + num2str(100*max(probs),3) + "%");
