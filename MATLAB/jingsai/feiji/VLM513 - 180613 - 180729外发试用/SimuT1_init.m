clc
clear all

load([pwd '\procsave\sdrv_630_B.mat'])
load([pwd '\procsave\cdrv_630_CF_B1.mat'])

[CASE]=load_define([pwd '\import\630.in']);

[nA,nS]=size(M_SDRV.state);
for i=nA:-1:1
    alpha0(i)=M_SDRV.state(i,1).alpha;
end
for i=nS:-1:1
    beta0(i)=M_SDRV.state(1,i).beta;
end

Launch.time=3;               %发射倒计时
Launch.pitch0=deg2rad(10);    %发射仰角  

Launch.Tmax=2800; 
Launch.endur=1.3;

Launch.instANG=deg2rad(20);
Launch.dxyz=[0.00,0.000,0];  %向前 向右 向下偏移

Engine.Tmax=397;
Engine.Tmin=14;
Engine.Tcst=1;
Engine.InstEff=0.87;
Engine.Pitch=deg2rad(0);

%CL CD CC Clm Cmm Cnm
for i=nA:-1:1
    for j=nS:-1:1
        AERO.STC.CL(i,j)=M_SDRV.state(i,j).STC.CL;
        AERO.STC.CD(i,j)=M_SDRV.state(i,j).STC.CD;
        AERO.STC.CC(i,j)=M_SDRV.state(i,j).STC.CC;
        AERO.STC.Clm(i,j)=M_SDRV.state(i,j).STC.Clm;
        AERO.STC.Cmm(i,j)=M_SDRV.state(i,j).STC.Cmm;
        AERO.STC.Cnm(i,j)=M_SDRV.state(i,j).STC.Cnm;
        
        AERO.DYN.CL_p(i,j)=M_SDRV.state(i,j).DRVs.CL_P;
        AERO.DYN.CL_q(i,j)=M_SDRV.state(i,j).DRVs.CL_Q;
        AERO.DYN.CL_r(i,j)=M_SDRV.state(i,j).DRVs.CL_R;
        AERO.DYN.CD_p(i,j)=M_SDRV.state(i,j).DRVs.CD_P;
        AERO.DYN.CD_q(i,j)=M_SDRV.state(i,j).DRVs.CD_Q;
        AERO.DYN.CD_r(i,j)=M_SDRV.state(i,j).DRVs.CD_R;
        AERO.DYN.CC_p(i,j)=M_SDRV.state(i,j).DRVs.CC_P;
        AERO.DYN.CC_q(i,j)=M_SDRV.state(i,j).DRVs.CC_Q;
        AERO.DYN.CC_r(i,j)=M_SDRV.state(i,j).DRVs.CC_R;
        
        AERO.DYN.Clm_p(i,j)=M_SDRV.state(i,j).DRVs.Clm_P;
        AERO.DYN.Clm_q(i,j)=M_SDRV.state(i,j).DRVs.Clm_Q;
        AERO.DYN.Clm_r(i,j)=M_SDRV.state(i,j).DRVs.Clm_R;
        AERO.DYN.Cmm_p(i,j)=M_SDRV.state(i,j).DRVs.Cmm_P;
        AERO.DYN.Cmm_q(i,j)=M_SDRV.state(i,j).DRVs.Cmm_Q;
        AERO.DYN.Cmm_r(i,j)=M_SDRV.state(i,j).DRVs.Cmm_R;
        AERO.DYN.Cnm_p(i,j)=M_SDRV.state(i,j).DRVs.Cnm_P;
        AERO.DYN.Cnm_q(i,j)=M_SDRV.state(i,j).DRVs.Cnm_Q;
        AERO.DYN.Cnm_r(i,j)=M_SDRV.state(i,j).DRVs.Cnm_R;

        AERO.CTL.CL_de(i,j)=(M_CDRV.state(i,j).DRVs.CL_(1)+M_CDRV.state(i,j).DRVs.CL_(2))*2;
        AERO.CTL.CD_de(i,j)=(M_CDRV.state(i,j).DRVs.CD_(1)+M_CDRV.state(i,j).DRVs.CD_(2))*2;
        AERO.CTL.CC_de(i,j)=0;
        AERO.CTL.Clm_de(i,j)=0;
        AERO.CTL.Cmm_de(i,j)=(M_CDRV.state(i,j).DRVs.Cmm_(1)+M_CDRV.state(i,j).DRVs.Cmm_(2))*2;
        AERO.CTL.Cnm_de(i,j)=0;
        
        AERO.CTL.CL_da(i,j)=0;
        AERO.CTL.CD_da(i,j)=0;
        AERO.CTL.CC_da(i,j)=0;
        AERO.CTL.Clm_da(i,j)=(M_CDRV.state(i,j).DRVs.Clm_(1)+M_CDRV.state(i,j).DRVs.Clm_(2))*2;
        AERO.CTL.Cmm_da(i,j)=0;
        AERO.CTL.Cnm_da(i,j)=0;
        
        AERO.CTL.CL_dr(i,j)=0;
        AERO.CTL.CD_dr(i,j)=0;
        AERO.CTL.CC_dr(i,j)=0;
        AERO.CTL.Clm_dr(i,j)=0;
        AERO.CTL.Cmm_dr(i,j)=0;
        AERO.CTL.Cnm_dr(i,j)=-0.01;
    end
end

model.init.U=0.001;
model.init.V = 0;
model.init.W = 0;

model.init.P=0;
model.init.Q=0;
model.init.R=0;

model.init.roll=0;
model.init.pitch=Launch.pitch0;
model.init.yaw=0;

xme_0=[0 0 -5];     %模型的起始位置,地球坐标
        
model.S=M_SDRV.ref.S_ref;
model.b=M_SDRV.ref.b_ref;
model.c=M_SDRV.ref.C_mac_M;

model.mass=CASE.Files.inertias.m;
model.Ix=CASE.Files.inertias.Ix;
model.Iy=CASE.Files.inertias.Iy;
model.Iz=CASE.Files.inertias.Iz;
model.Ixy=CASE.Files.inertias.Ixy;
model.Iyz=CASE.Files.inertias.Iyz;
model.Izx=CASE.Files.inertias.Izx;

 
