function Y_struct = pyFlatten(X, startDim, endDim)
%PYFLATTEN Flatten tensors together along the dimension dim
%at::Tensor at::flatten(const at::Tensor &self, int64_t start_dim = 0, int64_t end_dim = -1)

import model.ops.*

Xrank = X.rank;

% Convert X to reverse-python
[Xval,permRevPythonToDLT] = permuteToReversePyTorch(X.value);


%Extract value  from struct
startDim = startDim.value;
endDim = endDim.value;

% Convert dim to reverse-python
startDim = getReversePythonDim(startDim,Xrank);
endDim   = getReversePythonDim(endDim, Xrank);

inShape = size(Xval);
outShape = {};
j = 1;
for i = 1:Xrank
    if i >= endDim && i<=startDim
        outShape{j} = [];
        if i == startDim
            j = j+1;
        end
    else
        if i>numel(inShape)
            outShape{j} = 1;
        else
            outShape{j} = inShape(i);
        end
            j = j+1;
    end
end

Yval = reshape(Xval,outShape{:});


Xlabel = dims(X.value);

hasChannelDim = false;
channelDim = [];

if isequal(Xlabel,'SSCB') || isequal(Xlabel,'SSSCB')
    channelDim = strfind(Xlabel,'C');
    hasChannelDim = true;
end

if hasChannelDim && startDim == channelDim && endDim ==1 
        Yval = dlarray(Yval,'CB');
        Y_struct = struct('value',Yval,'rank',2);
else
        Yrank = numel(outShape);
        Ylabel = repmat('U',[1,Yrank]);
        Yval = dlarray(Yval,Ylabel);
        Y_struct = struct('value',Yval,'rank',Yrank);
end



end

function dim = getReversePythonDim(dim, Xrank)
    if dim >= 0
        dim = Xrank - dim;
    else
        dim = -dim;
    end
end