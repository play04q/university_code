function [data, truth] = helperGenerateRadarWaveforms()
%%%%%%%%%%%%信号初始数据%%%%%%%%%%%%%%%%%%%
Fs = 500e6;        %采样频率
nSignalsPerMod = 30*11;    %产生信号个数

Ts = 1/Fs;   %采样周期
%%%%%%%%%%%%%初始化
modTypes = categorical(["Rect", "LFM", "NLFM", "BPSK", "QPSK", "BFSK", "QFSK"]);  %定义调制方式

rng(0)     %定了随机数生成器的种子，以便在随后的模拟中产生可重复的随机数序列。

%%%%%%%%%%%%%%%%生成数据训练集
idxW = 1;
for iM = 1:length(modTypes)
    modType = modTypes(iM);
    rangeFc = [Fs/5, Fs/2.5];    %载频范围
    rangeN = [512, 1920];     %产生信号点数范围
    %snrVector = -10:5:30;    %信噪比-10:30
    snrVector = 10;       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rangeB = [Fs/20, Fs/12.5];     %LFM信号带宽范围
    
    switch modType
        case 'Rect'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                %SNR =  -6:5:30;
                
                t =0:1/Fs:(Ncc-1)/Fs;  %时间序列
                %[A_t, fml, fai_t] = FingerprintFeatures(t, Fc);         %%指纹特征
               
                
                %%%%%%%%%%产生信号
                wav = exp(1i*(2*pi*Fc*t));
                %wav = A_t*cos(2*pi*(Fc+fml)*t + fai_t);  %加入指纹特征
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;  
            end    
        case 'LFM'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                B = rand0verInterval(rangeFc);%带宽
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                Te = Ncc*Ts;   %脉冲宽度
                K = B/Te;    %调制斜率
                
                t =0:1/Fs:(Ncc-1)/Fs;  %时间序列
                %[A_t, fml, fai_t] = FingerprintFeatures(t, Fc);         %%指纹特征
                
                %%%%%%%%%%%%产生信号
                wav = exp(1i*(2*pi*Fc*t + pi*K*t.^2));
                %wav = A_t*cos(2*pi*(Fc+fml)*t + pi*K*t.^2 + fai_t);%指纹特征
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;      
            end        
        case 'NLFM'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                
                t =0:1/Fs:(Ncc-1)/Fs;  %时间序列
                %[A_t, fml, fai_t] = FingerprintFeatures(t, Fc);         %%指纹特征
                
                %%%%%%%%%%%产生信号
                mf = 15; % 调频指数,控制纵向尺寸，这个数字越大，正弦的"波"上下幅度越大
                fm = Fc/100;      %调频信号的频率,这个控制横线的尺寸，这个数字越大，横向放下的正弦波越多
                wav = exp(1i*(2*pi*Fc*t + mf*sin(2*pi*fm*t)));
                %wav = A_t*cos(2*pi*(Fc+fml)*t + mf*sin(2*pi*fm*t) + fai_t);%指纹特征
                
                
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;  
            end
        case 'BPSK'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                Te = Ncc*Ts;   %13位巴克码脉冲宽度
                
                %%%%%%%%%%%%%产生巴克码
                barker_13=[1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];      %13位巴克码
                p=Te/13.0;           %计算子码时长
                pn=fix(p*Fs);       %子码点数
                cs=ones(13,pn);
                for j=(1:13)
                    if(barker_13(j)==-1)
                        cs(j,:)=cs(j,:)*-1;
                    end
                end
                cs=[cs(1,:),cs(2,:),cs(3,:),cs(4,:),cs(5,:),cs(6,:),cs(7,:),cs(8,:),cs(9,:),cs(10,:),cs(11,:),cs(12,:),cs(13,:)];
                
                t=(0:pn*13-1)/Fs;%时间序列
                
                %[A_t, fml, fai_t] = FingerprintFeatures(t, Fc);         %%指纹特征
                
                %%%%%%%%%%%%%%%%产生信号
                wav = exp(1i*2*pi*Fc*t).*cs;    %原信号
                %wav = A_t*exp(1i*2*pi*(Fc+fml)*t + fai_t).*cs;    %原信号
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;  
            end
        case 'QPSK'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                Te = Ncc*Ts;   %脉冲宽度
                
                %%%%%%%%%%%%%产生tler_28A码
                tler_28A=[1  1i  1 -1i  1 -1i -1  1i -1  1i  1  1i -1  1i  1 1i -1  1i  1 1i -1  1i -1 -1i  1 -1i 1 1i];
                p=Te/28.0;   %计算子码时长
                pn=fix(p*Fs);%子码点数
                cs=ones(28,pn);
                for j=(1:28)
                    if(tler_28A(j)==-1)
                        cs(j,:)=cs(j,:)*-1;
                    end
                    if(tler_28A(j)==1i)
                        cs(j,:)=cs(j,:)*1i;
                    end
                    if(tler_28A(j)==-1i)
                        cs(j,:)=cs(j,:)*-1i;
                    end
                end
                cs=[cs(1,:),cs(2,:),cs(3,:),cs(4,:),cs(5,:),cs(6,:),cs(7,:),cs(8,:),cs(9,:),cs(10,:),cs(11,:),cs(12,:),cs(13,:),cs(14,:),cs(15,:),cs(16,:),cs(17,:),cs(18,:),cs(19,:),cs(20,:),cs(21,:),cs(22,:),cs(23,:),cs(24,:),cs(25,:),cs(26,:),cs(27,:),cs(28,:)];
                t=(0:pn*28-1)/Fs;       %时间序列
                
                %[A_t, fml, fai_t] = FingerprintFeatures(t, Fc);         %%指纹特征
                %%%%%%%%%%%%%%%%产生信号
                wav = exp(1i*2*pi*Fc*t).*cs;    %原信号
                %wav = A_t*exp(1i*2*pi*(Fc+fml)*t + fai_t).*cs;    %原信号
                
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;  
            end
        case 'BFSK'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                Te = Ncc*Ts;   %脉冲宽度
                
                %%%%%%%%%%%%%%产生信号
                barker_13=[1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
                p=Te/13.0;           %计算子码时长
                pn=fix(p*Fs);       %子码点数
                cs=ones(13,pn);
                cst=(0:pn-1)/Fs;     %时间序列
                
                %[A_t, fml, fai_t] = FingerprintFeatures(cst, Fc);         %%指纹特征
                
                f1=Fc+(10+(50-10)*rand(1))*1e6;%频率偏移量
                %f1 = Fc + 100e6;
                p0=0;
                for j=(1:13)
                            if(barker_13(j)==1)
                                cs(j,:)=exp(1i*(p0+2*pi*Fc*cst));
                                %cs(j,:)=A_t*exp(1i*(p0+2*pi*(Fc+fml)*cst + fai_t));%指纹特征
                                p0=p0+2*pi*Fc*cst(pn);
                            else
                                cs(j,:)=exp(1i*(p0+2*pi*f1*cst));
                                %cs(j,:)=A_t*exp(1i*(p0+2*pi*(f1+fml)*cst + fai_t));%指纹特征
                                p0=p0+2*pi*f1*cst(pn);
                            end
                end
                wav=[cs(1,:),cs(2,:),cs(3,:),cs(4,:),cs(5,:),cs(6,:),cs(7,:),cs(8,:),cs(9,:),cs(10,:),cs(11,:),cs(12,:),cs(13,:)];   %原信号
                
                
                %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1; 
            end
        case 'QFSK'
            for iS = 1:nSignalsPerMod
                Fc = rand0verInterval(rangeFc);%载频
                Ncc = round(rand0verInterval(rangeN));  %信号点数
                SNR = snrVector(ceil(iS.*length(snrVector)./nSignalsPerMod));%randi 均匀分布的伪随机整数
                Te = Ncc*Ts;   %脉冲宽度
                
                %%%%%%%%%%%产生信号
                frank_16=[0 0 0 0 0 1 2 3 0 2 4 6 0 3 6 9];
                p=Te/16.0;
                pn=fix(p*Fs);%子码点数
                cs=ones(16,pn);
                cst=(0:pn-1)/Fs;
                
                %[A_t, fml, fai_t] = FingerprintFeatures(cst, Fc);         %%指纹特征
                
                df=(10+(50-10)*rand(1))*1e6;  %频率偏移量
                %df = 50e6;
                p0=0;
                for j=(1:16)
                    if(mod(frank_16(j),4)==0)
                        cs(j,:)=exp(1i*(p0+2*pi*(Fc+df*mod(frank_16(j),4))*cst));
                        %cs(j,:)=A_t*exp(1i*(p0+2*pi*(Fc+ fml +df*mod(frank_16(j),4))*cst + fai_t));%加入指纹特征
                        p0=p0+2*pi*Fc*cst(pn);
                    else
                        if(mod(frank_16(j),4)==1)
                            cs(j,:)=exp(1i*(p0+2*pi*(Fc+df*mod(frank_16(j),4))*cst));
                            %cs(j,:)=A_t*exp(1i*(p0+2*pi*(Fc + fml +df*mod(frank_16(j),4))*cst + fai_t));%加入指纹特征
                            p0=p0+2*pi*Fc*cst(pn);
                        else
                            if(mod(frank_16(j),4)==2)
                                cs(j,:)=exp(1i*(p0+2*pi*(Fc+df*mod(frank_16(j),4))*cst));
                                %cs(j,:)=A_t*exp(1i*(p0+2*pi*(Fc + fml +df*mod(frank_16(j),4))*cst + fai_t));%加入指纹特征
                                p0=p0+2*pi*Fc*cst(pn);
                            else
                                cs(j,:)=exp(1i*(p0+2*pi*(Fc+df*mod(frank_16(j),4))*cst));
                                %cs(j,:)=A_t*exp(1i*(p0+2*pi*(Fc + fml +df*mod(frank_16(j),4))*cst + fai_t));%加入指纹特征
                                p0=p0+2*pi*Fc*cst(pn);
                            end
                        end
                    end
                end
                wav=[cs(1,:),cs(2,:),cs(3,:),cs(4,:),cs(5,:),cs(6,:),cs(7,:),cs(8,:),cs(9,:),cs(10,:),cs(11,:),cs(12,:),cs(13,:),cs(14,:),cs(15,:),cs(16,:)];
                t=(0:pn*16-1)/Fs;       %时间序列
                
                 %%%%%%%%%%%添加噪声
                wav = awgn(wav,SNR);
                
                %%%%%%%保存信号
                data{idxW} = wav;
                truth(idxW) = modType;
                idxW = idxW + 1;  
            end
    end
end
end
