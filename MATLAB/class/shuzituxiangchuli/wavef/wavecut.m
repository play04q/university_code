function [nc, y] = wavecut(type, c, s, n)  
error(nargchk(3, 4, nargin));  
if nargin == 4     
   [nc, y] = wavework('cut', type, c, s, n);  
else    
   [nc, y] = wavework('cut', type, c, s);    
end
