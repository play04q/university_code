function [c, s] = wavefast(x, n, varargin)   
error(nargchk(3, 4, nargin));   
if nargin == 3   
   if ischar(varargin{1})      
      [lp, hp] = wavefilter(varargin{1}, 'd');   
   else    
      error('Missing wavelet name.');      
   end   
else   
      lp = varargin{1};     hp = varargin{2};      
end   
fl = length(lp);      sx = size(x);   
if (ndims(x) ~= 2) | (min(sx) < 2) | ~isreal(x) | ~isnumeric(x)   
   error('X must be a real, numeric matrix.');        
end   
if (ndims(lp) ~= 2) | ~isreal(lp) | ~isnumeric(lp) ...   
       | (ndims(hp) ~= 2) | ~isreal(hp) | ~isnumeric(hp) ...   
       | (fl ~= length(hp)) | rem(fl, 2) ~= 0   
   error(['LP and HP must be even and equal length real, ' ...   
          'numeric filter vectors.']);    
end   
if ~isreal(n) | ~isnumeric(n) | (n < 1) | (n > log2(max(sx)))   
   error(['N must be a real scalar between 1 and ' ...   
          'log2(max(size((X))).']);       
end   
% Init the starting output data structures and initial approximation.   
c = [];       s = sx;     app = double(x);   
% For each decomposition ...   
for i = 1:n   
   % Extend the approximation symmetrically.   
   [app, keep] = symextend(app, fl);   
   % Convolve rows with HP and downsample. Then convolve columns   
   % with HP and LP to get the diagonal and vertical coefficients.   
   rows = symconv(app, hp, 'row', fl, keep);   
   coefs = symconv(rows, hp, 'col', fl, keep);   
   c = [coefs(:)' c];    s = [size(coefs); s];   
   coefs = symconv(rows, lp, 'col', fl, keep);   
   c = [coefs(:)' c];   
   % Convolve rows with LP and downsample. Then convolve columns   
   % with HP and LP to get the horizontal and next approximation   
   % coeffcients.   
   rows = symconv(app, lp, 'row', fl, keep);   
   coefs = symconv(rows, hp, 'col', fl, keep);   
   c = [coefs(:)' c];   
   app = symconv(rows, lp, 'col', fl, keep);   
end   
% Append final approximation structures.   
c = [app(:)' c];       s = [size(app); s];   
%-------------------------------------------------------------------%   
function [y, keep] = symextend(x, fl)   
% Compute the number of coefficients to keep after convolution   
% and downsampling. Then extend x in both dimensions.   
keep = floor((fl + size(x) - 1) / 2);   
y = padarray(x, [(fl - 1) (fl - 1)], 'symmetric', 'both');   
%-------------------------------------------------------------------%   
function y = symconv(x, h, type, fl, keep)   
% Convolve the rows or columns of x with h, downsample,   
% and extract the center section since symmetrically extended.   
if strcmp(type, 'row')   
   y = conv2(x, h);   
   y = y(:, 1:2:end);   
   y = y(:, fl / 2 + 1:fl / 2 + keep(2));   
else   
   y = conv2(x, h');   
   y = y(1:2:end, :);   
   y = y(fl / 2 + 1:fl / 2 + keep(1), :);   
end   
