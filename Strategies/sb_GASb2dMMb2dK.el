inputs: nos(2),lenl(20),kl(2),lens(36),ks(2),adxlen(14),adxlimit(30);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2),adxval(0,data2);
vars: trades(0),mp(0);

if d <> d[1] then begin
 trades = 0;
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 800 < t data2 and t data2 < 2300;
 
 adxval = adx(adxlen)data2;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

if engine and trades < 1 then begin
 if marketposition < 1 and el and c < upk then
  buy("el") nos shares next bar at upk stop;
 if marketposition > -1 and es and c > lok then
  sellshort("es") nos shares next bar at lok stop;
end;

