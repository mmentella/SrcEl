{****** - MM.DICICCO.PALLADIUM - ********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: DICICCO
 Market:    PALLADIUM
 TimeFrame: 60 min.
 BackBars:  100
 Date:      04 Gen 2011
*************************************}
vars: lenl(5),kl(2.2),lens(100),ks(2.53),mnymngmnt(1);
vars: stopl(3500),funkl(3500),tl(2690);
vars: stops(3100),funks(2790),ts(4000);

vars: upk(0),lok(0),el(true),es(true),engine(true),trades(0);
vars: dru(0),mcp(0),stpv(0),stp(true),mkt(true);
{***************************}
{***************************}
if MM.TradingRights then begin
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

dru = MM.DICICCO.DailyRunup;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = 700 < t and t < 2000;
{***************************}
{***************************}
if mnymngmnt = 1 and 700 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar at stpv stop;
  if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)/bigpointvalue;
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
  stpv = c + (dru + funks*currentcontracts)/bigpointvalue;
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
if trades = 0 and engine then begin
 
 if marketposition < 1 and el then
  buy("el") next bar upk stop;
  
 if marketposition > -1 and es then
  sell short("es") next bar lok stop;
  
end;
{***************************}
{***************************}
END;
{***************************}
{***************************}
