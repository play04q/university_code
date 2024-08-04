function shiyan2(N1,N2,M)
    n0=[0:1:N1-1];                 %截取原始信号N1点
    n=[0:1:N2-1];                   %补零N2-N1个
    y=(1+cos(0.05*pi*n0)).*cos(0.5*pi*n0);
    %原始信号，其周期N=40，频率分量为0.45*pi，0.5*pi，0.55*pi
    x=[y(1:1:N1),zeros(1,N2-N1)];  %信号序列
    w=[0:1:2000]*2*pi/2000;
    x0=x*exp(-j*n'*w);              %信号序列的傅里叶变换
    magx0=abs(x0);                 %信号序列的傅里叶变换的幅度
    a=max(magx0);
    magx0=magx0/a;                 %幅度归一化
    x1=dft(x,N2);                    %信号序列的N2点离散傅里叶变换
    magx1=abs(x1(1:1:N2/2+1))/a;
    k1=0:1:N2/2;
    w1=2*pi/N2*k1;
    figure(M)
    subplot(2,1,1)
    stem(n,x);                     %绘制信号序列的离散序列图
    axis([0,N2,-2.5,2.5])
    line([0,N2],[0,0])
    subplot(2,1,2)
    plot(w/pi,magx0)              %绘制信号序列的傅里叶变换的幅频响应图
    hold on
    stem(w1/pi,magx1,'r')        %绘制信号序列傅里叶变换的幅频响应离散序列图
    axis([0,1,0,1.1])
end
