alf=5*pi/180;   sita=5*pi/180;   cita=3*pi/180;

a11=0.0672 ;a12=0.0000;a13=-9.7628;a14=-0.5767;a15=-0.0777;a16=1.25;
a21=3.3450;a22=0.3345;a23=0.0000;a24=0.3345;a25=0.3345;a26=14.2045;
a31=6.6033;a32=0;a33=0.0854;a34=7.2878;a35=6.5378;a36=0.125;
%%%%%%%%纵向动力系数
b11=5.368;b12=5.368;b13=0;b14=5.368;b15=5.368;b16=0;b17=5.368;b18=9.3721;
b21=1.8436;b22=1.8436;b23=0;b24=1.8436;b25=1.8436;b26=0;b27=0;b28=0.3129;
b31=0;b32=-0.9976;b33=0;b34=0.6654;b35=-0.8457;b36=-9.787;b37=0;b38=-0.125;
%%%%%%%%横向动力系数


%%%%%%纵向
Ag1=[a11 a14-a13 0 a13;
   -a13 -a34+a33 1 -a33;
   a21-a24*a31 -a24*a34+a24*a33+a24 a22+a24 -a24*a33;
   0 0 1 0]
Bg1=[0 a25-a24*a35 -a35 0]'
%%%
P1=poly(Ag1)
A1=[a35*(a13-a14);%速度
    a22*a35*(a14-a13)-a13*a35*a24+a25*a14;
    a25*(a34*a13-a14*a33)-a24*a35*a13]
B1=[a25-a35*a24;%俯仰角
    a35*(a11*a24-a24)+a25*(a34-a11-a33);
    a35*(a11*a24-a21)*(a14-a13)+a25*(a31*(a14-a13)-a11*(a34-a33))]
C1=[a35;%角速度q
    -a35*(a11+a22+a24);
    a35*(a11*(a22+a24)-a24)+a25*a34;
    a35*(a11*a24-a21*a14)-a25*(a11*a34-a14*a31)]
D1=[-a35;%攻角
    a35*(a22+a11)+a25;
    -a35*a11*a22-a25*(a11+a33);
    -a35*a21*a13-a25*(a13*a31-a11*a33)]

%%%%%%横向
Ag2=[5*pi\180 -(5*pi\180)*tan(5*pi\180)+b32 a33-b34 -b36;
     b11       b12           b14     0;
     1      -tan(5*pi\180)    0     0;
     b21*b21*(5*pi\180)   b22-b24*b32-b24*tan(5*pi\180) b24-b24*(b34-a33)  -b36*b24]
Bg2=[-b35;b17+b15;0;b25-b24*b25]
P2=poly(Ag2)
A2=-b17.*[1;%X角速度
    (b34-a33)-b22-b24*(-alf*tan(cita)-b32);
    -b22*(b34-a33)-b24*b36*tan(cita)-b24*(-alf*tan(cita)-b32);
    -b24*b36*tan(cita)]
B2=-b17.*[b21+alf*b24;%Y角速度
    b21*(b34-a33)-b24*b36+alf*b24;
    -b24*b36]
C2=-b17.*[alf;%侧滑角
    -b21*b32-b36-alf*(b21*tan(cita)+b22);
    b36*(b21*tan(cita)+b22)]
D2=-b17.*[1;%倾斜角
    (b34-a33)-(b21*tan(cita)+b22)+b24*b32;
    b24*b32-(b21*tan(cita)+b22)*(b34-a33)]