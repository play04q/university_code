function [PROC,Results_friction]=pre_general(File,cmdline)
% V1 ������
% P1 ���Ƶ�   P2 ���������õ�
% cmdline f-����Ħ����  n-��Ҫ������ʾ  r-���㼸�βο���Ϣ d-�����Ƕ���ƫת

PROC.state=File.state;
PROC.state.rho=ISAtmosphere(PROC.state.ALT);
PROC.geo=File.geo;
PROC.name=File.name;
PROC.CATfile=File.CATfile;
PROC.ref=File.ref;
PROC.drawtype=File.drawtype;


if ~contains(cmdline,'n')
    tic
    fprintf('��������ڵ�.................')
end

PROC.P_nx=pre_NODEpercent(PROC);  %�������������򻮷ֵİٷֱ�
PROC.NODE=pre_NODE(PROC);    %��������ڵ�����

if ~contains(cmdline,'r')
    if ~contains(cmdline,'n')
        fprintf('��ʱ %2.2f s\n',toc)
        tic
        fprintf('���ɼ��βο���Ϣ.............')
    end

    %���ɲο������ƽ�������ҳ�����Ϣ��
    [PROC.ref]=pre_REFgeo(PROC);
end

if ~contains(cmdline,'n')
    fprintf('��ʱ %2.2f s\n',toc)
    tic
    fprintf('���ɸ������и�...............')
end


[PROC.MESH,PROC.HINGE]=pre_MESH(PROC);  %���ɸ�������
if PROC.state.GND_EFF==1
    PROC.sMESH=pre_sMESH(PROC);    
end
%figure (2)
%geometryplot(PROC,2)
PROC.OBJ_MESH=pre_form_MESH(PROC);          %V1->P1\P2  �ڶ���ƫתǰԤ���һ��

%�����Ҫ�������ƫת����ֻʹ��֮ǰ�������SW��Ϣ��������ƫת���������
if ~contains(cmdline,'d')
    Is_need_deflect=0;
    for s=1:length(PROC.geo)
        Is_need_deflect=Is_need_deflect || any(any(PROC.geo(s).deflect~=0));
    end
    if Is_need_deflect==1
        PROC.MESH=pre_Deflect(PROC);            %����ƫת
        if PROC.state.GND_EFF==1
            PROC.sMESH=pre_sMESH(PROC);    
        end
        PROC.OBJ_MESH=pre_form_MESH(PROC);          %V1->P1\P2,�������һ�֣������Ǹ���ԭ����
    end
end

if ~contains(cmdline,'f')
    if ~contains(cmdline,'n')
        fprintf('��ʱ %2.2f s\n',toc)
        tic
        fprintf('������������.................')
    end
    [Results_friction]=solver_friction(PROC);  
else
    Results_friction=[];
end


if ~contains(cmdline,'n')
    fprintf('��ʱ %2.2f s\n',toc)
end


end