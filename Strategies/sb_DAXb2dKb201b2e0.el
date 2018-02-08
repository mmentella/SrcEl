Inputs: NoS(2),LenL(4),KL(.24),LenS(40),KS(.8),ADXLen(14),ADXLimit(30);
Inputs: StopLoss(1400),BRKL(1100),BRKS(1100),TL(5000),TS(5000),TRSL(1500),TRSS(1500);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);
adxval = adx(adxlen);
{
if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
 
 //BREAKEVEN
 if mpp > brkl/bigpointvalue and marketposition = 1 then
  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
 if mpp > brks/bigpointvalue and marketposition = -1 then
  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
 
 //STOPLOSS
 if mpp < brkl/bigpointvalue then if marketposition = 1 then
  sell("stopl") next bar at entryprice + (mpp - (stoploss-commission-slippage)/bigpointvalue) stop;
 if mpp < brks/bigpointvalue then if marketposition = -1 then
  buytocover("stops") next bar at entryprice - (mpp - (stoploss-commission-slippage)/bigpointvalue) stop;
 
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
 end;
 
end;
}
//ENGINE
if adxval < adxlimit then begin
 if marketposition < 1 and c < upperk then 
  buy nos shares next bar at upperk stop;
 if marketposition > -1 and c > lowerk then
  sellshort nos shares next bar at lowerk stop;
end;
