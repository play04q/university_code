function [A_t, fml, fai_t] = FingerprintFeatures(t, fc)
%%%%%%%%%%%             指纹特征        %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%脉冲幅度PA = 10lg（Pt*Gt*F(θ)/(4Π*R^2*L)）（包含距离衰减）%%%%%%%%%%%
Pt = 600e3;     %雷达发射功率600kw
Gt = 10^(40/10);        %天线增益40dB
F_theta = 1;    %F(θ)为归一化后的天线方向图函数，处于跟踪状态下的雷达F(θ)
R = 170e3;      %与雷达之间的距离170km
L = 10^(1/10);          %雷达电波大气传播损耗1dB
PA = 10*log10(Pt*Gt*F_theta/(4*pi*R^2*L));            %单位dB

%%%%%%%%%%%%%%%%%%%%寄生幅度调制A(t) = PA+epsilong(t)%%%%%%%%%%%%%%%%%%%%%%
epsilong = (1/3)*PA;     %寄生调幅
A_t = PA + epsilong;

%%%%%%%%%%%%%%%%%频率抖动f0 = fc+fml%%%%%%%%%%%%%%%%
fml =  0.03*fc ;                       %频率抖动值

%%%%%%%%%%%%%%%%%%%寄生相位调制φ(t) = β*sin(2*Π*fm*t)%%%%%%%%%%%%%
beta = 0.01 ;                  %调相系数 β＜＜1                 
fm = fc;                        %寄相调制信号的频率
fai_t = beta*sin(2*pi*fm*t);
end