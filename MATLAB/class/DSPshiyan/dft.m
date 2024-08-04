function [Xk]=dft(xn,N)    
    %计算序列xn的N点离散傅里叶变换
    n=[0:1:N-1];k=[0:1:N-1];
    WN=exp(-j*2*pi/N);
    nk=n'*k;
    WNnk=WN.^nk;
    Xk=xn*WNnk;
end