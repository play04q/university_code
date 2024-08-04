%% 
clear;clc;
%% 第二题
a=0;b=0;c=0;
for k=1:100
    a=a+k;
end
for k=2:50
    b=b+k^2;
end
for k=1:10
    c=c+1/k;
end
a+b+c

%% 第三题
cirarea

%% 第五题
a=input('第一个数：');
b=input('第二个数：');
c=input('第三个数：');
d=input('第四个数：');
if a<b
    f=a;
    a=b;
    b=f;
end
if a<c
    f=a;
    a=c;
    c=f;
end
if a<d
    f=a;
    a=d;
    d=f;
end
if b<c
    f=b;
    b=c;
    c=f;
end
if b<d
    f=b;
    b=d;
    d=f;
end
if c<d
    f=c;
    c=d;
    d=f;
end
e=[a,b,c,d];
disp('大小顺序为：')
disp(e)

%% 第六题
syms x;syms y;
eq1=x+y-36;
eq2=2*x+4*y-100;
[x,y]=solve(eq1,eq2)
