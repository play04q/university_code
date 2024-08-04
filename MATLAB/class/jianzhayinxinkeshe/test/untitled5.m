x1=length(f(1:N/2));
x2=10;
o=ones(x2);z=zeros(x1-x2);
y=[o(1,:),z(1,:)];
figure;plot(f(1:N/2),y);
y1=mag(1:N/2)*2/N;
y2=y1.*y;
figure;plot(f(1:N/2),y2);

x3=f(1:N/2);
y3=max(y2);
omig1=x3(2)*2*pi*1e-4;
