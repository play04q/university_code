function FOIL=CATfile_foil(CATfile,SEC_name)
%上表面坐标，下表面坐标，最大厚度，最大厚度所在位置
%CATfile='H:\VLM513 - 141220\import\s1223.CATin';
%SEC_name='1-1-0';

uSEC_name=[SEC_name '-U'];
bSEC_name=[SEC_name '-B'];
XYZu=CATfile_readSEC(CATfile,uSEC_name);
if isempty(XYZu)
    XYZc=CATfile_readSEC(CATfile,[SEC_name '-C']);
    CamberOnly=1;
    LE=XYZc(1,:);
    TE=XYZc(end,:);
else
    CamberOnly=0;
    XYZb=CATfile_readSEC(CATfile,bSEC_name);
    LE=(XYZu(1,:)+XYZb(1,:))/2;
    TE=(XYZu(end,:)+XYZb(end,:))/2;
end


nPT=length(XYZu);
cCHORD=TE-LE;
C=norm(cCHORD);
xc=0:0.01:1;
%求出每个点对应在翼弦线上的百分比
if norm(cCHORD)~=0 && CamberOnly==0
    M_cCHORD=ones(nPT,1)*cCHORD;
    M_LE=ones(nPT,1)*LE;
    percent_U=dot(XYZu-M_LE,M_cCHORD,2)./(norm(cCHORD)^2);
    percent_B=dot(XYZb-M_LE,M_cCHORD,2)./(norm(cCHORD)^2);
    
    interp_U(:,1)=interp1(percent_U,XYZu(:,1),xc,'PCHIP','extrap'); 
    interp_U(:,2)=interp1(percent_U,XYZu(:,2),xc,'PCHIP','extrap'); 
    interp_U(:,3)=interp1(percent_U,XYZu(:,3),xc,'PCHIP','extrap'); 

    interp_B(:,1)=interp1(percent_B,XYZb(:,1),xc,'PCHIP','extrap'); 
    interp_B(:,2)=interp1(percent_B,XYZb(:,2),xc,'PCHIP','extrap'); 
    interp_B(:,3)=interp1(percent_B,XYZb(:,3),xc,'PCHIP','extrap'); 
    
    %垂直于弦线，由上表面指向下表面的绝对厚度矢量
    T_vector=interp_B-interp_U;    
    %绝对厚度数值
    Tx=(T_vector(:,1).^2+T_vector(:,2).^2+T_vector(:,3).^2).^.5;   
    
    [tc,indx]=max(Tx./C);
    xtc=xc(indx);
else
    interp_U(1:101,:)=ones(101,1)*LE;
    interp_B(1:101,:)=ones(101,1)*LE;
    Tx(1:101)=zeros(1,101);
    tc=0;
    xtc=0;
end

FOIL.xc=xc;           %相对弦长百分比位置
FOIL.XYZu=interp_U;   %相对弦长百分比位置对应的上表面坐标
FOIL.XYZb=interp_B;   %相对弦长百分比位置对应的下表面坐标
FOIL.tc=tc;           %最大相对厚度
FOIL.xtc=xtc;         %最大相对厚度所在弦长百分比
FOIL.Tx=Tx;           %沿弦长方向分布的厚度数值
FOIL.C=C;             %截面弦长

end
