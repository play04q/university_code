function [chkpass]=isminor(A,B)
minor=1e-3;

if all((abs(A-B)./A)<minor)
    chkpass=true;
else
    chkpass=false;
end

end