function [key] = wmdeseq(y)
bitsperbyte = 8;
[nr,nc] = size(y);
nch = ceil(nc/bitsperbyte);
key = char(' '*ones(nr,nch));
for  i = 1:nr
  for j = 1:nch
    v = 0;
    b = 1;
    for k = 1:bitsperbyte
      if y(i,(j-1)*bitsperbyte+k)
        v = v+b;
      end
      b = 2*b;
    end
    key(i,j) = char(v);
  end
end
