clc;clear;clf;close all;
%飞机，预训练网络识别
% unzip('MerchData.zip');
% imageDatastore 根据文件夹名称自动标注图像，并将数据存储为 ImageDatastore 对象。
% 通过图像数据存储可以存储大图像数据，包括无法放入内存的数据。
% 将数据拆分，其中 80% 用作训练数据，20% 用作测试数据。
imds = imageDatastore('img\shendusqu\','IncludeSubfolders',true,'LabelSource','foldernames');
[imdsTrain,imdsTest] = splitEachLabel(imds,0.8,'randomized');
numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,16);
% 显示一些示例图像
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
end
% 加载预训练的网络
net = squeezenet;
inputSize = net.Layers(1).InputSize;
% analyzeNetwork(net);
% 要在将训练图像和测试图像输入到网络之前自动调整它们的大小，请创建增强的图像数据存储，指定所需的图像大小，并将这些数据存储用作 activations 的输入参量
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
layer = 'pool5';
featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
whos featuresTrain;
YTrain = imdsTrain.Labels;
YTest = imdsTest.Labels;
classifier = fitcecoc(featuresTrain,YTrain);
YPred = predict(classifier,featuresTest);
% 显示示例测试图像及预测的标签。
idx = [3 6 12 7];
figure
for i = 1:numel(idx)
    subplot(2,2,i)
    I = readimage(imdsTest,idx(i));
    label = YPred(idx(i));
    imshow(I)
    title(char(label))
end
accuracy = mean(YPred == YTest);
disp(['准确率为',num2str(accuracy)]);