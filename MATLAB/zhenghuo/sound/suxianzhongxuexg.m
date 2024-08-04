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

%h1到hi分别代表四分之一音符
n=0:(fs-N-1);
h1=[sin(n*2*pi*f1/fs*2) zeros(1,N)];
h2=[sin(n*2*pi*f2/fs*2) zeros(1,N)];
h3=[sin(n*2*pi*f3/fs*2) zeros(1,N)];
h4=[sin(n*2*pi*f4/fs*2) zeros(1,N)];
h5=[sin(n*2*pi*f5/fs*2) zeros(1,N)];
h6=[sin(n*2*pi*f6/fs*2) zeros(1,N)];
h7=[sin(n*2*pi*f7/fs*2) zeros(1,N)];
hi=[sin(n*2*pi*fi/fs*2) zeros(1,N)];
%hh1到hhi分别代表低音八分之一音符
n=0:(fs/2-N-1);
hh1=[sin(n*2*pi*f1/fs*2) zeros(1,N)];
hh2=[sin(n*2*pi*f2/fs*2) zeros(1,N)];
hh3=[sin(n*2*pi*f3/fs*2) zeros(1,N)];
hh4=[sin(n*2*pi*f4/fs*2) zeros(1,N)];
hh5=[sin(n*2*pi*f5/fs*2) zeros(1,N)];
hh6=[sin(n*2*pi*f6/fs*2) zeros(1,N)];
hh7=[sin(n*2*pi*f7/fs*2) zeros(1,N)];
hhi=[sin(n*2*pi*fi/fs*2) zeros(1,N)];
%hhh1到hhhi分别代表十六分之一音符
n=0:(fs/4-N-1);
hhh1=[sin(n*2*pi*f1/fs*2) zeros(1,N)];
hhh2=[sin(n*2*pi*f2/fs*2) zeros(1,N)];
hhh3=[sin(n*2*pi*f3/fs*2) zeros(1,N)];
hhh4=[sin(n*2*pi*f4/fs*2) zeros(1,N)];
hhh5=[sin(n*2*pi*f5/fs*2) zeros(1,N)];
hhh6=[sin(n*2*pi*f6/fs*2) zeros(1,N)];
hhh7=[sin(n*2*pi*f7/fs*2) zeros(1,N)];
hhhi=[sin(n*2*pi*fi/fs*2) zeros(1,N)];
%hhh1到hhhi分别代表三十二分之一音符
n=0:(fs/8-N-1);
hhhh1=[sin(n*2*pi*f1/fs*2) zeros(1,N)];
hhhh2=[sin(n*2*pi*f2/fs*2) zeros(1,N)];
hhhh3=[sin(n*2*pi*f3/fs*2) zeros(1,N)];
hhhh4=[sin(n*2*pi*f4/fs*2) zeros(1,N)];
hhhh5=[sin(n*2*pi*f5/fs*2) zeros(1,N)];
hhhh6=[sin(n*2*pi*f6/fs*2) zeros(1,N)];
hhhh7=[sin(n*2*pi*f7/fs*2) zeros(1,N)];
hhhhi=[sin(n*2*pi*fi/fs*2) zeros(1,N)];
%休止符
m21=key(2,1,fs);
o2=key(-inf,2,fs);
o4=key(-inf,4,fs);
o8=key(-inf,8,fs);
o16=key(-inf,16,fs);
 
notes=[xhhh3 xhhh4 xhhh5 xhhhh5 xhhhh5 xhhh6 xhh5 xhhh5];
notes=[notes xhhh4 xhhh3 xhhh2 xhhhh3 xhhhh3 xhhh1 dhh5 dhhh5];
notes=[notes dhhh6 dhhh6 dhhh6 dhhh7 xhhh1 xhhh1 xhhh1 xhhh2 xhhh3 xhhh3 xhhh3 xhhh1 xh2];
notes=[notes xhhh3 xhhh4 xhhh5 xhhh5 xhhh6 xhh5 xhhh5 xhhh4 xhhh3 xhhh2 xhhh3 dh6];
notes=[notes dhhh7 xhhh1 xhhh2 xhhh2 xhhh2 xhhhh2 xhhhh3 xhhh4 xhhh4 xhhh5 xhhh4 xhhh3  xhhh2 xhh1];
notes=[notes xhhh3 xhhh5 hh1 hhh1 hhh1 xhhh7 xhh5 xhhh5 xhhh6 xhhh5 xhhh4 xhhh5 xhhh6 xhh5 xhhh5];
notes=[notes o8 xhhh1 dhhh7 dhhh6 dhhh7 xhhh1 xhhh2 xhhh2];
notes=[notes xhhh2 xhh2 xhhh3 xhh4 xhh5 xhhh6 xhhh6 xh6 xh6];
notes=[notes xh5 h1 hhh1 hhh1 hhh1 xhhh7 xh6];
notes=[notes xhh4 xhhh4 xhhh5 xh6  xhhh7 xhhh7 xhhh7 xhhh6 xhh5];
notes=[notes xhh1 xhhh1 xhhh1 dhh7 dhh6 xhh2 xhhh2 xhhh3 xhh4 xhh4];
notes=[notes xhhh5 xhhhh5 xhhhh5 xhhh5 xhhh6 xhhh5 xhh5 xhhh3 xhh2 xhh6 xh5];
notes=[notes xhhh5 xhhhh5 xhhhh5 xhhh5 xhhh6 xhhh5 xhh5 xhhh3 xhh2 xhh5 xh1];

sound(notes,fs);
function g=key(p,n,fs)
t=0:1/fs:3/n;
g=sin(2*pi*(440*2^((p-9)/12))*t);
end