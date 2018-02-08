Inputs: NoS(2),LenL(23),KL(2),LenS(36),KS(1.98),alfa(.15);
Inputs: StopLoss(1100),BRKL(800),BRKS(500),TL(1800),TS(1650),TRSL(1200),TRSS(300);

vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0),el(true,data2),es(true,data2);

if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];
 
 el = c data2 < upperk and range data2 < AvgTrueRange(lenl) data2;
 es = c data2 > lowerk and range data2 < AvgTrueRange(lens) data2;
 
 adxval = adx(14)data2;
end;

if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  //STOPLOSS
  setstopshare;
  setstoploss(stoploss);
  
  //BREAKEVEN
  if mpp > brkl/bigpointvalue then if marketposition = 1 then
   sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  if mpp > brks/bigpointvalue then if marketposition = -1 then
   buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
  
  //TRAILING STOP
  if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
  
 end;
 
 //ENGINE
 if adxval < 30 and TradesToday(d) = 0 then begin
  if marketposition < 1 and el and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and es and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
 
end;
