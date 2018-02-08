Inputs: nos(1),lenl(20),kl(4.1),lens(20),ks(4.6),adxlen(14),adxlimit(30),alfa(.2);
Inputs: stoploss(500),mtrsl(500),brk(2200),tl(1000),ts(1000),tl1(2600),ts1(2800),trsl(2600),trss(2600);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mcp(0);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;

upperk = alfa*upperk + (1-alfa)*upperk[1];
lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

adxval = adx(adxlen)data2;

mcp = MM.MaxContractProfit;
{
condition1 = d < 1020603 or d > 1090601;

if d = 1020603 then setexitonclose;
}
if marketposition <> 0 then begin
 
 setstopshare;
 
 //STOPLOSS
 setstoploss(stoploss);
 if mcp <= mtrsl/bigpointvalue then begin
  if marketposition = 1 then sell("xl") entry("long") next bar at entryprice + (mcp - stoploss/bigpointvalue) stop;
  if marketposition = -1 then buytocover("xs") entry("short") next bar at entryprice - (mcp - stoploss/bigpointvalue) stop;
 end;
 
 //BREAKEVEN
 if mcp > brk/bigpointvalue then begin
  if marketposition = 1 then sell("brkl") entry("long") next bar at entryprice + 100/bigpointvalue stop;
  if marketposition = -1 then buytocover("brks") entry("short") next bar at entryprice - 100/bigpointvalue stop;
 end;
 
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 then sell("tl") entry("long") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") entry("short") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
 end;
 
 //TRAILING STOP
 if currentcontracts = nos/2 then begin
  if marketposition = 1 then begin
   sell("trsl") entry("long") next bar at entryprice + (mcp - trsl/bigpointvalue) stop;
   sell("tl2") entry("long") next bar at entryprice + tl1/bigpointvalue limit;
  end;
  if marketposition = -1 then begin
   buytocover("trss") entry("short") next bar at entryprice - (mcp - trss/bigpointvalue) stop;
   buytocover("t1s") entry("short") next bar at entryprice - ts1/bigpointvalue limit;
  end;
 end;
 
end;

//ENGINE
if adxval < adxlimit {and condition1} and t data2 > 800 and t data2 < 2100 then begin
 if marketposition < 1 and c data2 < upperk and c < upperk and range data2 < AvgTrueRange(lenl) data2 then
  buy("long") nos shares next bar at upperk stop;
 if marketposition > -1 and c data2 > lowerk and c > lowerk and range data2 < AvgTrueRange(lens) data2 then
  sellshort("short") nos shares next bar at lowerk stop; 
end;
{
if adxval < adxlimit and marketposition = 0 then begin
 if c > upperk then sellshort("rs") next bar at upperk stop;
 if c < lowerk then buy("rl") next bar at lowerk stop;
end;
}
