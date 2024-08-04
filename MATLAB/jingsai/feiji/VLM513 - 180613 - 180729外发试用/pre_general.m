function [PROC,Results_friction]=pre_general(File,cmdline)
% V1 附着涡
% P1 控制点   P2 气动力作用点
% cmdline f-不算摩擦力  n-不要各种提示  r-不算几何参考信息 d-不考虑舵面偏转

PROC.state=File.state;
PROC.state.rho=ISAtmosphere(PROC.state.ALT);
PROC.geo=File.geo;
PROC.name=File.name;
PROC.CATfile=File.CATfile;
PROC.ref=File.ref;
PROC.drawtype=File.drawtype;


if ~contains(cmdline,'n')
    tic
    fprintf('生成网格节点.................')
end

PROC.P_nx=pre_NODEpercent(PROC);  %生成网格沿弦向划分的百分比
PROC.NODE=pre_NODE(PROC);    %生成网格节点坐标

if ~contains(cmdline,'r')
    if ~contains(cmdline,'n')
        fprintf('耗时 %2.2f s\n',toc)
        tic
        fprintf('生成几何参考信息.............')
    end

    %生成参考面积，平均气动弦长等信息，
    [PROC.ref]=pre_REFgeo(PROC);
end

if ~contains(cmdline,'n')
    fprintf('耗时 %2.2f s\n',toc)
    tic
    fprintf('生成附着涡涡格...............')
end


[PROC.MESH,PROC.HINGE]=pre_MESH(PROC);  %生成附体网格
if PROC.state.GND_EFF==1
    PROC.sMESH=pre_sMESH(PROC);    
end
%figure (2)
%geometryplot(PROC,2)
PROC.OBJ_MESH=pre_form_MESH(PROC);          %V1->P1\P2  在舵面偏转前预求解一轮

%如果需要计算舵面偏转，则只使用之前计算出的SW信息，其他在偏转舵面后重求
if ~contains(cmdline,'d')
    Is_need_deflect=0;
    for s=1:length(PROC.geo)
        Is_need_deflect=Is_need_deflect || any(any(PROC.geo(s).deflect~=0));
    end
    if Is_need_deflect==1
        PROC.MESH=pre_Deflect(PROC);            %舵面偏转
        if PROC.state.GND_EFF==1
            PROC.sMESH=pre_sMESH(PROC);    
        end
        PROC.OBJ_MESH=pre_form_MESH(PROC);          %V1->P1\P2,重新求解一轮，并不是覆盖原数据
    end
end

if ~contains(cmdline,'f')
    if ~contains(cmdline,'n')
        fprintf('耗时 %2.2f s\n',toc)
        tic
        fprintf('计算零升阻力.................')
    end
    [Results_friction]=solver_friction(PROC);  
else
    Results_friction=[];
end


if ~contains(cmdline,'n')
    fprintf('耗时 %2.2f s\n',toc)
end


end