function y = keytobits(key)
bitsperbyte = 8;
nc = length(key);
y = zeros(1,nc*bitsperbyte);
for i = 1:nc
  v = real(key(i));
  b = 1;
  for j = 1:bitsperbyte
    y(bitsperbyte*(i-1)+j) = rem(floor(v/b),2);
    b = 2*b;
  end
end
