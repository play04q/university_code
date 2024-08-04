function Nodes=CATfile_CamberNodes(CATfile,SEC_name,P_nx)
%CATfile='H:\VLM513 - 141220\import\04M_CAT.CATin';
%SEC_name='1-1-0';
%P_nx=[0,.5,1];

%ReadMode 1-�������±��棻2-ֻ���л���

uSEC_name=[SEC_name '-U'];
bSEC_name=[SEC_name '-B'];

uXYZ=CATfile_readSEC(CATfile,uSEC_name);
if ~isempty(uXYZ)
    bXYZ=CATfile_readSEC(CATfile,bSEC_name);
    ReadMode=1;   
    
    LE=(uXYZ(1,:)+bXYZ(1,:))/2;
    TE=(uXYZ(end,:)+bXYZ(end,:))/2;
    nPT=length(uXYZ);
else
    cSEC_name=[SEC_name '-C'];
    cXYZ=CATfile_readSEC(CATfile,cSEC_name);
    ReadMode=2;
    
    LE=cXYZ(1,:);
    TE=cXYZ(end,:);
    nPT=length(cXYZ);
end

cCHORD=TE-LE;

%���ÿ�����Ӧ���������ϵİٷֱ�
if norm(cCHORD)~=0
    M_cCHORD=ones(nPT,1)*cCHORD;    %�ҳ�����
    M_LE=ones(nPT,1)*LE;            %ǰԵ��������
    if ReadMode==1
        %���ǰԵָ��ǰ���������Ȼ���������߷���ͶӰ���ٳ��ҳ��õ�����İٷֱ�
        percent_U=dot(uXYZ-M_LE,M_cCHORD,2)./(norm(cCHORD)^2);    
        percent_B=dot(bXYZ-M_LE,M_cCHORD,2)./(norm(cCHORD)^2);

        interp_U(:,1)=interp1(percent_U,uXYZ(:,1),P_nx,'pchip','extrap'); 
        interp_U(:,2)=interp1(percent_U,uXYZ(:,2),P_nx,'pchip','extrap'); 
        interp_U(:,3)=interp1(percent_U,uXYZ(:,3),P_nx,'pchip','extrap'); 

        interp_B(:,1)=interp1(percent_B,bXYZ(:,1),P_nx,'pchip','extrap'); 
        interp_B(:,2)=interp1(percent_B,bXYZ(:,2),P_nx,'pchip','extrap'); 
        interp_B(:,3)=interp1(percent_B,bXYZ(:,3),P_nx,'pchip','extrap'); 

        Nodes=(interp_U+interp_B)/2;
    else
        percent_C=dot(cXYZ-M_LE,M_cCHORD,2)./(norm(cCHORD)^2);

        interp_C(:,1)=interp1(percent_C,cXYZ(:,1),P_nx,'pchip','extrap'); 
        interp_C(:,2)=interp1(percent_C,cXYZ(:,2),P_nx,'pchip','extrap'); 
        interp_C(:,3)=interp1(percent_C,cXYZ(:,3),P_nx,'pchip','extrap'); 

        Nodes=interp_C;
    end
else
    Nodes=ones(length(P_nx),1)*LE;
end


end
