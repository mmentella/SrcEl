inputs: nos(1),lenl(24),kl(2.14),lens(82),ks(2.04);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2);

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 800 < t data2 and t data2 < 2300;
end;

if engine then begin
 if marketposition < 1 and el and c < upb then
  buy("el") nos shares next bar at upb stop;
 if marketposition > -1 and es and c > lob then
  sellshort("es") nos shares next bar at lob stop;
end;
