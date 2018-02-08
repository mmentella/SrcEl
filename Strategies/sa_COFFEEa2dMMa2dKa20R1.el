Inputs: nos(2),lenl(50),kl(4.53),lens(43),ks(2.66),adxlen(14),adxlimit(30),maxtrades(1);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),engine(true,data2),el(true,data2),es(true,data2),trades(0);

if currentbar > MaxBarsBack then begin

if d <> d[1] then begin
 trades = 0;
end;

if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upperk;
 es = c data2 > lowerk;
 
 adxval = adx(adxlen)data2;
 
 engine = t data2 < 2000;
end;

//ENGINE
if adxval < adxlimit and engine and trades < maxtrades then begin
 if marketposition < 1 and el and c < upperk then
  buy("el.s") nos shares next bar at upperk stop;
 if marketposition > -1 and es and c > lowerk then
  sellshort("es.s") nos shares next bar at lowerk stop;
end;

end;
