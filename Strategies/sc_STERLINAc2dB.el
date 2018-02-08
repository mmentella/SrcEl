{******** - MM.G1.B.GBP - **********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    BRITISH POUND / US DOLLAR
 TimeFrame: 60 min.
 BackBars:  50
 Date:      17 Gen 2011
**************************************}
Inputs: lenl(16),kl(4.9),lens(20),ks(4.43),mnymngmnt(1);
Inputs: stopl(2100),funkl(1900),modl(100000),tl(5400);
Inputs: stops(3000),funks(2900),mods(100000),ts(4100);

vars: upb(0),lob(0),el(true),es(true),engine(true);
vars: stpv(0),stp(false),mkt(false),trade(0),funk(false),dru(0),mcp(0);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trade = 0;
 funk = false;
end;
{*************************************}
{*************************************}
upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

el = c  < upb;
es = c  > lob;

engine = 800 < t  and t  < 2100;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{*************************************}
{*************************************}
if mnymngmnt = 1 and 800 < t and t < 2250 then begin
  
  if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.spl") next bar stpv stop
  else if mkt then sell("xl.stpl.m") next bar market;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
 end else begin
  
  //STOPLOSS
  stpv = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
    
 end;
  
end;
{*************************************}
{*************************************}
funk = dru <= -minlist(funkl,funks);
{*************************************}
{*************************************}
if not funk and trade < 1 and engine then begin
 if marketposition < 1 and el then
  buy("el") next bar upb stop;
 if marketposition > -1 and es then
  sellshort("es") next bar at lob stop;
end;
{*************************************}
{*************************************}
