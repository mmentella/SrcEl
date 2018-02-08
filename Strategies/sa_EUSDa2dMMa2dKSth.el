Inputs: nos(2),lenl(20),kl(1.5),lens(20),ks(1.5),adxlen(14),adxlimit(30),alfa(.2);
Inputs: stoploss(100000),brk(100000),tl(100000),ts(100000),trsl(100000),trss(100000);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen);

mpp = MM.MaxContractProfit;

condition1 = d > 1040301 and d < 1071231 or d > 1081101;

if {condition1 and} t > 800 and t < 2200 then begin
 
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
  if marketposition < 1 and c < upperk and range < AvgTrueRange(lenl) then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk and range < AvgTrueRange(lens) then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
 
end;
{
if d >= 1071231 and d < 1081101 then begin
 setexitonclose;
end;
}
