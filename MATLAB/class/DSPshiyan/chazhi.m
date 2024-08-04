function yn=chazhi(xn,I)
    N=length(xn);
    M=I*N;
    yn=zeros(1,M);
    for n=1:1:N
        m=(n-1)*I+1;
        yn(m)=xn(n);
    end
end
