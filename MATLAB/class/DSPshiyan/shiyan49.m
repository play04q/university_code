function [yl,yh]=shiyan49
    fs=1600;                    %采样频率
    Tt=0.02;                    %信号周期
    T0=4*Tt;                    %记录长度
    [xn,wk,N]=shiyan40(fs,T0);
    M=length(wk);
    if M==2 
        rp=1;rs=80;
        f1=wk(1)*fs/N;
        f2=wk(2)*fs/N;
        f0=f2-f1;
        fpl=f1+f0/20; fstl=f2-f0/10;      %模拟低通滤波器的特征参数
        [bzl,azl]=shiyan42(fpl,fstl,rp,rs,fs); 
        fph=f2-f0/2;fsth=f1+f0/20;       %模拟高通滤波器的特征参数
        [bzh,azh]=shiyan43(fph,fsth,rp,rs,fs); 
    end
    ynl=filter(bzl,azl,xn);    %序列xn通过数字低通滤波器，输出为ynl
    ynh=filter(bzh,azh,xn);   %序列xn通过数字高通滤波器，输出为ynh
    knl=abs(fft(ynl));       % ynl的频谱knl
    kl=knl/max(knl);        % ynl的幅度归一化频谱kl 
    knh=abs(fft(ynh)); kh=knh/max(knh);
    T=1/fs;
    figure(8)
    t=0:T:(T0-T);
    w=0:2*pi/N:(2*pi-2*pi/N);
    subplot(2,2,1); plot(t,ynl);
    subplot(2,2,2); stem(w,kl);
    subplot(2,2,3); plot(t,ynh);
    subplot(2,2,4); stem(w,kh);
    %去掉滤波输出序列的头一个周期
    yl=ynl(N/4+1:N);
    yh=ynh(N/4+1:N);
    knl=abs(fft(yl)); kl=knl/max(knl);
    knh=abs(fft(yh)); kh=knh/max(knh);
    N=length(kl);
    t=Tt:T:(T0-T);
    w=0:2*pi/N:(2*pi-2*pi/N);
    figure(9)
    subplot(2,2,1)
    plot(t,yl);
    xlabel('秒'); title('低频分量时域波形')
    subplot(2,2,2); 
    stem(w,kl)
    xlabel('数字频率/弧度 ');title('低频分量归一化频谱图')
    subplot(2,2,3)
    plot(t,yh);
    xlabel('秒'); title('高频分量时域波形')
    subplot(2,2,4)
    stem(w,kh)
    xlabel('数字频率/弧度 '); title('高频分量归一化频谱图')
end