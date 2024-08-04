function [Ba,Aa,Wn]=shiyan41(mp,ms,rp,rs) 
    %生成归一化频率的模拟低通滤波器
    [N,Wn]=buttord(mp,ms,rp,rs,'s');%mp/ms:通带/阻带截止频率(弧度%/秒)
    [z,p,k]=buttap(N);
    [Ba,Aa]=zp2tf(z,p,k);
end