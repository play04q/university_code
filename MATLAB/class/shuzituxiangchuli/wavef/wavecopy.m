function y = wavecopy(type, c, s, n)   
error(nargchk(3, 4, nargin));   
if nargin == 4      
   y = wavework('copy', type, c, s, n);   
else     
   y = wavework('copy', type, c, s);     
end
