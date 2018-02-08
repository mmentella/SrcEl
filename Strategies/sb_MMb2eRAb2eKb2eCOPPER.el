{****** - MM.RA.K.COPPER - ********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    COPPER
 TimeFrame: 60 min.
 BackBars:  50
 Date:      03 Gen 2011
*************************************}
vars: lenl(5),kl(.2),lens(7),ks(2),mnymngmnt(1);
vars: stopl(1875),funkl(2150),tl(6325);
vars: stops(1575),funks(3000),ts(5475);

vars: upk(0),lok(0),engine(true),el(true),es(true);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true),nos(1),fnkl(false),fnks(false);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c  < upk;
es = c  > lok;

engine = 700 < t  and t  < 1900;

dru = MM.DailyRunup;
{***************************}
{***************************}
if mnymngmnt = 1 and 700 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trades = 0 and engine then begin

 if not fnkl and marketposition < 1 and el then
  buy("el") next bar at upk stop;
  
 if not fnks and marketposition > -1 and es then
 sellshort("es") next bar at lok stop;
 
end;
{***************************}
{***************************}
