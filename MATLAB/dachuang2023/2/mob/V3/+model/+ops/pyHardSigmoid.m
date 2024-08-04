function Y = pyHardSigmoid(X)
%PYHARDSIGMOID Returns hardsigmoid of the input X
% at::Tensor at::hardsigmoid(const at::Tensor &self)

import model.ops.*

Xval = X.value;
Yval = Xval;
Yval(Xval <= -3) = 0;
Yval(Xval >= 3) = 1;
idx = Xval > -3 & Xval <3;
Yval(idx) = Xval(idx)./6 + 0.5;
Yrank = X.rank;
Y = struct('value', Yval, 'rank', Yrank);

end