function lat_modtest2(PROC,DYN_LAT0)
loop=1;
post_fastview(PROC.M_SDRV,PROC,'DRV_S_LAT')
while loop==1
    q1=lower(input('Which term need to be change (use & for both): ','s'));

    if isempty(q1)
        return
    end

    %Coeff/dev 	      1.  d_beta 	         2.  d_P 	         3.  d_R 
    %   A.   CC 	         -0.0216 	          0.1345 	          0.0005
    %   B.  CLm 	          0.0232 	         -0.3706 	          0.0095
    %   C.  CNm 	          0.0080 	         -0.0498 	         -0.0019
    Q=strtrim(split(q1,'&'));
    nQ=length(Q);
    SWP=zeros(1,nQ);
    
    nLoop=30;
    DR.zeta_d=zeros(1,nLoop);
    DR.omega_nd=zeros(1,nLoop);
    SPR.T2DA=zeros(1,nLoop);
    RM.TC=zeros(1,nLoop);
    VV=zeros(nQ,nLoop+1);
    
    if nQ>1
        QType='multi';
        xtext='Vari% of ' ;
    else
        QType='single';
        xtext=[];
    end
    
    for i=1:nQ
        
        switch Q{i}
            case 'a1'
                SWP=PROC.M_SDRV.CC_beta;
                ttext='CC.beta'; 
            case 'a2'
                SWP=PROC.M_SDRV.CC_P;
                ttext='CC.P'; 
            case 'a3'
                SWP=PROC.M_SDRV.CC_R;
                ttext='CC.R'; 
            case 'b1'
                SWP=PROC.M_SDRV.Clm_beta;
                ttext='Clm.beta'; 
            case 'b2'
                SWP=PROC.M_SDRV.Clm_P;
                ttext='Clm.P'; 
            case 'b3'
                SWP=PROC.M_SDRV.Clm_R;
                ttext='Clm.R'; 
            case 'c1'
                SWP=PROC.M_SDRV.Cnm_beta;
                ttext='Cnm.beta'; 
            case 'c2'
                SWP=PROC.M_SDRV.Cnm_P;
                ttext='Cnm.P'; 
            case 'c3'
                SWP=PROC.M_SDRV.Cnm_R;
                ttext='Cnm.R'; 
        end  %switch q1
        if nQ>1 && i<nQ
            xtext=[xtext ttext ' & ']; %#ok<AGROW>
        else
            xtext=[xtext ttext]; %#ok<AGROW>
        end
        
        if SWP>0
            SWPA=-SWP;
            SWPB=3*SWP;
        else
            SWPA=3*SWP;
            SWPB=-SWP;
        end
        
        fprintf('Derivative Variation Range of %s: [ %6.4f>%6.4f ] for Default \n --->    ',ttext,SWPA,SWPB)
        tline=input('','s');
        if ~isempty(tline)
            A2=strfind(tline,'>');
            if ~isempty(A2)   %是否有速度范围
                if A2~=1   %‘xxxxx>’
                    SWPA=str2double(tline(1:A2-1));
                end
                if A2~=length(tline)  %‘>xxxxx’
                    SWPB=str2double(tline(A2+1:end));
                end
            end
        end
        VV(i,:)=SWPA:(SWPB-SWPA)/nLoop:SWPB;
    end
    
    tmpFILE=PROC;
    for i=1:nLoop+1
        for j=1:nQ
            switch Q{j}
                case 'a1'
                    tmpFILE.M_SDRV.CC_beta=VV(j,i); 
                case 'a2'
                    tmpFILE.M_SDRV.CC_P=VV(j,i);
                case 'a3'
                    tmpFILE.M_SDRV.CC_R=VV(j,i);
                case 'b1'
                    tmpFILE.M_SDRV.Clm_beta=VV(j,i);
                case 'b2'
                    tmpFILE.M_SDRV.Clm_P=VV(j,i);
                case 'b3'
                    tmpFILE.M_SDRV.Clm_R=VV(j,i);
                case 'c1'
                    tmpFILE.M_SDRV.Cnm_beta=VV(j,i);
                case 'c2'
                    tmpFILE.M_SDRV.Cnm_P=VV(j,i);
                case 'c3'
                    tmpFILE.M_SDRV.Cnm_R=VV(j,i);
            end  %switch q1
        end
        
        [~,DYN_LAT]=lat_sdrv2eig(tmpFILE,'n');
        DR.zeta_d(i)=DYN_LAT.DR.zeta_d;
        DR.omega_nd(i)=DYN_LAT.DR.omega_nd;
        SPR.T2DA(i)=DYN_LAT.SPR.T2DA;
        RM.TC(i)=DYN_LAT.RM.TC;
    end
    
    figure (61)
    clf
    set(gcf,'Units','Normalized')
    set(gcf,'Position',[.05,0.4,.7,.5])
    set(gcf,'NumberTitle','off')
    set(gcf,'Name',['Lateral mode characters vs ' xtext ])
    if strcmp(QType,'single')
        XX=VV;
        QX=SWP;
    else
        XX=VV(1,:)-VV(1,1)/(VV(1,end)-VV(1,1));
        QX=(SWP-VV(end,1))/(VV(end,end)-VV(end,1));
    end
    

    H_plot(1)=subplot(2,3,1);
    hold on
    title (['\omega_n_d vs ' xtext])
    plot(XX,DR.omega_nd)
    xlabel(xtext)
    ylabel('DR \omega_n_d ')
    QY=DYN_LAT0.DR.omega_nd;
    text(QX,QY,'\leftarrow Origin point')


    H_plot(2)=subplot(2,3,2);
    hold on
    title (['\zeta_d vs ' xtext])
    plot(XX,DR.zeta_d)
    xlabel(xtext)
    ylabel('DR \zeta_d ')
    QY=DYN_LAT0.DR.zeta_d;
    text(QX,QY,'\leftarrow Origin point')


    H_plot(3)=subplot(2,3,3);
    hold on
    title (['\zeta_d\omega_n_d vs ' xtext])
    plot(XX,DR.zeta_d.*DR.omega_nd)
    xlabel(xtext)
    ylabel('DR \zeta_d\omega_n_d ')
    QY=DYN_LAT0.DR.zeta_d*DYN_LAT0.DR.omega_nd;
    text(QX,QY,'\leftarrow Origin point')


    H_plot(4)=subplot(2,3,4);
    hold on
    title (['Spiral time to double(sec) vs ' xtext])
    plot(XX,SPR.T2DA)
    xlabel(xtext)
    ylabel('SPR T2DA(sec) ')
    QY=DYN_LAT0.SPR.T2DA;
    text(QX,QY,'\leftarrow Origin point')


    H_plot(5)=subplot(2,3,5);
    hold on
    title (['Roll-mode time constant vs ' xtext])
    plot(XX,RM.TC)
    xlabel(xtext)
    ylabel('Roll-mode \tau_R(sec)')
    QY=DYN_LAT0.RM.TC;
    text(QX,QY,'\leftarrow Origin point')
    linkaxes(H_plot,'x')

    subplot(2,3,6)
    hold on
    axis off
    text(.3,.9,['Origin ' xtext ' = ' num2str(SWP)])
    text(.5,.8,'--Dutch Roll--')
    text(.2,.7,['\zeta_d      ' num2str(DYN_LAT0.DR.zeta_d)])
    text(.2,.6,['\omega_n_d   ' num2str(DYN_LAT0.DR.omega_nd)])
    text(.2,.5,['\zeta_d\omega_n_d  ' num2str(DYN_LAT0.DR.omega_nd*DYN_LAT0.DR.zeta_d)])
    text(.5,.35,'---Spiral---')
    text(.2,.25,['Time to Double(sec)  ' num2str(DYN_LAT.SPR.T2DA)])
    text(.5,.1,'--Roll Mode--')
    text(.2,.0,['Time Constant    ' num2str(DYN_LAT.RM.TC)])
end %while

end