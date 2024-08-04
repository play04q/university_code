function [bz,az]=shiyan43(fp,fst,rp,rs,fs) 
    %数字高通滤波器的生成
    W0=[0,fst,fp,fs/2]; rr=[rs,rs,rp,rp]; %设计指标
    wp=fp*2*pi/fs; ws=fst*2*pi/fs;   %模拟指标数字化
        C=2*fs;                %频率预畸
        hp=C*tan(wp/2); hs=C*tan(ws/2);
        mp=hp; ms=hp^2/hs; %模拟高通指标转化为模拟低通指标
    [Ba,Aa,Wn]=shiyan41(mp,ms,rp,rs);
    [b,a]=lp2hp(Ba,Aa,mp);  %将归一化频率的低通滤波器转换成截止
    %频率为Wn的高通滤波器
    [bz,az]=bilinear(b,a,fs);
    [H,W]=freqz(bz,az);
    figure(3)
    plot(W*fs/(2*pi),20*log10(abs(H)));
    hold on
    plot(W0,-rr,'r')
    xlabel('频率/Hz')
    ylabel('幅频特性/dB')
    grid
end