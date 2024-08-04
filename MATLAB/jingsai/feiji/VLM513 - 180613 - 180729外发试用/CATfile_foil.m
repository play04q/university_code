function FOIL=CATfile_foil(CATfile,SEC_name)
%�ϱ������꣬�±������꣬����ȣ����������λ��
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
%���ÿ�����Ӧ���������ϵİٷֱ�
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
    
    %��ֱ�����ߣ����ϱ���ָ���±���ľ��Ժ��ʸ��
    T_vector=interp_B-interp_U;    
    %���Ժ����ֵ
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

FOIL.xc=xc;           %����ҳ��ٷֱ�λ��
FOIL.XYZu=interp_U;   %����ҳ��ٷֱ�λ�ö�Ӧ���ϱ�������
FOIL.XYZb=interp_B;   %����ҳ��ٷֱ�λ�ö�Ӧ���±�������
FOIL.tc=tc;           %�����Ժ��
FOIL.xtc=xtc;         %�����Ժ�������ҳ��ٷֱ�
FOIL.Tx=Tx;           %���ҳ�����ֲ��ĺ����ֵ
FOIL.C=C;             %�����ҳ�

end
