function [xn,wk,N]=shiyan40(fs,T0)
    T=1/fs;
    t=0:T:(T0-T);
    xn=cos(100*pi*t)+2*cos(800*pi*t);
    xk=fft(xn);
    N=length(xn);
    i=1;
    wk=0;
    for m=1:1:(N+1)/2
       if (abs(xk(m))>0.0001)
           wk(i)=m-1;
           i=i+1;
        end
    end
    n=0:1:N-1;
    figure(1)
    subplot(2,1,1)
    plot(t,xn);
    subplot(2,1,2)
    stem(n,abs(xk),'r')
end