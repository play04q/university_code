figure (991)
clf


X=[];
Y=[];
X(1)=100;
Y(1)=(.28*100)^.5;
Y(2)=1;
X(2)=10^((log10(X(1))+((log10(Y(2))-log10(Y(1)))/.5)));
X3=[X(1) X(2) 1];
Y3=[Y(1) Y(2) Y(2)];
loglog(X3,Y3)
hold on


boundloglog(X3,Y3,'LEVEL 1',0,'out')



