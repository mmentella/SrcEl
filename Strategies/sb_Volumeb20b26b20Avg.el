input: len(25),mom(1),delta(0.05);

var: avgv(0);

avgv = Average(volume,len);

if volume > 0 and (volume - avgv)/volume > delta then begin
 
 if c > c[mom] then 
  buy this bar c;
 
 if c < c[mom] then
  sell short this bar c;

end;
