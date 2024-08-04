function long_modtest(geo,state,ref,inertias,Drvs)
loop=1;
while loop==1
    post_fastview(geo,state,ref,Drvs,'DRV_S_LONG')
    q1=lower(input('需要修改项: ','s'));

    if isempty(q1)
        return
    end

    q2=input('新值: ','s');

%Coeff/dev 	      1.  d_beta 	         2.  d_P 	         3.  d_R 
%   A.   CC 	         -0.0216 	          0.1345 	          0.0005
%   B.  CLm 	          0.0232 	         -0.3706 	          0.0095
%   C.  CNm 	          0.0080 	         -0.0498 	         -0.0019

    switch q1
        case 'a1'
            if strcmp(q2,'-')
                Drvs.CC_beta=-Drvs.CC_beta;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CC_beta=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'a2'
             if strcmp(q2,'-')
                Drvs.CC_P=-Drvs.CC_P;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CC_P=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'a3'
             if strcmp(q2,'-')
                Drvs.CC_R=-Drvs.CC_R;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CC_R=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        
        case 'b1'
            if strcmp(q2,'-')
                Drvs.CLm_beta=-Drvs.CLm_beta;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CLm_beta=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'b2'
             if strcmp(q2,'-')
                Drvs.CLm_P=-Drvs.CLm_P;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CLm_P=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'b3'
             if strcmp(q2,'-')
                Drvs.CLm_R=-Drvs.CLm_R;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CLm_R=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
            
        case 'c1'
            if strcmp(q2,'-')
                Drvs.CNm_beta=-Drvs.CNm_beta;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CNm_beta=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'c2'
             if strcmp(q2,'-')
                Drvs.CNm_P=-Drvs.CNm_P;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CNm_P=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
        case 'c3'
             if strcmp(q2,'-')
                Drvs.CNm_R=-Drvs.CNm_R;
            elseif ~isnan(str2double(q2))  && ~isempty(q2)
                Drvs.CNm_R=str2double(q2);
            end
            lat_chr(geo,state,ref,inertias,Drvs,'ni');
            disp ------------------------------------------------
    
    end

end

end