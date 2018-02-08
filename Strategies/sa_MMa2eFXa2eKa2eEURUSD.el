{******** - MM.FX.K.EURUSD - **********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    ^EURUSD
 TimeFrame: 60 min.
 BackBars:  50
 Date:      07 Gen 2011
**************************************}
Inputs: lenl(21),kl(4.2),lens(20),ks(4.8),mnymngmnt(1);
Inputs: stopl(2100),funkl(2800);
Inputs: stops(1150),funks(2900);

vars: upk(0),lok(0),el(true),es(true);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
end;

//if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

dru = MM.DailyRunup;
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
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if mkt then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
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
{***************************}
{***************************}
