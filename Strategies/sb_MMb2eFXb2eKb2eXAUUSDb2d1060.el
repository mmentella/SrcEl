{******** - MM.FX.K.XAUUSD - **********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    GOLD
 TimeFrame: 60 min.
 BackBars:  50
 Date:      03 Gen 2011
**************************************}
Inputs: lenl(1),kl(.1),lens(2),ks(.1),mnymngmnt(1);
Inputs: stopl(100),funkl(100000),tl(1800);
Inputs: stops(500),funks(100000),ts(1400);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
end;

//if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;

 el = c data2 < upk;
 es = c data2 > lok;
end;

//dru = MM.DailyRunup;
//mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if mnymngmnt = 1 {and 700 < t and t < 2300} then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar at stpv stop;
  if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar at stpv stop;
  if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar at stpv limit;
  if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar at stpv stop;
  if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if mkt then buy to cover("xs.funk") next bar stpv stop;
  if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar at stpv limit;
  if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
if trades = 0 then begin
 if marketposition < 1 and el then
  buy("el") next bar at upk stop;
 if marketposition > -1 and es then
 sellshort("es") next bar at lok stop;
end;
