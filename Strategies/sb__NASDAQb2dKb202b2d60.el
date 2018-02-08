Inputs: NoS(2),LenL(3),KL(1.5),LenS(19),KS(3.5),ADXLen(14),ADXLimit(30);
Inputs: StopL(700),StopS(800),TL(700),TS(800),TRSL(2300),TRSS(2400);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0); 

upperk = keltnerchannel(h,lenl,kl)data2;
lowerk = keltnerchannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2; 

if marketposition <> 0 then begin  
 //STOPLOSS
 setstopshare;
 if marketposition = 1 then setstoploss(stopl);
 if marketposition = -1 then setstoploss(stops);
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
 end;
 //TRAILING STOP
 if currentcontracts = nos/2 then begin
  if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
 end;
end;
//ENGINE
if adxval < adxlimit then begin
 if marketposition < 1 and c data2 < upperk then
  buy("long") nos shares next bar at upperk stop;
 if marketposition > -1 and c data2 > lowerk then
  sellshort("short") nos shares next bar at lowerk stop;
end;
