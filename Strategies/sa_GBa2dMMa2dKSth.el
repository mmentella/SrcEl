Inputs: nos(2),lenl(20),kl(3.98),lens(20),ks(4.6),adxlen(14),adxlimit(30),alfa(.2);
Inputs: stoploss(500),brk(2200),tl(1000),ts(1000),tl1(2600),ts1(3500),trsl(2600),trss(2600);

Vars: upperk(0),lowerk(0),adxval(0),mpp(0);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen);

mpp = MM.MaxContractProfit;
{
condition1 = d < 1020603 or d > 1090601;

if d = 1020603 then setexitonclose;
}
if marketposition <> 0 then begin
 
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
  if marketposition = 1 then begin
   sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
   sell("tl2") next bar at entryprice + tl1/bigpointvalue limit;
  end;
  if marketposition = -1 then begin
   buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
   buytocover("t1s") next bar at entryprice - ts1/bigpointvalue limit;
  end;
 end;
 
end;

//ENGINE
if adxval < adxlimit {and condition1} and t > 800 and t < 2100 then begin
 if marketposition < 1 and c < upperk and range < AvgTrueRange(lenl) then
  buy("long") nos shares next bar at upperk stop;
 if marketposition > -1 and c > lowerk and range < AvgTrueRange(lens) then
  sellshort("short") nos shares next bar at lowerk stop;
end;
