%%   1
t=-pi:0.01:pi; x1=sin(t); x2=sin(t).^2;
plot(t,x1,'b',t,x2,'r:')
title( '图名 ');
xlabel( 'x 轴 ' );
ylabel( 'y 轴 ' );
legend( '图例 ','-1');

%%   5
%创建符号变量，变量和表达式符号变量和数值变量的转换 ,将一数值矩阵转换为符号矩阵
A=[1 2 1;2 3 4;1 3 2];
A5=sym(A)

%%   6
% 微分与积分运算
% a) 查找符号的自变量
syms f(x,y);
f(x,y) = x + y+1;
symvar(f,1)  %查找 f 中的第一个自变量
% b) 微分运算
%     求 x=a*cos(t)^3 的微分
syms t a; 
x=a*cos(t)^3; 
b6=diff(x)
% c) 积分运算
%     求 log(log(x))/x 的积分
syms x;
c6=inv(log(log(x))/x)

%%   7
syms k;
a7=symsum((-1)^k/k,1,inf)
b7=symsum((-1)^k.*(x.^k)/k,k,1,inf)

syms x;
f1=exp(x);
c7=taylor(f1,x,'order',5)
f2=sin(x);
d7=taylor(f2,x,'order',5)
f3=cos(x);
e7=taylor(f3,x,'order',5)

%%   8
syms n;
a8=limit((1+1/n)^(1/2),n,inf)
b8=limit((x^2-x-1)/(x-1)^2,x,0)

%%   9
A=[3 1;1 3];
A9=sym(A)
a9=eig(A)
[v91,d91]=eig(A)
b9=poly(A)

B=[2 1 1;0 2 0;4 1 3];
B9=sym(B)
e9=eig(B)
[v92,d92]=eig(B)
f9=poly(B)

%%   10
syms x;syms y;
eqs=[x*y==3 , x*x+y==4];
vars=[x,y];
[x10,y10]=solve(eqs,vars)

a10=dsolve('Dy=sin(t)')

b10=dsolve('D2y+Dy-y=sin(x)','x')

%%   F1 6
x=-2*pi:0.01:2*pi;
y=sin(1./x);
figure(6);
subplot(2,1,1);
plot(x,y);
subplot(2,1,2);
fplot(@(x)sin(1./x));

%%   F2 7
t=-10:0.05:10;
[x,y]=meshgrid(t);
a=2;b=1;
z1=x.^2./a^2+y.^2./b^2;
figure(7);
subplot(2,3,1);
meshc(x,y,z1);
% figure(27);
subplot(2,3,4);
meshz(x,y,z1);

z2=x.*y;
% figure(37);
subplot(2,3,2);
meshc(x,y,z2);
% figure(47);
subplot(2,3,5);
meshz(x,y,z2);

z3=sin(x.*y);
% figure(57);
subplot(2,3,3);
meshc(x,y,z3);
% figure(67);
subplot(2,3,6);
meshz(x,y,z3);

%%   F3 9
x=-10:0.01:10;
y1=2*exp(-0.5.*x);
y2=sin(2*pi.*x);
figure(19);
plot(x,y1);
hold on;
plot(x,y2,'--')
legend( 'y1','y2');
