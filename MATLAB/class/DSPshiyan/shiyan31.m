function shiyan31(I,D) %(5,4)
    %观察对序列插值、抽取后频谱的变化
    n0=[0:1:39]; N=40; n1=2/N*n0;
    xn=0.5+0.7*cos(0.05*pi*n0)+0.4*cos(0.1*pi*n0)+0.1*cos(0.15*pi*n0);
    xk=dft(xn,N);
    magxk=abs(xk);
    figure(31);
    subplot(3,1,1);
    stem(n1,magxk);
    %信号序列的插值
    yn=chazhi(xn,I);
    M=length(yn);
    yk=dft(yn,M);
    magyk=abs(yk);
    m=[0:1:M-1]; m1=2/M*m;
    subplot(3,1,2)
    stem(m1,magyk);
    %信号序列的抽取
    zn=chouqu(xn,D);
    M=length(zn); m=[0:1:M-1]; m1=2/M*m;
    zk=dft(zn,M);
    magzk=abs(zk);
    subplot(3,1,3)
    stem(m1,magzk);
end
