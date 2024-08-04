fs=8192; %采样率
%f1到fi分别代表中音1到i的频率
f1=262;
f2=f1*power(2,2/12);
f3=f1*power(2,4/12);
f4=f1*power(2,5/12);
f5=f1*power(2,7/12);
f6=f1*power(2,9/12);
f7=f1*power(2,11/12);
fi=f1*2;
%x1到xi分别代表二分之一音符
N=300;
n=0:(2*fs-N-1);
x1=[sin(n*2*pi*f1/fs) zeros(1,N)];
x2=[sin(n*2*pi*f2/fs) zeros(1,N)];
x3=[sin(n*2*pi*f3/fs) zeros(1,N)];
x4=[sin(n*2*pi*f4/fs) zeros(1,N)];
x5=[sin(n*2*pi*f5/fs) zeros(1,N)];
x6=[sin(n*2*pi*f6/fs) zeros(1,N)];
x7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xi=[sin(n*2*pi*fi/fs) zeros(1,N)];
%xh1到xhi分别代表四分之一音符
n=0:(fs-N-1);
xh1=[sin(n*2*pi*f1/fs) zeros(1,N)];
xh2=[sin(n*2*pi*f2/fs) zeros(1,N)];
xh3=[sin(n*2*pi*f3/fs) zeros(1,N)];
xh4=[sin(n*2*pi*f4/fs) zeros(1,N)];
xh5=[sin(n*2*pi*f5/fs) zeros(1,N)];
xh6=[sin(n*2*pi*f6/fs) zeros(1,N)];
xh7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xhi=[sin(n*2*pi*fi/fs) zeros(1,N)];
%xhh1到xhhi分别代表八分之一音符
n=0:(fs/2-N-1);
xhh1=[sin(n*2*pi*f1/fs) zeros(1,N)];
xhh2=[sin(n*2*pi*f2/fs) zeros(1,N)];
xhh3=[sin(n*2*pi*f3/fs) zeros(1,N)];
xhh4=[sin(n*2*pi*f4/fs) zeros(1,N)];
xhh5=[sin(n*2*pi*f5/fs) zeros(1,N)];
xhh6=[sin(n*2*pi*f6/fs) zeros(1,N)];
xhh7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xhhi=[sin(n*2*pi*fi/fs) zeros(1,N)];
%xhhh1到xhhhi分别代表八分之一音符
n=0:(fs/4-N-1);
xhhh1=[sin(n*2*pi*f1/fs) zeros(1,N)];
xhhh2=[sin(n*2*pi*f2/fs) zeros(1,N)];
xhhh3=[sin(n*2*pi*f3/fs) zeros(1,N)];
xhhh4=[sin(n*2*pi*f4/fs) zeros(1,N)];
xhhh5=[sin(n*2*pi*f5/fs) zeros(1,N)];
xhhh6=[sin(n*2*pi*f6/fs) zeros(1,N)];
xhhh7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xhhhi=[sin(n*2*pi*fi/fs) zeros(1,N)];
 
%dhh1到dhhi分别代表低音八分之一音符
n=0:(fs/2-N-1);
dhh1=[sin(n*2*pi*f1/fs/2) zeros(1,N)];
dhh2=[sin(n*2*pi*f2/fs/2) zeros(1,N)];
dhh3=[sin(n*2*pi*f3/fs/2) zeros(1,N)];
dhh4=[sin(n*2*pi*f4/fs/2) zeros(1,N)];
dhh5=[sin(n*2*pi*f5/fs/2) zeros(1,N)];
dhh6=[sin(n*2*pi*f6/fs/2) zeros(1,N)];
dhh7=[sin(n*2*pi*f7/fs/2) zeros(1,N)];
dhhi=[sin(n*2*pi*fi/fs/2) zeros(1,N)];
 
notes=[xhh1 xhh2 xhh3 xhh1 xhh1 xhh2 xhh3 xhh1 xhh3 xhh4 xh5 xhh3 xhh4 xh5];
notes=[notes xhhh5 xhhh6 xhhh5 xhhh4 xhh3 xhh1 xhhh5 xhhh6 xhhh5 xhhh4 xhh3 xhh1];
notes=[notes xhh2 dhh5 xh1 xhh2 dhh5 xh1];
sound(notes,fs);