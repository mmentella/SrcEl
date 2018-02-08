Inputs: lenl(20),kl(2),lens(20),ks(2);

vars: vup(0),vlo(0);
vars: trades(0);

if d <> d[1] then begin
 trades = 0;
end;

vup = average(h,lenl) + kl*average(absvalue(h - h[1]),lenl);
vlo = average(l,lens) - ks*average(absvalue(l - l[1]),lens);

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if 800 < t and t < 2300 and trades < 1 then begin
 if marketposition < 1 then buy next bar at vup stop;
 if marketposition > -1 then sellshort next bar at vlo stop;
end;
