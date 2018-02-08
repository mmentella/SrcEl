Inputs:NoS(2),LenL(6),FactorL(2.01),LenS(5),FactorS(3.27),ADXLen(15),ADXLimit(25);
Inputs: StopLoss(1800),BRK(1600),TL(2300),TS(2300),TRSL(5300),TRSS(1600),PTL(10600),PTS(5700);

Vars: UpperK(0,data2),LowerK(0,data2),ADXVal(0,data2),mpp(0);

UpperK = KeltnerChannel(H, LenL, FactorL)data2;
LowerK = KeltnerChannel(L, LenS, -FactorS)data2;
ADXVal = ADX(ADXLen)data2;

if marketposition <> 0 then begin
 
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
 
 //STOPLOSS
 setstopshare;
 setstoploss(stoploss);
 
 //BREAKEVEN
 if mpp > brk/bigpointvalue then begin
  if marketposition = 1 then sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  if marketposition = -1 then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
 end;
 
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
 end;
 
 //TRAILING STOP & PROFIT TARGET
 if currentcontracts = nos/2 then begin
  if marketposition = 1 then begin
   sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
   setprofittarget(ptl);
  end;
  if marketposition = -1 then begin
   buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
   setprofittarget(pts);
  end;
 end;
 
end;

if adxval < adxlimit then begin
 if MarketPosition < 1 and c data2 < upperk and c < upperk then
  buy("long") nos shares next bar at upperk stop;
 if marketposition > -1 and c data2 > lowerk and c > lowerk then
  sellshort("short") nos shares next bar at lowerk stop;
end;
