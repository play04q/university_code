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
%xhhh1到xhhhi分别代表十六分之一音符
n=0:(fs/4-N-1);
xhhh1=[sin(n*2*pi*f1/fs) zeros(1,N)];
xhhh2=[sin(n*2*pi*f2/fs) zeros(1,N)];
xhhh3=[sin(n*2*pi*f3/fs) zeros(1,N)];
xhhh4=[sin(n*2*pi*f4/fs) zeros(1,N)];
xhhh5=[sin(n*2*pi*f5/fs) zeros(1,N)];
xhhh6=[sin(n*2*pi*f6/fs) zeros(1,N)];
xhhh7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xhhhi=[sin(n*2*pi*fi/fs) zeros(1,N)];
%xhhh1到xhhhi分别代表三十二分之一音符
n=0:(fs/8-N-1);
xhhhh1=[sin(n*2*pi*f1/fs) zeros(1,N)];
xhhhh2=[sin(n*2*pi*f2/fs) zeros(1,N)];
xhhhh3=[sin(n*2*pi*f3/fs) zeros(1,N)];
xhhhh4=[sin(n*2*pi*f4/fs) zeros(1,N)];
xhhhh5=[sin(n*2*pi*f5/fs) zeros(1,N)];
xhhhh6=[sin(n*2*pi*f6/fs) zeros(1,N)];
xhhhh7=[sin(n*2*pi*f7/fs) zeros(1,N)];
xhhhhi=[sin(n*2*pi*fi/fs) zeros(1,N)];
 
%dh1到dhi分别代表四分之一音符
n=0:(fs-N-1);
dh1=[sin(n*2*pi*f1/fs/2) zeros(1,N)];
dh2=[sin(n*2*pi*f2/fs/2) zeros(1,N)];
dh3=[sin(n*2*pi*f3/fs/2) zeros(1,N)];
dh4=[sin(n*2*pi*f4/fs/2) zeros(1,N)];
dh5=[sin(n*2*pi*f5/fs/2) zeros(1,N)];
dh6=[sin(n*2*pi*f6/fs/2) zeros(1,N)];
dh7=[sin(n*2*pi*f7/fs/2) zeros(1,N)];
dhi=[sin(n*2*pi*fi/fs/2) zeros(1,N)];
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
%dhhh1到dhhhi分别代表十六分之一音符
n=0:(fs/4-N-1);
dhhh1=[sin(n*2*pi*f1/fs/2) zeros(1,N)];
dhhh2=[sin(n*2*pi*f2/fs/2) zeros(1,N)];
dhhh3=[sin(n*2*pi*f3/fs/2) zeros(1,N)];
dhhh4=[sin(n*2*pi*f4/fs/2) zeros(1,N)];
dhhh5=[sin(n*2*pi*f5/fs/2) zeros(1,N)];
dhhh6=[sin(n*2*pi*f6/fs/2) zeros(1,N)];
dhhh7=[sin(n*2*pi*f7/fs/2) zeros(1,N)];
dhhhi=[sin(n*2*pi*fi/fs/2) zeros(1,N)];
%dhhh1到dhhhi分别代表三十二分之一音符
n=0:(fs/8-N-1);
dhhhh1=[sin(n*2*pi*f1/fs/2) zeros(1,N)];
dhhhh2=[sin(n*2*pi*f2/fs/2) zeros(1,N)];
dhhhh3=[sin(n*2*pi*f3/fs/2) zeros(1,N)];
dhhhh4=[sin(n*2*pi*f4/fs/2) zeros(1,N)];
dhhhh5=[sin(n*2*pi*f5/fs/2) zeros(1,N)];
dhhhh6=[sin(n*2*pi*f6/fs/2) zeros(1,N)];
dhhhh7=[sin(n*2*pi*f7/fs/2) zeros(1,N)];
dhhhhi=[sin(n*2*pi*fi/fs/2) zeros(1,N)];

%休止符
m21=key(2,1,fs);
o2=key(-inf,2,fs);
o4=key(-inf,4,fs);
o8=key(-inf,8,fs);
o16=key(-inf,16,fs);
 
notes=[dhh6 dhhh7 xhh1 dhhh6 xhhh1 xhhh1 dhhh7 dhhh6 dhh7 dhh3 dhh7 dhhhh7 xhhhh1 xhh2 xhhhh2 dhhhh7 xhhh2 xhhh2 xhhh1 dhhh7 dh6]; 
notes=[notes xhh3 xhh6 xhh5 xhhh6 xhhh5 xhhh4 xhhh4 xhhh3 xhhh2 xhh3 dhh6 o16 xhh4 xhhh2 xhh3 xhhhh3 xhhhh1 dhhh7 dhhh3 xhhh1 dhhh7 dh6];

sound(notes,fs);
function g=key(p,n,fs)
t=0:1/fs:3/n;
g=sin(2*pi*(440*2^((p-9)/12))*t);
end