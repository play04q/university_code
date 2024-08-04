function boundplot(X,Y,LabelText,DrctReverse,TextSide,LineSpec)
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

%
% figure (990)
% clf
% hold on
% X=[0 50];
% Y=[0,3];
% LabelText='Level 1';
% plot(X,Y);
% DrctReverse=1;
% TextSide='out';

%plot([0,250],[-20,150])

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


Xlimit=get(gca,'xlim');
Ylimit=get(gca,'ylim');
Xlength_plot=Xlimit(2)-Xlimit(1);
Ylength_plot=Ylimit(2)-Ylimit(1);

set(gca,'Units','points')
POS_gca=get(gca,'Position');
set(gca,'Units','normalized')
Ylength_view=POS_gca(4)-POS_gca(2);
Xlength_view=POS_gca(3)-POS_gca(1);

%theta-图形窗口中数学层面的角度  alpha-图形窗口中显示层面的角度
theta0=atan((Y(end)-Y(1))/(X(end)-X(1)));
LineSpace=(Xlength_plot^2+Ylength_plot^2)^.5/50;
LineLength_view=(Xlength_view^2+Ylength_view^2)^.5/40;
if FLAG==1
    Xstep=LineSpace*cos(theta0);
    Xinterp=X(1):Xstep:X(end);
    idx=fix(length(Xinterp)/2);
    OX=Xinterp(idx);
    Yinterp=interp1(X,Y,Xinterp,'PCHIP');
    OY=Yinterp(idx);
else
    Ystep=LineSpace*sin(theta0);
    Yinterp=Y(1):Ystep:Y(end); 
    idx=fix(length(Yinterp)/2);
    OY=Yinterp(idx);
    Xinterp=interp1(Y,X,Yinterp,'PCHIP');
    OX=Xinterp(idx);
end

theta1=atan((Yinterp(idx+1)-Yinterp(idx))/(Xinterp(idx+1)-Xinterp(idx)));
alpha1=atan(Ylength_view/Ylength_plot*sin(theta1)/(Xlength_view/Xlength_plot*cos(theta1)));
alpha2=alpha1+pi/6;
dX_view=LineLength_view*cos(alpha2);
dY_view=LineLength_view*sin(alpha2);
dX_plot=Xlength_plot/Xlength_view*dX_view;
dY_plot=Ylength_plot/Ylength_view*dY_view;

for i=1:length(Xinterp)
    XX=[Xinterp(i),Xinterp(i)-Drc*dX_plot];
    YY=[Yinterp(i),Yinterp(i)-Drc*dY_plot];
    KK=plot(XX,YY,LineSpec);
    set(KK,'HitTest','off')
end

H=text(OX,OY,LabelText,'Rotation',rad2deg(alpha1));

set(H,'HorizontalAlignment','Center')
if Drc==1 && strcmp(TextSide,'out') || Drc==-1 && strcmp(TextSide,'in')
    set(H,'VerticalAlignment','top')%top
else
    set(H,'VerticalAlignment','bottom')%top
end

set(gca,'xlim',Xlimit)
set(gca,'ylim',Ylimit)
end
