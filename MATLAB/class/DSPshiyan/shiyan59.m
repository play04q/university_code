function yn=shiyan59
    k=10;              %记录长度为信号周期的k倍
    [xn,freq,N,fs,Tt]=shiyan50(k);
    T=1/fs;
    fp=[9800,10200];
    fst=[9200,10800];
    rs=60;
    wp=(2*pi/fs).*fp;
    ws=(2*pi/fs).*fst;
    b=shiyan52(wp,ws,rs);  %生成带通数字滤波器 
    yn=filter(b,1,xn);        %对信号xn进行滤波
    kk=5; %kk<k
    ynn=yn(kk*N/k+1:N);   %去掉yn的前kk个周期
    knn=abs(fft(ynn));       %计算滤波后信号ynn的频谱
    M=length(ynn);
    t=kk*Tt:T:(k*Tt-T);
    m=[0:M-1];
    f=m.*(fs/M);
    figure(9)
    subplot(2,1,1)
    plot(t,ynn);
    xlabel('时间/S');
    legend('输出信号的波形');
    subplot(2,1,2)
    stem(f(1:M/2),knn(1:M/2));
    xlabel('频率/Hz');
    legend('输出信号的频谱');
end