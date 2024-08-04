function boundloglog(X,Y,LabelText,DrctReverse,TextSide,LineSpec)
%_plot 数值层面的坐标
%_view 窗口层面的坐标
%{
figure (991)
clf
X1=100;
Y1=(10*100)^.5;
X2=1;
Y2=10^(log10(Y1)+0.5*(log10(X2)-log10(X1)));
X=[X1 X2];
Y=[Y1 Y2];
loglog(X,Y)
hold on
loglog([1,100],[1,7])
LabelText='LEVEL 1';
DrctReverse=1;
TextSide='in';
%}

tf=ishold;
if tf~=1
    hold on
end
if ~exist('TextSide','var')
    TextSide='in';
elseif isempty(TextSide)
    TextSide='in';
end
if ~exist('DrctReverse','var')
    DrctReverse=0;
elseif isempty(DrctReverse)
    DrctReverse=0;
end
if ~exist('LabelText','var')
    LabelText='';
end
if ~exist('LineSpec','var')
    LineSpec='b';
elseif isempty(LineSpec)
    LineSpec='b';
end


if X(1)>X(end)
    X=fliplr(X);
    Y=fliplr(Y);
end

if DrctReverse==1
    Drc=-1;
else
    Drc=1;
end

if X(1)~=X(end)
    FLAG=1;
else
    FLAG=2;
end


Xlimit_plot=get(gca,'xlim');
Ylimit_plot=get(gca,'ylim');
set(gca,'Units','points')
POS_gca=get(gca,'Position');
set(gca,'Units','normalized')
Xlimit_view=[POS_gca(1) POS_gca(3)];
Ylimit_view=[POS_gca(2) POS_gca(4)];

Xlength_view=Xlimit_view(2)-Xlimit_view(1);
Ylength_view=Ylimit_view(2)-Ylimit_view(1);

X_view=(log10(X)-log10(Xlimit_plot(1)))/(log10(Xlimit_plot(2))-log10(Xlimit_plot(1)))*Xlength_view;
Y_view=(log10(Y)-log10(Ylimit_plot(1)))/(log10(Ylimit_plot(2))-log10(Ylimit_plot(1)))*Ylength_view;
LineSpace_view=(Xlength_view^2+Ylength_view^2)^.5/50;  %阴影线的间隔

if FLAG==1
    theta_view=atan((Y_view(end)-Y_view(1))/(X_view(end)-X_view(1)));  %原有曲线的方向走势
    alpha_view=theta_view-Drc*pi/6;    %阴影线的角度
    Xinterp_view=X_view(1):LineSpace_view*cos(theta_view):X_view(end);
    Yinterp_view=interp1(X_view,Y_view,Xinterp_view);
elseif FLAG==2
    theta_view=pi/2;
    alpha_view=theta_view-Drc*pi/6;    %阴影线的角度
    Yinterp_view=Y_view(1):LineSpace_view*sin(theta_view):Y_view(end);
    Xinterp_view=interp1(Y_view,X_view,Yinterp_view);
end

Xinterp_plot=Xlimit_plot(1)*((Xlimit_plot(2)/Xlimit_plot(1)).^(Xinterp_view/(Xlength_view)));
Yinterp_plot=Ylimit_plot(1)*((Ylimit_plot(2)/Ylimit_plot(1)).^(Yinterp_view/(Ylength_view)));

LineLength_view=(Xlength_view^2+Ylength_view^2)^.5/40;    %阴影线的长度

for i=1:length(Xinterp_plot)
    dTYPE=0;
    if Drc==1
        if i>1
            FLAG=1;
            A=Xinterp_view(i)-Xinterp_view(i-1);
            B=Yinterp_view(i)-Yinterp_view(i-1);
            if A>0 && B>0
                dTYPE=1;
            end
            if A>0 && B<=0
                dTYPE=2;
            end
        end
    end
    if Drc==-1
        if i<length(Xinterp_plot)
            FLAG=1;
            A=Xinterp_view(i+1)-Xinterp_view(i);
            B=Yinterp_view(i+1)-Yinterp_view(i);
            if A>0 && B>0
                dTYPE=2;
            end
            if A>0 && B<=0
                dTYPE=1;
            end
        end
    end
    if dTYPE~=0
        if dTYPE==1
            dX_view=Drc*LineLength_view*cos(theta_view-5*pi/6);
            dY_view=Drc*LineLength_view*sin(theta_view-5*pi/6);
        elseif dTYPE==2
            dX_view=-Drc*LineLength_view*cos(theta_view+pi/6);
            dY_view=-Drc*LineLength_view*sin(theta_view+pi/6);
        end
        X1_view=Xinterp_view(i)+dX_view;
        Y1_view=Yinterp_view(i)+dY_view;
        X1_plot=Xlimit_plot(1)*((Xlimit_plot(2)/Xlimit_plot(1)).^(X1_view/(Xlength_view)));
        Y1_plot=Ylimit_plot(1)*((Ylimit_plot(2)/Ylimit_plot(1)).^(Y1_view/(Ylength_view)));
        
        XX=[Xinterp_plot(i) X1_plot];
        YY=[Yinterp_plot(i) Y1_plot];
        KK=loglog(XX,YY,LineSpec);
        set(KK,'HitTest','off')
    end
end
    



idx=fix(length(Xinterp_view)/2);
OX_view=Xinterp_view(idx);
OY_view=Yinterp_view(idx);
Otheta_view=atan((Yinterp_view(idx+1)-Yinterp_view(idx))/(Xinterp_view(idx+1)-Xinterp_view(idx)));
OX_plot=Xlimit_plot(1)*((Xlimit_plot(2)/Xlimit_plot(1)).^(OX_view/(Xlength_view)));
OY_plot=Ylimit_plot(1)*((Ylimit_plot(2)/Ylimit_plot(1)).^(OY_view/(Ylength_view)));

H=text(OX_plot,OY_plot,LabelText,'Rotation',rad2deg(Otheta_view));

set(H,'HorizontalAlignment','Center')
if Drc==1 && strcmp(TextSide,'out') || Drc==-1 && strcmp(TextSide,'in')
    set(H,'VerticalAlignment','top')%top
else
    set(H,'VerticalAlignment','bottom')%top
end

set(gca,'xlim',Xlimit_plot)
set(gca,'ylim',Ylimit_plot)
axis normal
if tf~=1
    hold off
end
end
