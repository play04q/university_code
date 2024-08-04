function output=splitstr(strin,cterm)
output=[];
if isempty(strin)
    return
end
A=findstr(strin,cterm);
if isempty(A)
    output=strin;
    return
end
for i=1:length(A)
    if i==1
        output=[output;{strin(1:A(1)-1)}];
    else
        output=[output;{strin(A(i-1)+1:A(i)-1)}];
    end
    if i==length(A)
        if A(i)==length(strin)
            output=[output;{''}];
        else
            output=[output;{strin(A(i)+1:end)}];
        end
    end
end
end