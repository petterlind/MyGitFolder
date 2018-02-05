function b = mysqueeze(a)  
if ~ismatrix(a)
   b = squeeze(a);
else
  b = a;
end