warning off
parallel:gpu:device:DeviceLibsNeedRecompiling
try
     gpuArray.eye(2)^2;
catch ME
    
end
try
    nnet.internal.cnngpu.reluForward(1);
catch ME
    
end