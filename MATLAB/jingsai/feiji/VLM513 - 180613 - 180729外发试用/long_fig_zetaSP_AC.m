function long_fig_zetaSP_AC(X,Y,Tname)
if ~exist('X','var')
    X=[10,10;20,20;30,30];
end
if ~exist('Y','var')
    Y=[.38,.5;.6,.92;1,.4];
end
if ~exist('Tname','var')
    Tname={'Test1','Test2'};
end
[nV,~]=size(X);
figure (532)
clf
hold on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.265,.67,.25,.25])
set(gcf,'NumberTitle','off')
set(gcf,'Name','Short-period Damper vs speed')
title ({'\zeta_S_P vs speed';'MIL-F-8785C Category A Flight Phases'})

plot(X,Y);
if max(Y(:))>1.3
    Uplim=2;
else
    Uplim=1;
end
if min(Y(:))<.25
    Downlim=3;
elseif min(Y(:))<.35
    Downlim=2;
else
    Downlim=1;
end

%画基本界限
if Uplim>=1
    KK=plot(X(:,1),1.3*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Uplim>=2
    KK=plot(X(:,1),2*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Downlim>=1
    KK=plot(X(:,1),.35*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Downlim>=2
    KK=plot(X(:,1),.25*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Downlim>=3
    KK=plot(X(:,1),.15*ones(nV,1),'k');
    set(KK,'HitTest','off')
end

%画方向阴影
if Uplim>=1
    boundplot(X(:,1),1.3*ones(nV,1),'LEVEL 1',1,'','k');
end
if Uplim>=2
    boundplot(X(:,1),  2*ones(nV,1),'LEVEL 2',1,'','k');
end
if Downlim>=1
    boundplot(X(:,1),.35*ones(nV,1),'LEVEL 1','','','k');
end
if Downlim>=2
    boundplot(X(:,1),.25*ones(nV,1),'LEVEL 2','','','k');
end
if Downlim>=3
    boundplot(X(:,1),.15*ones(nV,1),'LEVEL 3','','','k');
end

xlabel('Airspeed (m/s)')
ylabel('\zeta_S_P ')
legend(Tname)
end