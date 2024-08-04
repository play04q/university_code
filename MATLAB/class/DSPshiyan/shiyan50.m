function [xn,freq,N,fs,Tt]=shiyan50(k)  %生成信号序列
    fs=40000;            %设定抽样频率fs/Hz
    Tt=0.0001;           %信号周期Tt/s
    T=1/fs;
    T0=k*Tt;            %设定记录长度T0/s
    t=0:T:(T0-T);
    xn=2.*(1+0.5.*cos(2000*pi*t)).*cos(20000*pi*t); %信号序列xn
    xk=fft(xn);           %计算信号序列xn的频谱xk
    N=length(xn);         %计算信号序列的长度
    i=1; 
    m=[0:N-1];
    f=m.*(fs/N);          %将数字频率转换成模拟线性频率/Hz
    freq=0;              % freq记录信号xn的频率分量
    for m=1:1:(N+1)/2  
       if (abs(xk(m))>0.0001)
           freq(i)=m-1;
           i=i+1;
        end
    end
    figure(1)
    subplot(2,1,1)
    plot(t,xn);xlabel('时间');legend('信号波形');
    subplot(2,1,2)
    stem(f(1:N/2),xk(1:N/2),'r');
    xlabel('频率/Hz');legend('信号频谱');
    grid;
end