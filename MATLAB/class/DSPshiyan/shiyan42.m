function [bz,az]=shiyan42(fp,fst,rp,rs,fs) 
    %数字低通滤波器的生成
    W0=[0,fp,fst,fs/2]; rr=[rp,rp,rs,rs];%设计指标
    mp=fp*2*pi;
    ms=fst*2*pi;             % mp/ms:通带/阻带截止频率（弧度/秒）
    [Ba,Aa,Wn]=shiyan41(mp,ms,rp,rs);
    [b,a]=lp2lp(Ba,Aa,Wn);     % 将归一化频率的低通滤波器转换成截止频
    % 率为Wn的数字低通滤波器
    [bz,az]=bilinear(b,a,fs);
    [H,W]=freqz(bz,az);   
    figure(2);
    plot(W*fs/(2*pi),20*log10(abs(H)));
    hold on
    plot(W0,-rr,'r')
    xlabel('频率/Hz');
    ylabel('幅频特性/dB');
    grid
end