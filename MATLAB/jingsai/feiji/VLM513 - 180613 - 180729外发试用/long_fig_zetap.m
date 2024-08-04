function long_fig_zetap(X,Y,Tname)
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
figure (533)
clf
hold on
set(gcf,'Units','Normalized')
set(gcf,'Position',[.525,.67,.25,.25])
set(gcf,'NumberTitle','off')
set(gcf,'Name','Phugoid Damper vs speed')
title ({'\zeta_p vs speed';'MIL-F-8785C'})

plot(X,Y);

if min(Y(:))<0
    Downlim=3;
elseif min(Y(:))<0.04
    Downlim=2;
else
    Downlim=1;
end

%画基本界限
if Downlim>=1
    KK=plot(X(:,1),.04*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Downlim>=2
    KK=plot(X(:,1),0*ones(nV,1),'k');
    set(KK,'HitTest','off')
end
if Downlim>=3
    KK=plot(X(:,1),-0.0126*ones(nV,1),'k');
    set(KK,'HitTest','off')
end

%画方向阴影
if Downlim>=1
    boundplot(X(:,1),.04*ones(nV,1),'LEVEL 1','','','k');
end
if Downlim>=2
    boundplot(X(:,1),0*ones(nV,1),'LEVEL 2','','','k');
end
if Downlim>=3
    boundplot(X(:,1),-0.0126*ones(nV,1),'LEVEL 3','','','k');
end

xlabel('Airspeed (m/s)')
ylabel('\zeta_p ')
legend(Tname)
end