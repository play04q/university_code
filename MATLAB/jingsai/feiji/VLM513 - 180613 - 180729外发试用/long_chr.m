function [PGD,SP]=long_chr(geo,state,ref,inertias,M_SDRV,cmdline)
% cmdline����
% n-����Ҫ����߶ȡ��ٶȺ�ӭ����Ϣ
% i-ʹ�ò�ֵ��ʽ���
% r-ʹ�����¼��㷽ʽ���
% s-����ʾ8785�ο�����


if nargin<6
    cmdline='';
end

cmdline=lower(cmdline);
if isempty(strfind(cmdline,'n'))
    disp ('-------------------ȷ��������-------->')
    tline=input(['���߶� < Ĭ�� ' num2str(state.ALT) ' > [m] ']);
    if ~isempty(tline)
        state.ALT=tline;
        state.rho=ISAtmosphere(state.ALT);
    end

    tline=input(['����ٶ� < Ĭ�� ' num2str(state.AS) ' > [m/s] ']);
    if ~isempty(tline)
        state.AS=tline;
        state.AS0=state.AS;
    end

    tline=input(['���ӭ�� < Ĭ�� ' num2str(rad2deg(state.alpha)) ' > [m/s] ']);
    if ~isempty(tline)
        state.alpha=deg2rad(tline);
        state.alpha0=state.alpha;
    end
end

disp ('--------------------------->')
disp (['��ǰ���߶�Ϊ�� ' num2str(state.ALT) ' m'])
disp (['    ����ٶ�Ϊ�� ' num2str(state.AS) ' m/s' ])
disp (['    ���ӭ��Ϊ�� ' num2str(rad2deg(state.alpha)) 'Deg'])
disp ('---------------------------------------------------------->')
disp (' ')

%% �������м������Ƿ����Ŀ��ӭ��
interp_need=1;   % 1-��Ҫ�ڲ� 2- �������¼���(��岻�ɿ�)  0-��ֱ�Ӽ�����
for i=1:length(M_SDRV)
    if isminor(state.alpha,M_SDRV(i).alpha)
        interp_need=0;
        idx=i;
        break
    end
    if i>1
        if state.alpha>M_SDRV(i-1).alpha && state.alpha<M_SDRV(i).alpha
            interp_need=1;
        end
    end
end

if interp_need==0
    SDRV=M_SDRV(idx);
end

if interp_need==1
    if ~isempty(strfind(cmdline,'i')) 
        tline='i';
    elseif ~isempty(strfind(cmdline,'r'))
        tline='r';
    else
        tline=input('�������������ļ���������ǰ����ӭ�ǣ���ȷ������������ȡ������[(I)nterpolation or (R)ecauculate <Ĭ��ΪI>]','s');
        if isempty(tline)
            tline='i';
        end
    end
    
    if strcmpi(tline(1),'i') 
        SDRV.alpha=state.alpha;
        SDRV.CL_alpha=interp1([M_SDRV.alpha],[M_SDRV.CL_alpha],state.alpha);
        SDRV.CD_alpha=interp1([M_SDRV.alpha],[M_SDRV.CD_alpha],state.alpha);
        SDRV.CC_alpha=interp1([M_SDRV.alpha],[M_SDRV.CC_alpha],state.alpha);
        SDRV.CX_alpha=interp1([M_SDRV.alpha],[M_SDRV.CX_alpha],state.alpha);
        SDRV.CY_alpha=interp1([M_SDRV.alpha],[M_SDRV.CY_alpha],state.alpha);
        SDRV.CZ_alpha=interp1([M_SDRV.alpha],[M_SDRV.CZ_alpha],state.alpha);
        SDRV.CLm_alpha=interp1([M_SDRV.alpha],[M_SDRV.CLm_alpha],state.alpha);
        SDRV.CMm_alpha=interp1([M_SDRV.alpha],[M_SDRV.CMm_alpha],state.alpha);
        SDRV.CNm_alpha=interp1([M_SDRV.alpha],[M_SDRV.CNm_alpha],state.alpha);
        
        SDRV.CL_Q=interp1([M_SDRV.alpha],[M_SDRV.CL_Q],state.alpha);
        SDRV.CD_Q=interp1([M_SDRV.alpha],[M_SDRV.CD_Q],state.alpha);
        SDRV.CC_Q=interp1([M_SDRV.alpha],[M_SDRV.CC_Q],state.alpha);
        SDRV.CX_Q=interp1([M_SDRV.alpha],[M_SDRV.CX_Q],state.alpha);
        SDRV.CY_Q=interp1([M_SDRV.alpha],[M_SDRV.CY_Q],state.alpha);
        SDRV.CZ_Q=interp1([M_SDRV.alpha],[M_SDRV.CZ_Q],state.alpha);
        SDRV.CLm_Q=interp1([M_SDRV.alpha],[M_SDRV.CLm_Q],state.alpha);
        SDRV.CMm_Q=interp1([M_SDRV.alpha],[M_SDRV.CMm_Q],state.alpha);
        SDRV.CNm_Q=interp1([M_SDRV.alpha],[M_SDRV.CNm_Q],state.alpha);
        
        SDRV.CL=interp1([M_SDRV.alpha],[M_SDRV.CL],state.alpha);
        SDRV.CDi=interp1([M_SDRV.alpha],[M_SDRV.CDi],state.alpha);
        SDRV.CC=interp1([M_SDRV.alpha],[M_SDRV.CC],state.alpha);
        SDRV.CLm=interp1([M_SDRV.alpha],[M_SDRV.CLm],state.alpha);
        SDRV.CMm=interp1([M_SDRV.alpha],[M_SDRV.CMm],state.alpha);
        SDRV.CNm=interp1([M_SDRV.alpha],[M_SDRV.CNm],state.alpha);
    else
        [~,~,~,SDRV]=main_DRVstability(geo,state,ref,'1n');
        SDRV.alpha=state.alpha;
    end
    
elseif interp_need==2
        [~,~,~,SDRV]=main_DRVstability(geo,state,ref,'1n');
        SDRV.alpha=state.alpha;
end


 %% ���㴦��  
eigvalue=long_sdrv2eig(geo,state,ref,inertias,SDRV);
eigvalue=squeeze(eigvalue);
disp(eigvalue);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����
%������Ƶ�ʺ������
parta=real(eigvalue(1));
partb=imag(eigvalue(1));
if partb==0
    SP.omega_n=nan;%Ƶ��
    SP.zeta=nan;%�����
else
    SP.omega_n=sqrt(parta^2+partb^2);%Ƶ��
    SP.zeta=-parta/SP.omega_n;%�����
end
fprintf('������Ƶ�� %7.4f, ����� %7.4f            ',SP.omega_n,SP.zeta)

%������Ƶ�ʺ������
parta=real(eigvalue(3));
partb=imag(eigvalue(3));
if partb==0
    PGD.omega_n=nan;%Ƶ��
    PGD.zeta=nan;%�����
else
    PGD.omega_n=sqrt(parta^2+partb^2);%Ƶ��
    PGD.zeta=-parta/PGD.omega_n;%�����
end
fprintf('������Ƶ�� %7.4f, ����� %7.4f\n',PGD.omega_n,PGD.zeta)

if isempty(strfind(cmdline,'n'))
    disp -----------------------------------------------------
    %long_fig_omeganSP_A()
    %nalpha=.5*state.rho*state.AS^2*ref.S_ref_M*SDRV.CL_alpha/(inertias.m*9.81);
    %loglog(nalpha,SP.omega_n,'x')
        tline=input('���в����������飿 [y or <n>]','s');
    if ~isempty(tline)
        long_modtest(geo,state,ref,inertias,SDRV)
    end    
end


end