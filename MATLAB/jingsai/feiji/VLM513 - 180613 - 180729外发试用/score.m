function s=score(x,met)
%x=[0,0.05,0.08,0.19];
%met='dr';

s=[];

if strcmpi(met,'DR_product')
    s=(-3)*exp(-x./0.12331) + 3;
    s(x<0)=0;
    s(isnan(s))=0;
end

if strcmpi(met,'DR_zeta_d')
    s=(-3)*exp(-x./0.04933) + 3;
    s(x<0)=0;
end

if strcmpi(met,'SPR_REL')
    s=(-3)*exp(-(0.17325-x)./0.21365) + 3;
    s(0.17325-x<0)=0;
end




if strcmpi(met,'total')
    N=numel(x);
    s=prod(x)^(1/N)*.5+min(x)*.5;
end


%disp (s)
end

