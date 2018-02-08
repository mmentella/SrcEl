Inputs: nos(4),lenl(31),kl(1.54),lens(39),ks(3.87),adxlen(14),adxlimit(29),alfa(.11);
Inputs: stoploss(1850),brk(500),tl(900),ts(1000),trsl(2500),trss(1900);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen)data2;

mpp = MM.MaxContractProfit;

if t data2 > 800 and t data2 < 2200 then begin
 
 setstopshare;
 
 //STOPLOSS
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
 
 //TRAILING STOP
 if currentcontracts = nos/2 then begin
  if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
 end;
 
 //ENGINE
 if adxval < adxlimit then begin
  if marketposition < 1 and c data2 < upperk and c < upperk and range data2 < AvgTrueRange(lenl)data2 then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c data2 > lowerk and c > lowerk and range data2 < AvgTrueRange(lens)data2 then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
 
end;
