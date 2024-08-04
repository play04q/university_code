function shiyan32(I,D,wp) %(7,5,0.12~0.2)
    %抽样转换率为I/D，先插值(I)，经低通滤波（截止频率wp*pi），再抽取(D)。
    %有限频宽序列xn
    n0=[0:1:39]; N=40;
    x1=0.5+.93*cos(0.05*pi*n0)+.86*cos(0.1*pi*n0);
    x2=.79*cos(0.15*pi*n0)+.72*cos(0.20*pi*n0);
    x3=.65*cos(0.25*pi*n0)+.58*cos(0.30*pi*n0);
    x4=.51*cos(0.35*pi*n0)+.44*cos(0.40*pi*n0);
    x5=.37*cos(0.45*pi*n0)+.30*cos(0.50*pi*n0);
    x6=.23*cos(0.55*pi*n0)+.16*cos(0.60*pi*n0);
    x7=.09*cos(0.65*pi*n0)+.02*cos(0.70*pi*n0);
    xn=x1+x2+x3+x4+x5+x6+x7;
    %序列的频谱xk
    xk=dft(xn,N);
    a=max(abs(xk));
    magxk=abs(xk)/a;      %归一化处理
    n1=2/N*n0;
    figure(32);
    subplot(4,1,1);
    stem(n1,magxk);
    %信号序列的插值序列yn, 插值因子I,
    yn=chazhi(xn,I);
    M=length(yn);
    yk=dft(yn,M);       %序列插值后的频谱yk
    b=max(abs(yk));
    magyk=abs(yk)/b;     %归一化处理
    m=[0:1:M-1]; m1=2/M*m;
    subplot(4,1,2)
    stem(m1,magyk);
    %生成滤除高频分量的滤波器hk
    np=wp*M/2;
    hk=[1,zeros(1,M-1)];
    for i=2:1:np
        hk(i)=1;
        hk(M-i+2)=1;
    end
    ykk=yk.*hk;              %经过滤波后的频谱ykk
    magykk=abs(ykk)/b;
    subplot(4,1,3)
    stem(m1,magykk);
    %计算经过滤波后的序列ynn
    ykkk=conj(ykk);           %取复共轭函数:conj
    ynn=conj(dft(ykkk,M))/M;
    %ynn序列的抽取序列zn，抽取因子D
    zn=chouqu (ynn,D);
    M=length(zn);
    zk=dft(zn,M);             %序列抽取后的频谱zk
    c=max(abs(zk));
    magzk=abs(zk)/c;          %归一化处理
    m=[0:1:M-1]; m1=2/M*m;
    subplot(4,1,4)
    stem(m1,magzk);
end