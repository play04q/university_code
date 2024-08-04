%%   11
a=[-2 1 1 ;0 2 0;-4 1 3];
a1=inv(a)
a2=det(a)
a3=a'
a4=rank(a)

%%   12
a1=[6 3 4;-2 5 7;8 -4 -3;1 5 -7];
b1=[3;-4;-7;9];
c1=a1\b1
a2=[2 4 2 1;-1 2 0 2;3 5 2 1];
b2=[1;4;6];
c2=a2\b2

%%   14
a=[3 -1;-1 3];
b=eig(a)
[v,d]=eig(a)
c1=poly(a)
c2=inv(v)*d*v

%%   21
b1=[1 2];b2=[1 5];
b=10.*conv(b1,b2);
a1=[1 0];a2=[1 1];a3=[1 3];
a4=conv(a1,a2);
a=conv(a3,a4);
[r,p,k]=residue(b,a)

%%   22
b1=[-1 4];b2=[1 5];b3=[1 -6 9];
m=conv(b1,b2);
p=conv(m,b3);
g=polyval(p,[0:20]);
roots(p)

%%   23
b1=[-1 4];b2=[1 5];b3=[1 -6 9];
m=conv(b1,b2);
p=conv(m,b3);
g=polyval(p,[0:20]);
g1=g+10.*rand(1,21);
G1=polyfit([0:20],g1,3)
G2=polyfit([0:20],g1,3)

%%   24
x=0:9;
y=[0 ,1.8 ,2.1, 0.9, 0.2, -0.5, -0.2, -1.7, -0.9, -0.3];
x1=0:0.01:9;
y1=interp1(x,y,x1,'linear');
y2=interp1(x,y,x1,'spline');
y3=interp1(x,y,x1,'cubic');
plot(x1,y1);
hold on;
plot(x1,y2);
hold on;
plot(x1,y3);

%%   3
a=[1 2 3 4 5 6];b=[2 4 6 8 6 3];
x=[6 9 3 4 0;5 4 1 2 5;6 7 7 8 0;7 8 9 10 0];
y=max(a)
[xm,index]=max(x)
a3=mean(x)
b3=cov(x)
s=std(x,0)
s1=std(x,1)
[e1,index1]=sort(x)
[e2,index2]=sort(b)

%%   41
f=inline('1./((x-0.3).^2+0.01)+1./((x-0.9).^2+0.04)-6')

%%   42
f='2*exp(-x).*sin(x)';
figure(1);ezplot(f,[0 8]);
figure(2);fplot(f,[0 8]);

%%   43
t0=0;tf=3*pi;xot=[0;0];
[t,x]=ode45('exampfun',[t0,tf],xot);
y=x(:,1)
% function xdot=exampfun(t,x)
% u=1-(t.^2)/(pi*2);
% xdot=[0 1;-1 0]*x+[0 1]*u;
% end

%%   44
y=quadl('x.^2.*sqrt(2*x.^2+3)',1,5)

