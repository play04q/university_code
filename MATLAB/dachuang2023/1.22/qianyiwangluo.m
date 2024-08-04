function qianyiwangluo(x)
%迁移网络图像识别，（）中填文件名带引号
    net=evalin("base",' trainedNetwork_1');
    I= imread(x);
    I = imresize(I, [227 227]);
    [YPred,probs] = classify(net,I);
    imshow(I)
    label = YPred;
    title(string(label) + ", " + num2str(100*max(probs),3) + "%");
end