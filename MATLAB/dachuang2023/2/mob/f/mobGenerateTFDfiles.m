function mobGenerateTFDfiles(parentDir,dataDir,wav,truth,Fs)   % wav信号数据  truth调制类型  Fs采样频率
% This function is only intended to support
% ModClassificationOfRadarAndCommSignalsExample. It may change or be
% removed in a future release.
    
[~,~,~] = mkdir(fullfile(parentDir,dataDir));  %是用来创建文件夹的。其中 parentDir 是父文件夹的路径，
                                    %dataDir 是子文件夹的名称。fullfile 函数将两个路径组合在一起形成完整的路径，
                                    %并将其作为输入传递给 mkdir 函数。此函数的输出被忽略了，因为它只是指示成功或失败。
modTypes = unique(truth);%unique 函数将返回一个包含 truth 变量中所有唯一值的向量或矩阵，
                        %并将其赋值给 modTypes
                        %变量。这个变量可以用于后续的分析或处理。modTypes结果为{'Barker','LFM','Rect'}1行3列的矩阵

for idxM = 1:length(modTypes)   %用于创建一些文件夹。其中 modTypes 是一个包含唯一值的向量或矩阵，表示数据集中所有可能的分类或标签。循环将遍历所有这些分类，并为每个分类创建一个文件夹。
    modType = modTypes(idxM);
    [~,~,~] = mkdir(fullfile(parentDir,dataDir,char(modType)));
                                                    %fullfile 函数将 parentDir、dataDir 和 modType 组合在一起形成完整路径，并将其传递给 mkdir 函数。输出被忽略了，因为它只是指示成功或失败。
end
    
for idxW = 1:length(truth)
   sig = wav{idxW};
   switch dataDir
       case 'STFT'
           %%%%%%%%%%%     STFT     %%%%%%%%%%%%%%%%%%%
           window = hamming(128);      %窗的选择
           noverlap = 120;             %重叠点数
           nfft = 2048;                   %采样点数                
           TFD = spectrogram(sig,window,noverlap,nfft,Fs);
           TFD = abs(TFD);
       case 'CWT'
           %%%%%%%%%%%%%%%     CWT   %%%%%%%%%%%%%%%%%%%%%
           TFD= cwt(real(sig),'morse',Fs/2);
           TFD = abs(TFD);
       case 'WVD'
           %%%%%%%%%%%%%%%%    WVD   %%%%%%%%%%%%%%%%%%%%
           TFD = wvd(sig,Fs,'smoothedPseudo');
           
   end
   TFD = imresize(TFD,[224 224]);  %调整时频图像的大小为 227 x 227。
   TFD = rescale(TFD);    %将时频图像的像素值归一化到 [0,1] 的范围内
   TFD = repmat(TFD,[1,1,3]);
   modType = truth(idxW);
   
   imwrite(TFD,fullfile(parentDir,dataDir,char(modType),sprintf('%d.png',idxW)))   
   %sprintf('%d.png',idxW) 创建一个图像文件名，并使用 imwrite 函数将时频图像保存为 PNG 格式的图像文件。
    
    
end
end