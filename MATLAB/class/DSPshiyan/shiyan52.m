function b=shiyan52(wp,ws,rs)
    %生成滤波器
        wguo=min(abs(wp-ws));
        wn=(wp+ws)./2;
        [windowxing,N]=shiyan51(rs,wguo);
        b=fir1(N,wn/pi,windowxing);
    figure(2)
    [H,W]=freqz(b,1);
    plot(W/pi,20*log10(abs(H)));
    grid
end