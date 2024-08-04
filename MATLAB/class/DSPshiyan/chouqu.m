function yn=chouqu(xn,D)
N=length(xn);
m=0;
    for n=1:D:N
        m=m+1;
        yn(m)=xn(n);
    end
end