clc
clear
close all

%读取飞机的气动参数，有两种方法，一种是VlM的计算结果，一个的文件夹中的excel输入文件
disp ('<---------------数据来源方式-------->')
tline=input(['请选择数据来源:\n[1]VLM计算结果\n[2]Excel文档\n< 默认 2 > \n'],'s');
if strcmp(tline,'1')
    datafrom = 1;
elseif strcmp(tline,'2')
    datafrom = 2;
elseif strcmp(tline,'')
    datafrom = 2;
else
    error('参数错误');
end

%% 设置初始飞行条件
model.init.P = 0;     %模型起始角速度
model.init.Q = 0 / 180 * pi;
model.init.R = 0 / 180 * pi;
%model_init_U在后面重新计算一遍
model.init.V = 0;
model.init.W = 0;

model.init.pitch=0/180*3.14;       %模型的起始欧拉角
model.init.roll=0;
model.init.yaw=0/180*3.14;
uaero0 = [0 0 0 0];        %摇杆微调
sample_time = 1/60;
simulation_pace = 1;      %1是按我们的时间走，要想仿真得快，加大这个数值

%% 导入气动参数
switch datafrom
    case 1      %注明，以下打XX的地方是VLM计算不出来的，用自己设置值，一般是操纵导数还有一些动导数
        [state,ref,inertias,Drvs,Ctrl]=VLM2FG();
        model.init.U=state.AS;
        xme_0=[0 0 -state.ALT];     %模型的起始位置,地球坐标
        
        model.S=ref.S_ref;
        model.mass=inertias.m;
        model.b=ref.b_ref;
        model.c=ref.C_mac_M;
        
        model.Ix=inertias.Ix;
        model.Iy=inertias.Iy;
        model.Iz=inertias.Iz;
        model.Ixy=0;
        model.Iyx=0;
        model.Iyz=0;
        model.Izy=0;
        model.Izx=inertias.Izx;
        model.Ixz=inertias.Izx;
        
        %气动导数
        CD0 = Drvs.CD;
        CD_alpha=Drvs.CD_alpha;
        CD_alpha_dot=0;
        CD_beta=Drvs.CD_beta;
        CD_p=Drvs.CD_P;
        CD_q=Drvs.CD_Q;
        CD_r=Drvs.CD_R;
        CD_da=0;
        CD_de=Ctrl.CD_de;%XXXXXXXX
        CD_dr=0;
        
        CC0=0;
        CC_alpha=0;
        CC_beta=Drvs.CC_beta;
        CC_p=Drvs.CC_P;
        CC_q=Drvs.CC_Q;
        CC_r=Drvs.CC_R;
        CC_da=0;  %XXXXXXXXXXXXXX
        CC_de=0;
        CC_dr=0;   %XXXXXXXXXXXXXXX
        
        CL0=Drvs.CL;
        CL_alpha=Drvs.CL_alpha;
        CL_alpha_dot=0;     %XXXXXXXXXXXXXXX
        CL_beta=Drvs.CL_beta;
        CL_p=Drvs.CL_P;
        CL_q=Drvs.CL_Q;
        CL_r=Drvs.CL_R;
        CL_da=0;
        CL_de=Ctrl.CL_de;  %XXXXXXXXXXXXXXXX
        CL_dr=0;
        
        Clm0=0;
        Clm_alpha=0;
        Clm_beta=Drvs.Clm_beta;
        Clm_p=Drvs.Clm_P;
        Clm_q=0;
        Clm_r=Drvs.Clm_R;
        Clm_da=Ctrl.Clm_da;  %XXXXXXXXXXXXXXX
        Clm_de=0;
        Clm_dr=0;   %XXXXXXXXXXXX
        
        Cmm0 = 0;
        Cmm_alpha=Drvs.Cmm_alpha;
        Cmm_alpha_dot=0;  %XXXXXXXXXXXXXXX
        Cmm_beta=0;
        Cmm_p=Drvs.Cmm_P;
        Cmm_q=Drvs.Cmm_Q;
        Cmm_r=0;
        Cmm_da=0;
        Cmm_de=Ctrl.Cmm_de;   %XXXXXXXXXXXXXXXXXXX
        Cmm_dr=0;
        
        Cnm0 = 0;
        Cnm_alpha=0;
        Cnm_beta=Drvs.Cnm_beta;
        Cnm_p=Drvs.Cnm_P;
        Cnm_q=0;
        Cnm_r=Drvs.Cnm_R;
        Cnm_da=Ctrl.Cnm_da;  %xxxxxxxxxxxxxxxxxx
        Cnm_de=0;
        Cnm_dr=Ctrl.Cnm_dr;   %xxxxxxxxxxxxxxxxx
        
        Engine=Ctrl.ENG;

    case 2
        [FileName,FilePath,~] = uigetfile('*.xlsx');
        if isempty(FileName)
            return
        end
        num=xlsread(strcat(FilePath, FileName));
        %     model_init_U=num(11,11);       %模型起始速度
        %     xme_0=[-1000 400 -100];     %模型的起始位置,地球坐标
        xme_0=[0 0 -100];     %模型的起始位置,地球坐标
        xme_0(3)=-num(11,14);
        [~, ~, ~, rho] = atmosisa(xme_0(3)); %由初始高度求大气密度
        model_rho=rho;
        
        %模型参数
        model.S=num(2,1);
        model.mass=num(2,2);
        model.b=num(2,3);
        model.c=num(2,4);
        %     model_rho=num(2,13);
        
        model.Ix=num(2,6);
        model.Iy=num(2,7);
        model.Iz=num(2,8);
        model.Ixy=num(2,9);
        model.Iyx=model.Ixy;
        model.Iyz=num(2,10);
        model.Izy=model.Iyz;
        model.Izx=num(2,11);
        model.Ixz=model.Izx;
        
        %气动导数
        CD0 = num(11,2);
        CD_alpha=num(5,2);
        CD_alpha_dot=num(5,8);
        CD_beta=0;
        CD_p=num(5,17);
        CD_q=num(5,12);
        CD_r=0;
        CD_da=0;
        CD_de=num(5,14);
        CD_dT=0;  %油门的导数不知道自己设值
        CD_dr=0;
        
        CC0 = 0;
        CC_alpha=0;
        CC_beta=num(8,1);
        CC_p=num(8,4);
        CC_q=0;
        CC_r=num(8,5);
        CC_da=num(8,10);
        CC_de=0;
        CC_dT=0;
        CC_dr=num(8,13);
        
        CL0=num(11,1);
        CL_alpha=num(5,1);
        CL_alpha_dot=num(5,7);
        CL_beta=num(5,16);
        CL_p=0;
        CL_q=num(5,10);
        CL_r=0;
        CL_da=0;
        CL_de=num(5,13);
        CL_dT=0;
        CL_dr=0;
        
        Clm0=0;
        Clm_alpha=0;
        Clm_beta=num(8,2);
        Clm_p=num(8,6);
        Clm_q=0;
        Clm_r=num(8,8);
        Clm_da=num(8,11);
        Clm_de=0;
        Clm_dT=0;
        Clm_dr=num(8,14);
        
        Cmm0=0;
        Cmm_alpha=num(5,3);
        Cmm_alpha_dot=num(5,9);
        Cmm_beta=0;
        Cmm_p=num(8,19);
        Cmm_q=num(5,11);
        Cmm_r=0;
        Cmm_da=0;
        Cmm_de=num(5,15);
        Cmm_dT=0;
        Cmm_dr=0;
        
        Cnm0=0;
        Cnm_alpha=0;
        Cnm_beta=num(8,3);
        Cnm_p=num(8,7);
        Cnm_q=0;
        Cnm_r=num(8,9);
        Cnm_da=num(8,12);
        Cnm_de=0;
        Cnm_dT=0;
        Cnm_dr=num(8,15);
        
        Engine.Thrust=num(11,15);
        Engine.Tcst=num(11,16);
        Engine.Pitch=num(11,17);
        
        model.init.U=sqrt(model.mass * 9.8066/(0.5 * CL0 * model_rho * model.S));
    otherwise
        error('参数错误');
end



















