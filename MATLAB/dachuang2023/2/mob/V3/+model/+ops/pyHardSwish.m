function Y = pyHardSwish(X)
%PYHARDSWISH Returns hardswish of the input X
% at::Tensor at::hardswish(const at::Tensor &self)

import model.ops.*

Xval = X.value;
Yval = Xval.*min(max(Xval+3,0),6)/6;
Yrank = X.rank;
Y = struct('value', Yval, 'rank', Yrank);

end