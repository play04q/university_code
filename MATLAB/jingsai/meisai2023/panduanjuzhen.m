A=[1	2	2
0.5	1	0.5
0.5	2	1
];
[x,y]=eig(A);
m=diag(y);
a=max(m);
[m,n]=size(A);
CL=(a-n)/(n-1);
if n==3
    RL=0.52;
end
if n==4
    RL=0.89;
end
if n==5
    RL=1.12;
end
if n==6
    RL=1.26;
end
if n==7
    RL=1.36;
end
if n==8
    RL=1.41;
end
if n==9
    RL=1.46;
end
if n==10
    RL=1.49;
end
CR=CL/RL
if CR<0.1
    disp('yes');
else
    disp('no');
end