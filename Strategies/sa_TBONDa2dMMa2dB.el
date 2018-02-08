Inputs: nos(2),lenl(20),kl(2),lens(20),ks(2);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2);
vars: trades(0);

if d <> d[1] then begin
 trades = 0;
end;

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if 800 < t data2 and t data2 < 2300 and trades < 1 then begin
 if marketposition < 1 and el and c < upb then
  buy("el") nos shares next bar upb stop;
 if marketposition > -1 and es and c > lob then
  sellshort("es") nos shares next bar lob stop;
end;
