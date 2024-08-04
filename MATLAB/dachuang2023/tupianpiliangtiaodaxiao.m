% 设置输入文件夹和输出文件夹的路径
inputDirectory = '';
outputDirectory = '';
% 获取输入文件夹下的所有图像文件
inputFiles = dir(fullfile(inputDirectory, '*.png')); % 可根据实际情况修改文件扩展名
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
    newFileName = [baseFileName, '', ext];
    % 保存调整大小后的图像到输出文件夹
    imwrite(resizedImage, fullfile(outputDirectory, newFileName));
end