clc
clear
close all

%��ȡ�ɻ������������������ַ�����һ����VlM�ļ�������һ�����ļ����е�excel�����ļ�
disp ('<---------------������Դ��ʽ-------->')
tline=input(['��ѡ��������Դ:\n[1]VLM������\n[2]Excel�ĵ�\n< Ĭ�� 2 > \n'],'s');
if strcmp(tline,'1')
    datafrom = 1;
elseif strcmp(tline,'2')
    datafrom = 2;
elseif strcmp(tline,'')
    datafrom = 2;
else
    error('��������');
end

%% ���ó�ʼ��������
model.init.P = 0;     %ģ����ʼ���ٶ�
model.init.Q = 0 / 180 * pi;
model.init.R = 0 / 180 * pi;
%model_init_U�ں������¼���һ��
model.init.V = 0;
model.init.W = 0;

model.init.pitch=0/180*3.14;       %ģ�͵���ʼŷ����
model.init.roll=0;
model.init.yaw=0/180*3.14;
uaero0 = [0 0 0 0];        %ҡ��΢��
sample_time = 1/60;
simulation_pace = 1;      %1�ǰ����ǵ�ʱ���ߣ�Ҫ�����ÿ죬�Ӵ������ֵ

%% ������������
switch datafrom
    case 1      %ע�������´�XX�ĵط���VLM���㲻�����ģ����Լ�����ֵ��һ���ǲ��ݵ�������һЩ������
        [state,ref,inertias,Drvs,Ctrl]=VLM2FG();
        model.init.U=state.AS;
        xme_0=[0 0 -state.ALT];     %ģ�͵���ʼλ��,��������
        
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
        
        %��������
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
        %     model_init_U=num(11,11);       %ģ����ʼ�ٶ�
        %     xme_0=[-1000 400 -100];     %ģ�͵���ʼλ��,��������
        xme_0=[0 0 -100];     %ģ�͵���ʼλ��,��������
        xme_0(3)=-num(11,14);
        [~, ~, ~, rho] = atmosisa(xme_0(3)); %�ɳ�ʼ�߶�������ܶ�
        model_rho=rho;
        
        %ģ�Ͳ���
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
        
        %��������
        CD0 = num(11,2);
        CD_alpha=num(5,2);
        CD_alpha_dot=num(5,8);
        CD_beta=0;
        CD_p=num(5,17);
        CD_q=num(5,12);
        CD_r=0;
        CD_da=0;
        CD_de=num(5,14);
        CD_dT=0;  %���ŵĵ�����֪���Լ���ֵ
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
        error('��������');
end



















