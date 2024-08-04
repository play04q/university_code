cd('H:\VLM513 - 160728_FWOPT')
[CASE]=load_define([pwd '\FWOPT_temp\FWOPT.in']);
isSpanload=0;
nA=length(CASE.Files(1).state.alpha0);
T='n';

[PROC,~]=pre_general(CASE.Files(1),T);


for j=1:nA
    PROC.state.alpha=PROC.state.alpha0(j);
    CurrentResults.potential=solver_ADload(PROC,T);
    CurrentResults=coeff_create3(CurrentResults,PROC);
    CurrentResults.potential.A=CurrentResults.potential.CDi/CurrentResults.potential.CL^2;

    if j>1
        CurrentResults.potential.xNP=PROC.REF.ref_point(1)+(CurrentResults.potential.Mm-Mm0)/(CurrentResults.potential.Z-Z0);
        post_fastview(CurrentResults,PROC,'sweep2');
        if isSpanload==1
            spanload2(PROC,CurrentResults,3);
        end
        if j==nA
            post_fastview([],PROC,'sweep3');
        end
    else
        CurrentResults.potential.xNP=-1;
        if nA==1
            if isempty(find(cmdline,'n'))
                post_fastview(CurrentResults,PROC,'simp');
                if isSpanload==1
                    spanload2(PROC,CurrentResults,1)
                end
            end
        else
            post_fastview(CurrentResults,PROC,'sweep1');
            post_fastview(CurrentResults,PROC,'sweep2');
            if isSpanload==1
                spanload2(PROC,CurrentResults,2);
            end
        end
    end

    Mm0=CurrentResults.potential.Mm;
    Z0=CurrentResults.potential.Z;

    Results.CL(j)=CurrentResults.potential.CL;
    Results.CMm(j)=CurrentResults.potential.CMm;
    Results.CDi(j)=CurrentResults.potential.CDi;
    Results.alpha(j)=rad2deg(CurrentResults.state.alpha);
end

% 升力系数   /  稳定裕度
%         1) 2%        2)  4%       3) 6%     4)  8%
%              
% A  0.05
% B  0.1
% C  0.15
% D  0.2  
% E  0.25
% F  0.3  


for i=1:6
    CL_1=0.05*i;
    %switch i
    %        case 1
    %            CL_1=0.3;
    %        case 2
    %            CL_1=0.25;
    %        case 3
    %            CL_1=0.35;
    %end
    CDi(i,1)=interp1(Results.CL,Results.CDi,CL_1,'pchip', 'extrap');
    alpha(i,1)=interp1(Results.CL,Results.alpha,CL_1,'pchip', 'extrap');
     for j=1:4
         SMargin=0.02*(j);
%         switch j
%             case 1
%                 SMargin=0.08;
%             case 2
%                 SMargin=0.07;
%             case 3
%                 SMargin=0.09;
%         end
        
        
        CMm_T=interp1(Results.CL,Results.CMm,CL_1,'pchip', 'extrap');
        CMm(i,j)=CMm_T-CL_1*SMargin*cos(deg2rad(alpha(i,1)));
    end
end

% CL_1=.5;
% SMargin=.12;
% 
% CMm_T=interp1(Results.CL,Results.CMm,CL_1,'pchip', 'extrap')
% CMm=CMm_T-CL_1*SMargin*cos(deg2rad(alpha(i,j)))


% Y1=polyfit(Results.alpha,Results.CL,1);
% CL_alpha=Y1(1)
% alpha0=-Y1(2)/Y1(1)
% 
% figure(1)
% clf
% hold on
% plot(Results.alpha,Results.CL,'k')
% plot(Results.alpha,CL_alpha*(Results.alpha-alpha0),'r')
% legend('Origin','Fit')
% 
% 
% %Results.alpha,CMm0+(Results.alpha-alpha0)*CMm_alpha)
% %plot(Results.alpha,Results.CMm,Results.alpha,Y2(3)+Results.alpha.^2*Y2(1)+Results.alpha*Y2(2))
% 
% 
% figure(2)
% clf
% hold on
% plot(Results.alpha,Results.CMm,'k')
% 
% Y1=polyfit(Results.alpha,Results.CMm,1);
% CMm_alpha=Y1(1);
% CMm0=Y1(1)*alpha0+Y1(2);
% plot(Results.alpha,CMm0+(Results.alpha-alpha0)*CMm_alpha,'b')
% 
% % Y2=polyfit(Results.alpha,Results.CMm,2);
% % CMm_poly_alpha=Y2;
% % plot(Results.alpha,Y2(3)+Results.alpha*Y2(2)+Results.alpha.^2*Y2(1),'r')
% legend('Origin','Fit1')
% 
% 
% figure(3) 
% clf
% hold on
% plot(Results.alpha,Results.CDi,'k')
% Y2=polyfit(Results.CL(Results.CL>0),Results.CDi((Results.CL>0)),2);
% XX=Results.alpha(Results.CL>0);
% YY=Results.CL(Results.CL>0).^2*Y2(1);
% %(CL_alpha*(XX-alpha0)).^2*Y2(1);
% plot(XX,YY,'r')
% legend('Origin','Fit2')
