function long_fig_omeganSP_A(X,Y,Tname)
if ~exist('X','var')
    X=[5,5;20,20;80,80;90,90];
end
if ~exist('Y','var')
    Y=[1,4;2,5;4,9;3,6];
end
if ~exist('Tname','var')
    Tname={'Test1','Test2'};
end
[nV,~]=size(X);

figure (531)
clf
loglog(X,Y,'-');
hold on
loglog([X(1,:);X(1,:)],[Y(1,:);Y(1,:)],'x');
if nV>3
    loglog(X(2:end-1,:),Y(2:end-1,:),'-*');
else
    loglog([X(2:end-1,:);X(2:end-1,:)],[Y(2:end-1,:);Y(2:end-1,:)],'-*');
end
loglog([X(end,:);X(end,:)],[Y(end,:);Y(end,:)],'o');
legend(Tname)

X=[];
Y=[];
X(1)=100;
Y(1)=(10*100)^.5;
X(2)=1;
Y(2)=10^(log10(Y(1))+0.5*(log10(X(2))-log10(X(1))));
X1=[X(1) X(2)];
Y1=[Y(1) Y(2)];
KK=loglog(X1,Y1,'k');
set(KK,'HitTest','off')

X=[];
Y=[];
X(1)=100;
Y(1)=(3.6*100)^.5;
X(2)=1;
Y(2)=10^(log10(Y(1))+0.5*(log10(X(2))-log10(X(1))));
X2=[X(1) X(2)];
Y2=[Y(1) Y(2)];
KK=loglog(X2,Y2,'k');
set(KK,'HitTest','off')

X=[];
Y=[];
X(1)=100;
Y(1)=(.28*100)^.5;
Y(2)=1;
X(2)=10^((log10(X(1))+((log10(Y(2))-log10(Y(1)))/.5)));
X3=[X(1) X(2) 1];
Y3=[Y(1) Y(2) Y(2)];
KK=loglog(X3,Y3,'k');
set(KK,'HitTest','off')

X=[];
Y=[];
X(1)=100;
Y(1)=(0.16*100)^.5;
Y(2)=0.6;
X(2)=10^((log10(X(1))+((log10(Y(2))-log10(Y(1)))/.5)));
X5=[X(1) X(2)];
Y5=[Y(1) Y(2)];
X6=[X(2) 1];
Y6=[Y(2) Y(2)];
X(3)=1;
Y(3)=10^(log10(Y(1))+0.5*(log10(X(3))-log10(X(1))));
X7=[X(2) X(3)];
Y7=[Y(2) Y(3)];
KK=loglog(X5,Y5,'k');
set(KK,'HitTest','off')
KK=loglog(X6,Y6,'k');
set(KK,'HitTest','off')
KK=loglog(X7,Y7,'k');
set(KK,'HitTest','off')

boundloglog(X1,Y1,'LEVEL 2',1,'','k')
boundloglog(X2,Y2,'LEVEL 1',1,'','k')
boundloglog(X3,Y3,'LEVEL 1','','','k')
boundloglog(X5,Y5,'LEVEL 2&3','','','k')
boundloglog(X6,Y6,'LEVEL 2','','','k')
boundloglog(X7,Y7,'LEVEL 3','','','k')
title ({'Short-period freqency requirements (MIL-F-8785C)';' Category A Flight Phases'})
xlabel('n/\alpha g''s/RAD')
ylabel('\omega_n_S_P  RAD/SEC')
set(gcf,'NumberTitle','off')
set(gcf,'Name','Short-period freq/Category A ')
set(gcf,'Units','Normalized')
set(gcf,'Position',[.005,0.52,.25,.4])
end