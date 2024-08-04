cd('H:\VLM513 - 141220_PHD')
[CASE]=load_define([pwd '\PHD_temp\PHD_wing.in']);
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

alpha=interp1(Results.CL,PROC.state.alpha0,0.5,'pchip', 'extrap');

PROC.state.alpha=alpha;
CurrentResults.potential=solver_ADload(PROC,T);
CurrentResults=coeff_create3(CurrentResults,PROC);
CurrentResults.potential.A=0; 
CurrentResults.potential.xNP=0;    

post_fastview(CurrentResults,PROC,'sweep2');
spanload2(PROC,CurrentResults,1)
    