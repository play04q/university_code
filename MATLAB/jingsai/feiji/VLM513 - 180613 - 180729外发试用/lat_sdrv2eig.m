function [M_EIG,M_DYN]=lat_sdrv2eig(PROC,cmdline)
%�������������ʶ����������Ӧ��ģ̬
%����Ӧ�����ٶȡ�ӭ��ɨ�Ӻ͵���״̬��
% MEig[�ٶ�ID,ӭ��ID,ģ̬ID]  1-��ת����  2/3-������  4-���� 
% �������д����ʵ�������ƣ�û�п��ǳ������Ը���ʱ����ô�������ȼ����ߣ����Ȳ�����
if nargin==1
    cmdline='';
end

nV=length(PROC.state.AS0);
nA=length(PROC.M_SDRV);
M_EIG=zeros(nV,nA,4);
for i=1:nV
    PROC.state.AS=PROC.state.AS0(i);
    for j=1:nA
        STB_LATin.DRVs=PROC.M_SDRV(j);
        STB_LATin.AS=PROC.state.AS0(i);
        STB_LATin.rho=PROC.state.rho;
        
        STB_LATin.CD=PROC.M_SDRV.CD;
        
        STB_LATin.ref=PROC.ref;
        STB_LATin.inertias=PROC.inertias;
        
        [eigvalue]=lat_eig(STB_LATin);
        M_EIG(i,j,:)=eigvalue;
    end
    
    %����������
    % �Ӻ���ǰ���ҵ���һ����׼��2��ʵ����2�������״̬
    TMPT=[];
    for j=nA:-1:1
        im=size(find(imag(M_EIG(i,j,:))~=0),1);
        re=size(find(imag(M_EIG(i,j,:))==0),1);
        if im==2 && re==2
            TMPT=j;
            break
        end
    end
    
    if isempty(TMPT)
        Eigs=squeeze(M_EIG)';
        if ~contains(cmdline,'n')
            disp ('ע�⣺��������ģ̬�����У���û�г��ֱ�׼��<��ת������������������>ģ̬')
            disp (Eigs)
        end

        M_DYN(i,j).DR.omega_nd=nan;%Ƶ��
        M_DYN(i,j).DR.zeta_d=nan;%�����
        
        if sum(imag(Eigs)~=0)~=4   %����ʵ��ʱ��
            [~,idx]=min(abs(Eigs));
            R_SPR=Eigs(idx);
            M_DYN(i,j).SPR.T2DA=0.693/R_SPR;
            M_DYN(i,j).SPR.REL=R_SPR;
            M_DYN(i,j).RM.TC=-1/min(Eigs);
        else   %������ʵ��ʱ��
            M_DYN(i,j).SPR.T2DA=nan;
            M_DYN(i,j).SPR.REL=nan;
            M_DYN(i,j).RM.TC=nan;
        end
    end

    if TMPT>=1
        for j=TMPT:-1:1
            if j==TMPT
                LEig=[];
            else
                LEig=squeeze(M_EIG(i,j+1,:));
            end
            CEig=squeeze(M_EIG(i,j,:));
            
            M_EIG(i,j,:)=sortEIG(CEig,LEig);
            M_DYN(i,j)=Eig2DYN(M_EIG(i,j,:));
        end
    end

    if TMPT<nA
        for j=TMPT+1:nA
            LEig=squeeze(M_EIG(i,j-1,:));
            CEig=squeeze(M_EIG(i,j,:));

            M_EIG(i,j,:)=sortEIG(CEig,LEig);
            M_DYN(i,j)=Eig2DYN(M_EIG(i,j,:));
        end

    end


end
end

function DYN_LAT=Eig2DYN(eigvalue)
eigvalue=squeeze(eigvalue);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����

%��ʾ������Ƶ�ʺ������
parta=real(eigvalue(2));
partb=imag(eigvalue(2));

if partb==0
    DYN_LAT.DR.omega_nd=nan;%Ƶ��
    DYN_LAT.DR.zeta_d=nan;%�����
else
    DYN_LAT.DR.omega_nd=sqrt(parta^2+partb^2);%Ƶ��
    DYN_LAT.DR.zeta_d=-parta/DYN_LAT.DR.omega_nd;%�����
end

DYN_LAT.SPR.T2DA=0.693/real(eigvalue(4));
DYN_LAT.SPR.REL=real(eigvalue(4));

DYN_LAT.RM.TC=-1/real(eigvalue(1));

end

function NEig=sortEIG(CEig,LEig)
im=size(find(imag(CEig)~=0),1);
re=size(find(imag(CEig)==0),1);

if im==2 && re==2   %��������ʵ�����������ʱ������
    %���ҳ�����ʵ��ģ̬����������ģ̬
    RSidx=zeros(1,2);   nRS=0;
    DRidx=zeros(1,2);   nDR=0;
    idx=zeros(1,4);
    for k=1:4
        if imag(CEig(k))==0 
            nRS=nRS+1;
            RSidx(nRS)=k;
        else
            nDR=nDR+1;
            DRidx(nDR)=k;
        end
    end
    if abs(CEig(RSidx(1)))>abs(CEig(RSidx(2)))  %�ҵ�����ʵ��ģ̬����ʵ����Ӧ��ת����ģ̬
        idx(1)=RSidx(1);
        idx(4)=RSidx(2);
    else
        idx(1)=RSidx(2);
        idx(4)=RSidx(1);
    end
    if imag(CEig(DRidx(1)))>0    %������ģ̬�����������鲿�������Ǹ��ŵ�ǰ��          
        idx(2)=DRidx(1);
        idx(3)=DRidx(2);
    else
        idx(2)=DRidx(2);
        idx(3)=DRidx(1);
    end
end

if  re==4   %�ĸ�ʵ��ʱ��
    C1=squeeze((LEig(1)+LEig(4))/2);%��ת����������ģ̬��������ֵ
    C2=squeeze((LEig(2)+LEig(3))/2);%������ģ̬������ʵ����ֵ
    %���ҵ���ת����ģ̬�ĸ�
    dis=squeeze(abs(LEig(1)-CEig));
    [~,idx(1)]=min(dis);

    %�ҵ�����ģ̬�ĸ�
    dis=abs(C1-squeeze((CEig(idx(1))+CEig(2:4))/2));  %��ȥǰ��Ĺ�תģ̬ʵ������ʣ��3��
    [~,Tmp]=min(dis);
    idx(4)=Tmp+1;   %��Ϊ1�Ѿ���Ӧ����תģ̬ʵ����

    %ʣ�µ��Ǻ�����ģ̬
    DRidx=zeros(1,2);   nDR=0;
    for k=1:4
        if k~=idx(1) && k~=idx(4)
            nDR=nDR+1;
            DRidx(nDR)=k;
        end
    end
    if CEig(DRidx(1))>CEig(DRidx(2))  %�������˻�ģ̬���Ѵ��ʵ������ǰ��
        idx(2)=DRidx(1);
        idx(3)=DRidx(2);
    else
        idx(2)=DRidx(2);
        idx(3)=DRidx(1);
    end
end

if im==4   %��ʱ��͵����
end

NEig=CEig(idx);
end